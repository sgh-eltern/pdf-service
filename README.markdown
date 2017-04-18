# SGH PDF Render Service

[![Build Status](https://travis-ci.org/sgh-eltern/pdf-service.svg?branch=master)](https://travis-ci.org/sgh-eltern/pdf-service) [![](https://images.microbadger.com/badges/image/sghakinternet/pdf-service.svg)](https://microbadger.com/images/sghakinternet/pdf-service "Get your own image badge on microbadger.com")

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

If you have [tmuxinator](https://github.com/tmuxinator/tmuxinator) installed (`gem install tmuxinator`), a simple call to `tmuxinator` will launch the service locally as well as the docker images using `docker-compose`. Have a look at the `.tmuxinator.yml` file to see what will be launched.

# Deployment

The stack is defined in `docker-cloud.yml`. Just change the access key `t0ps3cret` to something other than the default. Make sure you update it in both places within the file.
