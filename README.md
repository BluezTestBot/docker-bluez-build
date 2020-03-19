
# docker-bluez-build

Docker image for Bluez Build

## Manual build

Docker image can be built manually for internal testing:

```bash
docker build . --file Dockerfile --tag bluez-build:<tag>
```

and can be used to test like

```bash
docker run -ti --workdir /github/workspace -v "<local/path>":"/gihub/workspace" bluez-build:<tag> /bin/bash
```

## Build for publishing

Use the following command to build for publishing.

```bash
docker build . --file Dockerfile \
               --tag blueztestbot/bluez-build:latest \
               --tag blueztestbot/bluez-build:<tag>
```

### Publishing to Docker.io

Use the following command to push the image to Docker.io for publishing.

```bash
docker loging -u "<username>" -p "<passowrd>" docker.io
docker push blueztestbot/bluez-build:latest blueztestbot/bluez-build:<tag>
```
