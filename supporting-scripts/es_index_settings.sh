#!/bin/bash
# SOF-ELK® Supporting script
# (C)2023 Lewes Technology Consulting, LLC
#
# This script will apply settings to elasticsearch indices when run

es_host=localhost
es_port=9200
NUMBER_OF_REPLICAS=0
SPECIAL_INDEXES="elastalert_*"
DATA_INDEXES="aws azure evtxlogs filefolderaccess filesystem gcp gws httpdlog lnkfiles logstash logstash-firewall logstash-ids logstash-sflow logstash-switch logstash-windows netflow microsoft365 office365csv plaso zeek kubernetes"

[ -r /etc/sysconfig/sof-elk ] && . /etc/sysconfig/sof-elk

# set replica count
for index in $SPECIAL_INDEXES; do
	curl -s -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -X PUT "http://${es_host}:${es_port}/${index}/_settings" -d"{ \"index\": { \"number_of_replicas\": ${NUMBER_OF_REPLICAS} } }" > /dev/null 2>&1
done
for index in $DATA_INDEXES; do
	curl -s -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -X PUT "http://${es_host}:${es_port}/${index}-*/_settings" -d"{ \"index\": { \"number_of_replicas\": ${NUMBER_OF_REPLICAS} } }" > /dev/null 2>&1
done
