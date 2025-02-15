# load HOSTED_ZONE_ID and NAME from .env file
source .env

TYPE=A
TTL=60
CHANGES_FILE=/tmp/route53_changes.json
CURRENT_VALUE_FILE=./current_route53_value

IP=$(curl https://api.ipify.org/)

# If the IP lookup request doesn't work we early return
if [[ ! $IP =~ ^[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}$ ]]; then
 exit 1
fi

if grep -Fxq "$IP" $CURRENT_VALUE_FILE; then
 echo "IP has not changed after checking local file, exiting"
 exit 1
fi

aws route53 list-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID \
  | jq -r '.ResourceRecordSets[] | select (.Name == "'"$NAME"'.") | select (.Type == "'"$TYPE"'") | .ResourceRecords[0].Value' \
  > $CURRENT_VALUE_FILE

if grep -Fxq "$IP" $CURRENT_VALUE_FILE; then
 echo "IP has not changed after checking AWS, exiting"
 exit 1
fi

cat > $CHANGES_FILE << EOF
{
  "Comment": "Updated From DDNS Shell Script",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "ResourceRecords": [
          {
            "Value": "$IP"
          }
        ],
        "Name": "$NAME",
        "Type": "$TYPE",
        "TTL": $TTL
      }
    }
  ]
}
EOF

aws route53 change-resource-record-sets --hosted-zone-id $HOSTED_ZONE_ID --change-batch file:///tmp/route53_changes.json

echo $IP > $CURRENT_VALUE_FILE

echo "Successfully pdated $NAME IP to $IP"
