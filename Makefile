.PHONY: all

all: cleanup generate deploy

generate:
	go run .

deploy:
	docker run -d --rm --name nginx-http-server -p 80:80 -v `pwd`/public:/usr/share/nginx/html nginx

cleanup: 
	docker rm -f nginx-http-server
