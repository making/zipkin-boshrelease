# Zipkin BOSH Release


## Deplopment

```
bosh sync-blobs
bosh create-release --name=zipkin --force --timestamp-version --tarball=/tmp/zipkin-boshrelease.tgz && bosh upload-release /tmp/zipkin-boshrelease.tgz  && bosh -n -d zipkin deploy manifest/zipkin.yml --no-redact
```