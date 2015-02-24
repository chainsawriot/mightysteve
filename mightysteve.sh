#!/usr/bin/env bash

function checkFile {
    fdate=`GetFileInfo -m "$1"`
    parseddate=(`echo $fdate | sed -e 's/[:/]/ /g'`)
    x="${parseddate[2]}"
    y="${parseddate[0]}"
    echo $x-$y
}

function sortfile {
    dirName=`checkFile $1`
    if [ ! -d $dirName ]; then
	mkdir $dirName
    fi
    mv "$1" "$dirName"
}
# rename any file with space(s) in filename

shopt -s nullglob
for f in *\ *; do
    mv "$f" "${f// /_}";
done

# do the sorting

for image in {*.jpg,*.JPG}; do
    sortfile $image
done

# remove the by-product of "-" folder

if [ -d "-" ]; then
    rmdir '-'
fi
