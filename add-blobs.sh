
#!/bin/sh

DIR=`pwd`

mkdir -p .downloads

cd .downloads


ZIPKIN_VERSION=2.11.8

if [ ! -f ${DIR}/blobs/zipkin/zipkin-server-${ZIPKIN_VERSION}-exec.jar ];then
    curl -L -O -J https://repo1.maven.org/maven2/io/zipkin/java/zipkin-server/${ZIPKIN_VERSION}/zipkin-server-${ZIPKIN_VERSION}-exec.jar
    bosh add-blob --dir=${DIR} zipkin-server-${ZIPKIN_VERSION}-exec.jar zipkin/zipkin-server-${ZIPKIN_VERSION}-exec.jar
fi

cd -
