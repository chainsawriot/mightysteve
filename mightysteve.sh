#!/usr/bin/env bash

# Mighty Steve 1.0.2
# A shell script to perform hazel-like photo sorting operation in Mac OS X
# By Chainsaw Riot (https://github.com/chainsawriot)
# released under MIT License
# tested in Mac OS X 10.10.2

function checkfile {
    fdate=`GetFileInfo -m "$1"`
    parseddate=(`echo $fdate | sed -e 's/[:/]/ /g'`)
    x="${parseddate[2]}"
    y="${parseddate[0]}"
    echo $x-$y
}

## safe version of mv, will add date before extension if filename already existed in the directory
## A work round for no mv -b in BSD mv

function mv_safe {
    if [ -e $2/$1 ]
    then
	fnamet=$1
	extension=${fnamet##*.}
	mv "$1" "$2"/${fnamet%.$extension}_`date +%Y%m%d%H%M%S`.$extension
    else
	mv "$1" "$2"
    fi
}


function sortfile {
    dirName=`checkfile $1`
    if [ ! -d $dirName ]
    then
	mkdir $dirName
    fi
    mv_safe "$1" "$dirName"
}

# rename any file with space(s) in filename

shopt -s nullglob
for f in *\ *
do
    mv "$f" "${f// /_}";
done

# do the sorting

for image in {*.jpg,*.JPG}
do
    sortfile $image
done

# sorting video files

for video in {*.m4v,*.M4V,*.avi,*.AVI,*.mp4,*.MP4}
do
    mv_safe "$video" "Video"
done

# remove the by-product of "-" folder

if [ -d "-" ]
then
    rmdir '-'
fi
