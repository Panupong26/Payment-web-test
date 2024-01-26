#!/bin/bash

registry=dot
name=e-service-api
version=latest
dockerfile=Dockerfile-api
#platform=linux/amd64,linux/arm64
platform=linux/amd64

image=${registry}/${name}$1:${version}

#build project
echo "Building ${image} from ${dockerfile}"

#stop running container
running=$(docker ps -a | grep ${image} | awk {'print$1'})
#echo "running=${running}"
if [ "${running}" != "" ]; then
    docker stop ${running} && docker rm ${running}
fi

docker build --platform=${platform} -f ${dockerfile} -t ${image} ./src/e-service-api/
#docker buildx build --platform=${platform} -f ${dockerfile} -t ${image} .

# cleanup unused generated images
dangling=$(docker images -f "dangling=true" -q)
[ "${dangling}" != "" ] && docker rmi ${dangling}