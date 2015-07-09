#!/bin/bash

if [ "$#" -lt 3 ]
then
  echo "Usage: recursive_gather_cp.sh [SOURCE_DIR] [DEST_DIR] [FILETYPE]"
  echo "example [FILETYPE]: *.bigwig"
  exit 1
fi

SRC=$1
DEST=$2
EXT=$3

if [ ! -d $SRC ]
then
  echo "Source directory ($SRC) doesn't exist!"
  exit 2
fi

if [ ! -d $DEST ]
then
  echo "Destination directory ($DEST) doesn't exist!"
  exit 3
fi

cd $DEST
find $DEST -type l -xtype l -delete
find $DEST -mindepth 1 -type d -empty -delete

cd $SRC

for f in $(find . -type f -name "$EXT" )
do
  BASENAME=$(basename $f)
  DIRNAME=$(dirname $f)

  FULLPATH=$(readlink -f $f)
  DIRNAME2=${DIRNAME#.\/}
  TARGET="${DEST}/${DIRNAME2//\//\_}_${BASENAME}"

  #echo $TARGET
  ln -s $FULLPATH $TARGET
done
