#!/bin/bash

set -euo pipefail

pve_token_id="$${1}"
pve_token="$${2}"
host="$${3}"
vmid="$${4}"
role="$${5}"
uuid="$${6}"

if [[ "$${role}" ==  "master" ]]; then
  sku=${master_sku}
else
  sku=${worker_sku}
fi

curl --silent --insecure -H \
  "Authorization: PVEAPIToken=$${pve_token_id}=$${pve_token}" \
  -X POST \
  ${pm_api_url}/nodes/$${host}/qemu/$${vmid}/status/stop
_ret=$?

if [ $_ret != 0 ]; then
  echo "stopping VM $${vmid} failed"
  exit 1
fi

while ! curl --silent --insecure -H  \
  "Authorization: PVEAPIToken=$${pve_token_id}=$${pve_token}" \
  ${pm_api_url}/nodes/$${host}/qemu/$${vmid}/status/current \
  | jq -r .data.status | grep -q "stopped"; \
  do sleep 5 ;
done

curl --silent --insecure -H \
  "Authorization: PVEAPIToken=$${pve_token_id}=$${pve_token}" \
  -X POST --data-urlencode \
  smbios1="family=${family},sku=$${sku},uuid=$${uuid}" \
  ${pm_api_url}/nodes/$${host}/qemu/$${vmid}/config
_ret=$?

if [ $_ret != 0 ]; then
  echo "updating smbios values for VM $${vmid} failed"
  exit 1
fi

sleep 5

curl --silent --insecure -H \
  "Authorization: PVEAPIToken=$${pve_token_id}=$${pve_token}" \
  -X POST \
  ${pm_api_url}/nodes/$${host}/qemu/$${vmid}/status/start
_ret=$?

if [ $_ret != 0 ]; then
  echo "starting VM $${vmid} failed"
  exit 1
fi
