# SGH PDF Render Service

This is basically an instance of MediaWiki's [electron-render](https://github.com/wikimedia/mediawiki-services-electron-render) service. Instead of limiting access via the `RENDERER_ACCESS_KEY` key, it fronts the service with a simple web server that limits the accepted URLs to those from a whitelist.

# Development

Using docker-machine:

```bash
$ eval "$(docker-machine env default)"
$ docker-compose up
```

To facilitate fast development, the render service exposes its port so that a local web service can connect to it:

```bash
export RENDERER_HOST=$(docker-machine ip default)
export RENDERER_ACCESS_KEY=t0ps3cret
rerun bundle exec rackup
```

# Deployment

The stack is defined in `docker-cloud.yml`. Just change the access key `t0ps3cret` to something other than the default. Make sure you update it in both places within the file.
