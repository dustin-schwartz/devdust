<template>
	<article class="post hentry" :id="'post-id-' + this.post.id">
		<header class="entry-header">
			<time class="entry-date published" :datetime="post.date">{{ longTimestamp( post.date ) }}</time>
			<h1 v-html="widont( post.title.rendered )" class="entry-title"></h1>
		</header>
		<div v-lazy-container="{ selector: 'img' }" class="entry-content">
			<div v-html="post.content.rendered"></div>
		</div>
	</article>
</template>

<script>
export default {
	components: {
	},
	mixins: {
		longTimestamp: Function,
		widont: Function,
	},
	async asyncData( { payload, isStatic, store, params } ) {
		// payload set during static generation
		if ( payload && isStatic ) {
			store.commit('addPosts', [ payload ])
		} else {
			await store.dispatch('getPost', params);
		}
	},
	computed: {
		post() {
			return this.$store.getters.getPostBySlug(this.$route.params.slug)
		},
	},
	methods: {
		featuredImage() {
			let featuredImage = this.post._embedded['wp:featuredmedia']
			if ( featuredImage && featuredImage[0].media_details ) {
				return typeof featuredImage[0].media_details.sizes.large !== 'undefined' ? featuredImage[0].media_details.sizes.large.source_url : featuredImage[0].media_details.sizes.full.source_url;
			} else {
				return '/og-card.png'
			}
		},
	},
	head() {
		return {
			title: this.post.title.rendered,
			bodyAttrs: {
				class: 'single post post-id-' + this.post.id
			},
			meta: [
				{
					hid: 'description',
					name: 'description',
					content: this.post.excerpt.rendered,
				},
				{
					hid: 'og:title',
					property: 'og:title',
					content: this.post.title.rendered + ' • Dustin Schwartz'
				},
				{
					hid: 'og:description',
					property: 'og:description',
					content: this.post.excerpt.rendered
				},
				{
					hid: 'og:image',
					property: 'og:image',
					content: this.featuredImage()
				},
			]
		}
	},
}
</script>
