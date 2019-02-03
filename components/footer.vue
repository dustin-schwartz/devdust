<template>
	<!-- TODO: Add about panel / overlay (possibly served from API) -->
	<!-- TODO: Add page render time -->
	<footer class="footer" role="contentinfo">
		<p>
			&copy; {{year}} Dustin Schwartz. All rights reserved.
			&bull; <a href="https://twitter.com/developerdustin" target="_blank">Twitter</a>
			&bull; <a href="https://github.com/dustin-schwartz" target="_blank">GitHub</a>
			<!--&bull; <a href="https://api.devdust.com/feed/" target="_blank">RSS</a>-->
			&bull; <span class="tooltip" data-tooltip="Code Name: Phoenix">Mark I</span>
			<!--Inital load in {{ generated }} seconds-->
		</p>
		<no-ssr>
			<v-offline onlineClass="notification notification-online" offlineClass="notification notification-offline">
				<div slot="offline">
					<span>Offline</span>
				</div>
			</v-offline>
		</no-ssr>
	</footer>
</template>

<script>
import vOffline from '~/components/v-offline.vue'

export default {
	components: {
		vOffline
	},
	computed: {
		generated() {
			const t = window.performance && performance.timing;
			if ( ! t ) {
				return;
			}
			return ( t.loadEventEnd - t.navigationStart) / 1000;
		},
		isWeb() {
			if ( process.browser && window.location.protocol === 'dat:' ) {
				return false;
			}
			return true;
		},
		dat() {
			return 'dat://devdust.com' + this.$route.path
		},
		web() {
			return 'https://devdust.com' + this.$route.path
		},
		year() {
			let d = new Date();
			return d.getFullYear();
		}
	}
}
</script>
