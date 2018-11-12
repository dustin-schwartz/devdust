# scott.ee

* Status: ✅ Active
* Contributors: [@scottsweb](http://twitter.com/scottsweb)
* Description: My personal website
* Author: [Scott Evans](https://scott.ee)
* Author URI: [https://scott.ee](https://scott.ee)

## About

This is the repo for my personal website created with [nuxt.js](https://nuxtjs.org/). The site is statically generated from a remotely hosted WordPress API. A full write up of how it is put together can be found [on my journal](https://scott.ee/journal/headless-wordpress-api-nuxt-dat/).

The site is hosted on GitHub pages and on the peer to peer web, using [dat](https://datproject.org/) ([dat://scott.ee](dat://scott.ee)).

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

I am also experimenting with changing the URLs within the RSS feed to reduce redirects. The RSS feed is still currently being served from the WordPress side at [api.scott.ee/feed/](https://api.scott.ee/feed/).

```
function pressable_home_url( $home ) {
	if ( is_feed() ) {
		return str_replace( 'api.', '', $home );
	}
	return $home;
}
add_filter( 'home_url', 'pressable_home_url' );
```