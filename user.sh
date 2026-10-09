mount /dev/sr0 /mnt

printf '%s\n' \
'#!/bin/bash' \
'' \
'csv_file="$1"' \
'' \
'# Create OU' \
'awk -F '"'"';'"'"' '"'"'NR>1 {print $5}'"'"' "$csv_file" | sort | uniq | while read ou;' \
'do' \
$'\tsamba-tool ou add OU="$ou",DC=au-team,DC=irpo;' \
'done' \
'' \
'# Create Users' \
'while IFS=";" read -r firstName lastName role phone ou street zip city country password;' \
'do' \
$'\tif [ "$firstName" == "First Name" ];' \
$'\tthen' \
$'\t\tcontinue' \
$'\tfi' \
'' \
$'\tusername="${firstName,,}.${lastName,,}"' \
'' \
$'\tsamba-tool user add "$username" P@ssw0rd1 \\' \
$'\t\t--given-name="$firstName" \\' \
$'\t\t--surname="$lastName" \\' \
$'\t\t--telephone-number="$phone" \\' \
$'\t\t--job-title="$role" \\' \
$'\t\t--userou="OU=$ou"' \
$'\tsamba-tool user setexpiry "$username" --noexpiry' \
'done < "$csv_file"' \
> import_user.sh

chmod +x import_user.sh

./import_user.sh /mnt/Users.csv
