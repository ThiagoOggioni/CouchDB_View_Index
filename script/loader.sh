#!/bin/bash
for i in {00000000000001..0000000001000}
do
echo "Hai $i"
curl -X POST http://admin:adminpw@localhost:15984/couchtest -H 'Content-Type: application/json' -d "{\"_id\": \"$i\",\"attrib1\": \"$RANDOM\",\"attrib2\": \"$RANDOM\",\"attrib3\": \"$RANDOM\",\"attrib4\": [{\"attrib5\": \"$RANDOM\",\"attrib6\": \"$RANDOM\"}],\"attrib7\": \"$RANDOM\",\"attrib8\": \"$RANDOM\",\"attrib9\": \"$RANDOM\",\"attrib10\": \"$RANDOM\",\"attrib11\": \"$RANDOM\",\"attrib12\": \"$RANDOM\",\"attrib13\": \"$RANDOM\",\"attrib14\": \"$RANDOM\",\"attrib15\":\"$RANDOM\",\"attrib16\": \"$RANDOM\",\"attrib17\": \"$RANDOM\",\"attrib18\": \"$RANDOM\",\"attrib19\": \"$RANDOM\",\"attrib20\": \"$RANDOM\"}"
done