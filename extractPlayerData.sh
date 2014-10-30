#!/bin/zsh

play_style=$1
grade_id=$2
dir=$3

for f in $dir/dani*_orig.html; do
  mid=$f:r"_mid.html"
  output=$f:r"_result.txt"
  nkf -Lu $f | nkf -w | sed -e 's|<br>||g' | sed  -e 's|<br */>||g' | sed -e 's/> *</></g' | sed -e 's/ \+/ /g' | sed -e 's/\&copy;//g' > $mid
  ruby read_html.rb $mid > $output
  rm -f $mid
done
cat $dir/dani*_result.txt | grep "/game" > $dir/result.txt
