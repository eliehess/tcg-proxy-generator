#!/bin/bash

# Put your pokemontcg.io key in a file named pokemontcg.io.key
api_key=$(cat ./pokemontcg.io.key)

# Assumes input is formatted like "<quantity> <name> (<PTCGO set code> <number in set>)"
# E.g. 4 Professor Oak's New Theory (CL 83)
(cat "$1"; echo) | while read -r card; do
	[[ -z $card ]] && continue

	withoutquantity=$(echo "${card#* }" | tr -d '\r')
	name="${withoutquantity%% (*}"

	insideparens=$(echo "${card#*\(}" | tr -d ')')
	ptcgocode="${insideparens%% *}"
	setnumber="${insideparens#* }"
	[[ -z $ptcgocode || -z $setnumber ]] && echo "WARNING: Couldn't find a PTCGO code and/or set number for $withoutquantity" >> /dev/stderr && continue

	outfile="images/png/${name} (${ptcgocode} ${setnumber}).png"
	[[ -f "$outfile" ]] && echo "File $outfile already exists" && continue

	if [[ -z $apikey ]]; then
		apiresponse=$(curl -s --request GET --url "https://api.pokemontcg.io/v2/cards?q=set.ptcgoCode:$ptcgocode%20number:$setnumber")
	else
		apiresponse=$(curl -s --request GET --header "X-Api-Key: $api_key" --url "https://api.pokemontcg.io/v2/cards?q=set.ptcgoCode:$ptcgocode%20number:$setnumber")
	fi

	count=$(echo "$apiresponse" | jq ".totalCount")
	[[ $count -ne 1 ]] && echo "WARNING: Expected 1 card with PTCGO code $ptcgocode and number $setnumber, but received $count" >> /dev/stderr && continue

	url=$(echo "$apiresponse" | jq ".data[0].images.large" | tr -d '"')
	[[ -z "$url" ]] && echo "WARNING: Didn't find an image to download for $withoutquantity" >> /dev/stderr && continue

	mkdir -p images/png
	curl -s --request GET --output "$outfile" --url "$url" && echo "Successfully downloaded $outfile"
done
