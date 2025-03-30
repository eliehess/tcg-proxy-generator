#!/bin/bash

language="eg" # Available languages: English (eg), German (de), Spanish (es), French (fr) and Italian (it).

# Assumes input is formatted like "<quantity> <name> (<serial number>)"
# E.g. 3 Yuna (1-214S)
(cat "$1"; echo) | while read -r card; do
	[[ -z $card ]] && continue

	withoutquantity=$(echo "${card#* }" | tr -d '\r')
	serialnumber=$(echo "${withoutquantity##*\(}" | tr -d ')')

	url="https://fftcg.cdn.sewest.net/images/cards/full/${serialnumber}_${language}.jpg"
	outfile="images/$withoutquantity.jpg"

	[[ -f "$outfile" ]] && echo "File $outfile already exists" && continue

	mkdir -p images
	curl -s --request GET --output "$outfile" --url "$url" && echo "Successfully downloaded $outfile"
done
