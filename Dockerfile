FROM ibmcom/swift-ubuntu-runtime:4.1

ADD .build/release/ /usr/share/naamio/

ENV NAAMIO_PORT=8090

EXPOSE ${NAAMIO_PORT}

WORKDIR /usr/share/naamio/

ENTRYPOINT ["/usr/share/naamio/Naamio"]