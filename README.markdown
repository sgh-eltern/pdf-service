# SGH PDF Service

This is basically an instance of MediaWiki's [electron-render](https://github.com/wikimedia/mediawiki-services-electron-render) service. Instead of limiting access via the `RENDERER_ACCESS_KEY` key, it fronts the service with a simple web server that limits the accepted URLs to those from a whitelist.
