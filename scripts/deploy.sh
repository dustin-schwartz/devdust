# TODO: https://stackoverflow.com/a/246128
# TODO: Dust - Deployment
# generate the app - switch to content only
npm run generate

# copy dist into dat archive
# dat sync will be running and pick up changes
cp dist/. ../devdust.com.dat/ -r

# deploy to Netlify
# 104.198.14.52
#netlifyctl deploy -b dist/

# deploy to GitHub
# 185.199.109.153
#npm run deploy-gh

# sync to dat
# do this from dat folder
#dat sync
