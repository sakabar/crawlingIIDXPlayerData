#!/bin/zsh

function change_proxy(){
  export http_proxy=http://`cat proxy_list.txt | grep -v "^#" | sort -R | head -n1`/
}

function my_wget(){
  change_proxy
  wget $1 --load-cookies=cookies.txt -T10 --tries=1 -O $2
}

play_style=$1
grade_id=$2
play_style=1
grade_id=14
date_dir=`date "+%Y%m%d"`
dir=./data/$date_dir/$play_style/$grade_id
dir="./data/20141018/1/14"



domain="http://p.eagate.573.jp"
 
for url in `awk -F, '{print $1}' $dir/result.txt`; do
  player_url=$domain$url
  output=$dir"/nagisa.html"

  my_wget $player_url $output

  #wgetが失敗したら、proxyを切り換えて再試行
  # $? は直前のコマンドの終了ステータス(0が正常)
  if test $? -ne 0; then
    bad_proxy=`echo $http_proxy | sed -e 's|^http://||' -e 's|/$||'`
    tmp_file=`mktemp`
    grep -v $bad_proxy proxy_list.txt > $tmp_file
    echo "#"$bad_proxy >> $tmp_file
    mv $tmp_file proxy_list.txt

    my_wget $player_url $output
  fi
exit
done
