# SGH PDF Render Service

This is basically an instance of MediaWiki's [electron-render](https://github.com/wikimedia/mediawiki-services-electron-render) service. Instead of limiting access via the `RENDERER_ACCESS_KEY` key, it fronts the service with a simple web server that limits the accepted URLs to those from a whitelist.

## Deployment

* to a docker-machine named `production`:

  ```
  $ eval "$(docker-machine env production)"
  $ docker-compose up -d
  ```

* via docker-cloud:

  The stack is defined in `docker-cloud.yml`. Just change the access key `t0ps3cret` to something other than the default. Make sure you update it in both places within the file.
