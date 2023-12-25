## help: print this help message
.PHONY: help
help: 
	@echo 'Usage'
	@sed -n "s/^##//p" ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'

## clean: clean builds and refresh pub
.PHONY: clean
clean:
	fvm flutter clean; fvm flutter pub get;


## build/web: build web
.PHONY: clean
build/web:
	fvm flutter build web;

## deploy/web: deploy web
.PHONY: clean
deploy/web:
	firebase deploy --only=hosting;
