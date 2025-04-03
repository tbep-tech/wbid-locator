# wbid-locator

Simple ShinyLive application to identify a WBID from a point location.  All WBIDs are those in Tampa Bay and its watershed.

### Deploy

The app is hosted with ShinyLive on GitHub Pages.  Update and deploy as follows. 

1. Perform any updates to the app in `app\app.R`. 
1. Run `shinylive::export('app', 'site')` to convert/update the app from the `app` folder to a ShinyLive app in the `site` folder. 
1. Push changes to GitHub, where the app is exposed in the `site` folder.  The repository must be deployed on GitHub pages.

The ShinyLive app can be tested locally using `httpuv::runStaticServer("site/")`.  

ShinyLive doesn't like relative file paths, so any external data must be in the `data` folder and loaded as `data(mydata)` and not `load(file = here::here('data/mydata.RData'))`.
