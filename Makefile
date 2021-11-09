.PHONY: all

all: generate deploy

generate:
	go run .

deploy:
	docker run -d --rm --name swagger-ui -p 80:8080 -e SWAGGER_JSON=/foo/openapi.yaml -v `pwd`:/foo swaggerapi/swagger-ui

cleanup: 
	docker rm -f swagger-ui
