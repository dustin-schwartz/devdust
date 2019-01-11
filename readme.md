# devdust.com

* Status: ✅ Active
* Contributors: [@developerdustin](http://twitter.com/developerdustin)
* Description: My personal website
* Author: [Dustin Schwartz](https://devdust.com)
* Author URI: [https://devdust.com](https://devdust.com)

## About

This is the repo for my personal website created with [nuxt.js](https://nuxtjs.org/). The site is statically generated from a remotely hosted WordPress API. This site was a fork from [Scott Evans](https://github.com/scottsweb/scott.ee), with the initial build notes [here](https://scott.ee/journal/headless-wordpress-api-nuxt-dat/).

The site is hosted on GitHub pages and on the peer to peer web, using [dat](https://datproject.org/) ([dat://devdust.com](dat://devdust.com)).

## Development / Building

``` bash
# install dependencies
$ npm install # Or yarn install

# serve with hot reload at localhost:3000
$ npm run dev

# generate static project
$ npm run generate

# generate content only (use when new content is posted to WP)
$ npm run generate-content

# push the dist branch to GitHub pages
$ npm run deploy-gh
```

## WordPress Images

To enable lazyload compatability add the following code to your WordPress site:

```
function add_lazyload( $content ) {
	// exit early if not API request
	if ( ! defined( 'REST_REQUEST' ) ) {
		return $content;
	}

	$content = mb_convert_encoding( $content, 'HTML-ENTITIES', 'UTF-8' );
	$dom = new DOMDocument();
	@$dom->loadHTML( $content );

	$div = $dom->createElement( 'div' );
	$div->setAttribute( 'class', 'lazy' );

	// Convert Images
	$images = [];

	foreach ( $dom->getElementsByTagName( 'img' ) as $node ) {
		$images[] = $node;
	}

	foreach ( $images as $node ) {
		$fallback = $node->cloneNode( true );
		$wrapper = $div->cloneNode();

		$oldsrc = $node->getAttribute( 'src' );
		$node->setAttribute( 'data-src', $oldsrc );
		$node->setAttribute( 'src', '' );

		// extract dimensions from src and calculate an aspect ratio
		$regex = '/resize=([0-9]*)%2C([0-9]*)/m';
		preg_match( $regex, $oldsrc, $matches );
		if ( is_array( $matches ) && ! empty( $matches ) ) {
			$wrapper->setAttribute( 'data-width', $matches[1] );
			$wrapper->setAttribute( 'data-height', $matches[2] );
			$wrapper->setAttribute( 'style', '--ratio:' . round( ( $matches[2] / $matches[1] ) * 100, 2 ) . '%;' );
		} else {
			$wrapper->setAttribute( 'style', '--ratio: 50%;' );
		}

		$oldsrcset = $node->getAttribute( 'srcset' );
		$node->setAttribute( 'data-srcset', $oldsrcset );
		$node->setAttribute( 'srcset', '' );

		$noscript = $dom->createElement( 'noscript', '' );
		$node->parentNode->insertBefore( $noscript, $node );
		$noscript->appendChild( $fallback );

		$node->parentNode->replaceChild( $wrapper, $node );
		$wrapper->appendChild( $node );
	}

	$newhtml = preg_replace( '/^<!DOCTYPE.+?>/', '', str_replace( array( '<html>', '</html>', '<body>', '</body>' ), array( '', '', '', '' ), $dom->saveHTML() ) );
	return $newhtml;
}
add_filter( 'the_content', 'add_lazyload', 100 );
add_filter( 'post_thumbnail_html', 'add_lazyload', 100 );
```

## WordPress Redirect Functionality

To redirect your WordPress site / API to production you can use this snippet. It might be an idea not to redirect logged in users in order to preserve the post preview functionality in WordPress.

```
function add_redirects() {
	global $wp;
	if ( ! is_admin() && ! is_feed() ) {
		wp_redirect( str_replace( 'api.', '', home_url( $wp->request ) ), 301 );
		exit;
	}
}
add_filter( 'template_redirect', 'add_redirects' );
```

## WordPress Feed URLs

I am also experimenting with changing the URLs within the RSS feed to reduce redirects. The RSS feed is still currently being served from the WordPress side at [api.devdust.com/feed/](https://api.devdust.com/feed/).

```
function fix_feed_home_url( $home ) {
	if ( is_feed() ) {
		return str_replace( 'api.', '', $home );
	}
	return $home;
}
add_filter( 'home_url', 'fix_feed_home_url' );
```

## Further Reading

* https://github.com/nuxt-community/awesome-nuxt/
* https://github.com/nuxt/todomvc
* https://github.com/nuxt/hackernews
* https://github.com/krestaino/nuepress
* https://vuejsdevelopers.com/2017/04/22/vue-js-libraries-plugins/
* https://github.com/nuxt-community/nuxt-generate-cluster
* https://medium.com/vue-mastery/best-practices-for-nuxt-js-seo-32399c49b2e5
* https://medium.com/wdstack/vue-vuex-getting-started-f78c03d9f65
* https://medium.com/ax2-inc/use-nuxts-build-templates-property-to-contextually-generate-files-587761251f78
* https://css-tricks.com/simple-server-side-rendering-routing-page-transitions-nuxt-js/
