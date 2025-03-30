# tcg-proxy-generator

A generic proxy generator for TCG cards

Based on [fftcg-proxy-generator](https://github.com/guillegran/fftcg-proxy-generator) which is itself based on [Yu-Gi-Oh! Proxy Generator](https://github.com/FedericoHeichou/ygo-proxy-generator).

## Requirements

A unix-like terminal with the following programs:

- curl
- imagemagick
- jq
- pdflatex (package is named texlive-latex-base; you may also need to install texlive-fonts-recommended and texlive-latex-extra)
- tr

## Usage

1. Download images in jpg format for the cards you want to generate and put them in a folder named `images`.

    - The exact filenames don't matter, as long as they don't start with a number.
    - For convenience, if you have png or webp images, put them inside folders named `images/png` or `images/webp` as appropriate and the generator script will convert them to jpg for you.

2. Create a txt file with the decklist you want to generate. Each line in the txt file should have an identical name to an image in the `images` folder.
    - You can represent multiples of a single card by prefixing that cardname with a numeric quantity, optionally followed by any number of spaces. For example, assuming the `images` folder contains `BlackLotus.jpg`, this

        > BlackLotus\
        > BlackLotus

        is the same as

        > 2BlackLotus

        as well as

        > 2&nbsp;&nbsp;&nbsp;BlackLotus

3. Run `./generate.sh <path_to_decklist>`.
    - If no path is specified, it will default to reading from `input.txt`

4. Wait for `deckname.pdf` to be created
