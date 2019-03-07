
#!/bin/sh

DIR=`pwd`

mkdir -p .downloads

cd .downloads


ZIPKIN_VERSION=2.12.5
ZIPKIN_DEPENDENCIES_VERSION=2.0.6

# if [ ! -f ${DIR}/blobs/zipkin/zipkin-server-${ZIPKIN_VERSION}-exec.jar ];then
#     curl -L -O -J https://repo1.maven.org/maven2/io/zipkin/java/zipkin-server/${ZIPKIN_VERSION}/zipkin-server-${ZIPKIN_VERSION}-exec.jar
#     bosh add-blob --dir=${DIR} zipkin-server-${ZIPKIN_VERSION}-exec.jar zipkin/zipkin-server-${ZIPKIN_VERSION}-exec.jar
# fi

if [ ! -f ${DIR}/blobs/zipkin-dependencies/zipkin-dependencies-${ZIPKIN_DEPENDENCIES_VERSION}.jar ];then
    curl -L -O -J https://repo1.maven.org/maven2/io/zipkin/dependencies/zipkin-dependencies/${ZIPKIN_DEPENDENCIES_VERSION}/zipkin-dependencies-${ZIPKIN_DEPENDENCIES_VERSION}.jar
    bosh add-blob --dir=${DIR} zipkin-dependencies-${ZIPKIN_DEPENDENCIES_VERSION}.jar zipkin-dependencies/zipkin-dependencies-${ZIPKIN_DEPENDENCIES_VERSION}.jar
fi

cd -
