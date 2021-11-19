# OpenAPI HTML Documentation Generator

Generates OpenAPI doc as `openapi.json` and `public/service.yaml` based on the CUE schema `service.cue` and deploys it to nginx Docker container.  The UI served is from [Stoplight Elements](https://stoplight.io/open-source/elements/).

>  Elements is an API Documentation toolkit, leveraging OpenAPI and Markdown (CommonMark) to provide beautiful, interactive API reference documentation, that you can integrate with any existing content-management system or single-page application

## Development
Be sure you don't have listener on port `localhost:80` as that is where nginx is hosted.

1. `$ make`

2. Open browser http://localhost

To execute tests, use standard library. i.e.

`go test -v -count=1 ./...`
