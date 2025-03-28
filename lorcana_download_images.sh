#!/bin/bash

# Assumes input is formatted like "<quantity> <name> - <subtitle>"
# E.g. 4 Maui - Hero to All
# TODO: Add support for card variants
(cat "$1"; echo) | while read -r card; do
	[[ -z $card ]] && continue

	withoutquantity=$(echo "${card#* }" | tr -d '\r')

	outfile="images/png/${withoutquantity}.png"
	[[ -f "$outfile" ]] && echo "File $outfile already exists" && continue

	urlencodedname=$(jq -rn --arg x "$withoutquantity" '$x|@uri')
	apiresponse=$(curl -s --request GET --url "https://api.lorcana-api.com/cards/fetch?strict=$urlencodedname")

	object=$(echo "$apiresponse" | jq ".object")
	[[ $object = 'error' ]] && echo "WARNING: received an error for card $card" >> /dev/stderr && continue

	url=$(echo "$apiresponse" | jq ".[0].Image" | tr -d '"')
	[[ -z "$url" ]] && echo "WARNING: Didn't find an image to download for $card" >> /dev/stderr && continue

	mkdir -p images/png
	curl -s --request GET --output "$outfile" --url "$url" && echo "Successfully downloaded $outfile"
done
