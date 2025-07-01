#!/bin/sh

# set or auto-incrememnt version number

verfile=.version
header="$1"
shift

old_ver=""
if [ -e $verfile ]; then
  # get last version number
  read old_ver < $verfile
fi

if [ -n "$1" ]; then
  # use specified version number
  ver="$1"
else
  ver=${old_ver:-0.0-unknown}
  # increment version number
  ver=`echo "$ver" | perl -pe 'sub n { @v=split /\./, shift; ++$v[2]; join(".", @v) } s/([\d.]+)/n($1)/e'`
fi

echo "$ver"

if [ -z "$header" ]; then
  exit 1
fi

# update version number files
if [ x"$old_ver" != x"$ver" ]; then
  echo "$ver" > $verfile
  cat - <<EOF >$header
#ifndef PROJECT_VERSION
#define PROJECT_VERSION "$ver"
#endif
EOF
fi
