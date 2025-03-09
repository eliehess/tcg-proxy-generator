#!/bin/bash
# Usage: ff_download_images.sh <input_file>
# Cards in the input file should look like "15-139S"

language="eg" #Available languages: English (eg), German (de), Spanish (es), French (fr) and Italian (it).

while read card; do
	url="https://fftcg.cdn.sewest.net/images/cards/full/${card}_${language}.jpg"
	outfile="images/${card}_${language}.jpg"

	# skip already existing images
	[ -f $outfile ] && continue

	wget -O $outfile $url
done < $1
