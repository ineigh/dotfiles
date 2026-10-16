UGREEN_NODE="$(pactl -f json list sources | jq -r '.[] | select(.name | contains("UGREEN")) | .name')"
export UGREEN_NODE
