FROM alpine:edge

RUN apk add --no-cache git \
	git \
	tzdata \
	openssl-dev \
	build-base cmake \
	boost-dev \
	boost-thread \
	boost-system \
	boost-date_time \
	sqlite sqlite-dev \
	curl libcurl curl-dev \
	libusb libusb-dev \
	coreutils \
	zlib zlib-dev \
	udev eudev-dev \
	python3-dev \
	linux-headers && \
	cp /usr/share/zoneinfo/Europe/Paris /etc/localtime && \
	git clone --depth 2 https://github.com/OpenZWave/open-zwave.git /src/open-zwave && \
	cd /src/open-zwave && \
	make && \
	ln -s /src/open-zwave /src/open-zwave-read-only && \
	git clone -b ${BRANCH_NAME:-master} --depth 2 https://github.com/domoticz/domoticz.git /src/domoticz && \
	cd /src/domoticz && \
	git fetch --unshallow && \
	cmake -DCMAKE_BUILD_TYPE=Release . && \
	make && \
	rm -rf /src/domoticz/.git && \
	rm -rf /src/open-zwave/.git && \
	apk del git tzdata cmake linux-headers libusb-dev zlib-dev openssl-dev boost-dev sqlite-dev build-base eudev-dev coreutils curl-dev python3-dev 

#	libssl1.0 openssl-dev \

VOLUME /config /src/domoticz/scripts/lua

EXPOSE 8080

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost:8080/ || exit 1

ENTRYPOINT ["/src/domoticz/domoticz"]
CMD ["-www", "8080", "-dbase", "/config/domoticz.db","-log","/config/domoticz.log"]
