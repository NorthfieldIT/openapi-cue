# OpenAPI HTML Documentation Generator

Generates OpenAPI doc as `openapi.json` and `openapi.yaml` based on the CUE schema `service.cue` and deploys it to swagger-ui Docker container.

## Development
Be sure you don't have listener on port `localhost:80` as that is where swagger-ui is hosted.

1. `$ make`

2. Open browser http://localhost