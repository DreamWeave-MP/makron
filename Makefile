VERSION = $(shell git describe --tags || echo 0)

all build:
	./build.sh

clean:
	rm -fr *.esm *\~* *.zip

image: build
	docker build . -t magicaldave1/makron:$(VERSION)

vanilla:
	./build.sh vanilla

tsi:
	./build.sh tsi
