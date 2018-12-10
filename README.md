# Zipkin BOSH Release

## How to deploy

### Standard (InMemory Storage)

```
bosh -d zipkin deploy manifest/zipkin.yml \
  -l manifest/versions.yml \
  --no-redact
```

###  Elasticsearch Storage

```
bosh -d zipkin deploy manifest/zipkin.yml \
  -l manifest/versions.yml \
  -o manifest/ops-files/elasticsearch.yml \
  --no-redact
```

You can link an exinsting elasticsearch in other deployments (ex. [elastic-stack-bosh-deployment](https://github.com/bosh-elastic-stack/elastic-stack-bosh-deployment)) with [cross-deployment linking](https://bosh.io/docs/links/#cross-deployment) instead of provisioning a new instance:

```
bosh -d zipkin deploy manifest/zipkin.yml \
  -l manifest/versions.yml \
  -o manifest/ops-files/consume-elasticsearch-from-different-deployment.yml \
  -v elasticsearch-from=elasticsearch-master \
  -v elasticsearch-deployment=elastic-stack \
  --no-redact
```

###  Enable Kibana

```
bosh -d zipkin deploy manifest/zipkin.yml \
  -l manifest/versions.yml \
  -o manifest/ops-files/elasticsearch.yml \
  -o manifest/ops-files/kibana.yml \
  --no-redact
```

### Enable Curator

```
bosh -d zipkin deploy manifest/zipkin.yml \
  -l manifest/versions.yml \
  -o manifest/ops-files/elasticsearch.yml \
  -o manifest/ops-files/curator.yml \
  --no-redact
```

Use Curator to clean up indexes that are more than 7 days old.

curator can be invoked by the following command

```
bosh -d zipkin run-errand curator
```

or cron can be enabled as well

```
bosh -d zipkin deploy manifest/zipkin.yml \
  -l manifest/versions.yml \
  -o manifest/ops-files/elasticsearch.yml \
  -o manifest/ops-files/curator.yml \
  -o manifest/ops-files/curator-cron.yml \
  --no-redact
```

curator will run at 00:00 every day.

### Scale out

```
bosh -d zipkin deploy manifest/zipkin.yml \
  -l manifest/versions.yml \
  -o manifest/ops-files/elasticsearch.yml \
  -o manifest/ops-files/curator.yml \
  -o manifest/ops-files/curator-cron.yml \
  -o manifest/ops-files/instances.yml \
  -v zipkin_instances=1 \
  -v elasticsearch_master_instances=3 \
  --no-redact
```

### All in one VM

```
bosh -d zipkin deploy manifest/zipkin.yml \
  -l manifest/versions.yml \
  -o manifest/ops-files/elasticsearch.yml \
  -o manifest/ops-files/colocated-elasticsearch.yml \
  -o manifest/ops-files/kibana.yml \
  -o manifest/ops-files/colocated-kibana.yml \
  -o manifest/ops-files/curator.yml \
  -o manifest/ops-files/curator-cron.yml \
  --no-redact
```

Elasticseach and Kibana are colocated at the Zipkin server.

### Enable aggregate-dependencies errand

Currently only the case is supported which uses Elasticsearch and consumes it as a bosh link.

```
bosh -d zipkin deploy manifest/zipkin.yml \
  -l manifest/versions.yml \
  -o manifest/ops-files/elasticsearch.yml \
  -o manifest/ops-files/aggregate-dependencies-elasticsearch.yml \
  -v elasticsearch-from=elasticsearch-master \
  -v elasticsearch-deployment=zipkin \
  --no-redact
```

or

```
bosh -d zipkin deploy manifest/zipkin.yml \
  -l manifest/versions.yml \
  -o manifest/ops-files/consume-elasticsearch-from-different-deployment.yml \
  -o manifest/ops-files/aggregate-dependencies-elasticsearch.yml \
  -v elasticsearch-from=elasticsearch-master \
  -v elasticsearch-deployment=elastic-stack \
  --no-redact
```

then


```
bosh run-errand -d zipkin aggregate-dependencies
```

## Development

```
bosh sync-blobs
bosh create-release --name=zipkin --force --timestamp-version --tarball=/tmp/zipkin-boshrelease.tgz && bosh upload-release /tmp/zipkin-boshrelease.tgz 
bosh -n -d zipkin deploy manifest/zipkin.yml \
  -l manifest/versions.yml \
  -o manifest/ops-files/dev.yml \
  --no-redact
```