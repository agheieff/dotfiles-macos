#!/bin/bash
price=$(curl -s https://api.coindesk.com/v1/bpi/currentprice.json | jq -r '.bpi.USD.rate | gsub(","; "") | tonumber | floor')
echo "{\"text\": \"BTC $price\"}"
