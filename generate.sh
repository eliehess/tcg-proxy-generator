#!/bin/bash

function generate_tex() {
	line_count=0

	(cat "$1"; echo) | while read -r card; do
		[[ -z $card ]] && continue
		# The leading part of the card string, if it's a number, potentially followed by any number of spaces
		prefix=$(echo "$card" | grep -Eo '^[0-9]+[[:space:]]*')
		# Just the number part of the above input, or 1 if not matched
		numberofcards=$(echo "$prefix" | grep -Eo '^[0-9]+' || echo 1)
		# The actual card name
		cardname="${card:${#prefix}}" || $card

		for _ in $(seq 1 "$numberofcards"); do
			if [[ ! -f images/$cardname.jpg ]]; then
				echo "WARNING: no file images/$cardname.jpg found" >> /dev/stderr
			fi

			echo "\card{$cardname}%"

			((line_count++))
			if [[ $line_count -eq 3 ]]; then
				line_count=0
				echo '\\[-0.34mm]'
			fi
		done
	done
}

function convert_filetype_to_jpg() {
	filetype=$1
	# Bail if the folder doesn't exist or if it has no relevant files
	cd "images/$filetype" &> /dev/null || return
	ls ./*."$filetype" &> /dev/null || return

	for file in *."$filetype"; do
		jpgname="${file%"$filetype"}jpg"
		if [[ ! -f "../$jpgname" ]]; then
			convert "$file" "../$jpgname"
		fi
	done

	cd ../..
}

if [[ -z $1 ]]; then
	input="input.txt"
	output="output"
else
	input=$1
	output=$(basename "${1%.*}")
fi

if [[ ! -f "$input" ]]; then
	echo "Didn't see a file $input"
	exit 0
fi

echo "Converting images..."
for type in "png" "webp"; do
	convert_filetype_to_jpg $type
done

echo "Generating cards.tex..."
generate_tex "$input" > "tex/cards.tex"

echo "Creating pdf..."
mkdir -p tex/.pdflatex
pdflatex -interaction batchmode -jobname "$output" -output-directory tex/.pdflatex tex/proxies.tex 1>/dev/null

if [[ -f "tex/.pdflatex/$output.pdf" ]]; then
	mv "tex/.pdflatex/$output.pdf" "$output.pdf"
	echo "All done!"
else
	echo "Something went wrong; no output file detected"
fi
