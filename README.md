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

## Deplopment

```
bosh sync-blobs
bosh create-release --name=zipkin --force --timestamp-version --tarball=/tmp/zipkin-boshrelease.tgz && bosh upload-release /tmp/zipkin-boshrelease.tgz 
bosh -n -d zipkin deploy manifest/zipkin.yml \
  -l manifest/versions.yml \
  -o manifest/ops-files/dev.yml \
  --no-redact
```