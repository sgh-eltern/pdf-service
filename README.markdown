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

The stack is defined in `docker-cloud.yml`. Make sure you change the access key `t0ps3cret` to something other than the default (update it in both places within the file).

Before anything else, login to the Docker cloud using `docker login`.

## Create the Node Cluster

### Digital Ocean

This is a provider natively supported by Docker Cloud. Just create a node cluster on DO, assuming the account is already linked:

```bash
docker-cloud nodecluster create sandbox digitalocean fra1 1gb
```

### ScaleWay

1. Create a [new server](https://cloud.scaleway.com/#/zones/ams1/servers/new) using the docker image:

  - Location: Amsterdam
  - Server Type: VC1S
  - Image: Docker 1.12.2
  - Storage: 50 GB LSSD

  Use the console:

  ```bash
  brew install scw
  scw login --token 01234567-89ab-cdef-0123-456789abcdef --organization me --skip-ssh-key # not the real token

  # create the server and run the docker-cloud node bootstrap
  docker-cloud node byo | grep curl | xargs scw --region=ams1 run --commercial-type=VC1L --ipv6=true docker
  ```

  If you want to get rid of the server again, try `scw stop --terminate=true SERVER` which should remove all volumes, too.

1. Verify that the node is registered in the Docker cloud:

  ```bash
  docker-cloud node ls
  ```

## Deploy the Stack

1. Start the stack for the first time:

  ```bash
  docker-cloud stack up -f docker-cloud.yml
  ```

  Subsequent deployments, even to different nodes, will be a simple re-deploy:

  ```bash
  docker-cloud stack redeploy pdf-service
  ```

1. Show the public endpoint:

  ```bash
  docker-cloud service inspect web | jq -r .public_dns
  ```

1. Display logs:

  ```bash
  docker-cloud service logs web --follow
  ```

# Backup

_Note that we don't maintain any state (yet), so the following isn't necessary._

Just follow the docs to [download volume data for backup](https://docs.docker.com/docker-cloud/getting-started/deploy-app/12_data_management_with_volumes/#download-volume-data-for-backup) and make sure you use the `tutum/ubuntu` image as it keeps running.

SSH is also possible:

```bash
ssh -p 2222 root@downloader-1.$DOCKER_ID_USER.svc.dockerapp.io:/data .
```
