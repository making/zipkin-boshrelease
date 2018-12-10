#!/bin/bash

# If a command fails, exit immediately
set -e

export JAVA_HOME=/var/vcap/packages/java
export PATH=${PATH}:${JAVA_HOME}/bin

<%
  if "elasticsearch".casecmp(link("zipkin").p("zipkin.storage_type")) == 0 then
  	es_hosts = link("elasticsearch").instances.map {|e| link("zipkin").p("elasticsearch.protocol") + "://" + e.address + ":" + link("zipkin").p("elasticsearch.port")}
%>
export STORAGE_TYPE=elasticsearch
export ES_HOSTS=<%= es_hosts.join(",") %>
export ES_INDEX=<%= link("zipkin").p("elasticsaerch.index") %>
<%
  end
%>

java -jar /var/vcap/packages/zipkin-dependencies/zipkin-dependencies.jar \
<% if_p('zipkin_dependencies.days_to_look_back') do |days_to_look_back| %>  `date -u -d '<%= days_to_look_back %>' +%F` \<% end %>

