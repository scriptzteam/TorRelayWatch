#!/bin/bash

mkdir -p data/relays-added-by-date/"$(date +%Y)/$(date +%m)/$(date +%d)"

echo '| Nickname |  Hashed Fingerprint	| Or Addresses | Contact | Running | Flags | Last Seen | First Seen | Last Restarted | Advertised Bandwidth | Platform | Version | Version Status | Recommended Version | Verified hostnames | Exit policy |' > data/relays-added-by-date/"$(date +%Y)/$(date +%m)/$(date +%d)"/Readme.md
echo '|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|' >> data/relays-added-by-date/"$(date +%Y)/$(date +%m)/$(date +%d)"/Readme.md

TODAY=$(date +%F) # gets YYYY-MM-DD

curl -s "https://onionoo.torproject.org/details" | jq -r --arg TODAY "$TODAY" '
  .relays[]
  | select((.first_seen // "") | startswith($TODAY))
  | [
      (.nickname // "N/A"),
      (.fingerprint // "N/A"),
      (.or_addresses // "N/A"),
      (.contact // "N/A"),
      (.running | tostring),
      ((.flags // []) | join(", ")),
      (.last_seen // "N/A"),
      (.first_seen // "N/A"),
      (.last_restarted // "N/A"),
      ((.advertised_bandwidth // 0) | tostring),
      (.platform // "N/A"),
      (.version // "N/A"),
      (.version_status // "N/A"),
      ((.recommended_version // false) | tostring),
      (.verified_host_names	 // "N/A"),
      (.exit_policy // "N/A")

    ]
  | map(tostring | gsub("\\|"; "\\|") | gsub("\\\\"; "\\\\"))
  | join(" | ")
  | "|" + . + "|"
' >> data/relays-added-by-date/"$(date +%Y)/$(date +%m)/$(date +%d)"/Readme.md
