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
dir=$3

domain="http://p.eagate.573.jp"
 
#trしないと、スペースで切れる
for line in `cat $dir/result.txt | tr ' ' '_'`; do
  url=`echo $line | awk -F, '{print $1}'`

  #保存するファイル名はどうする?
  player_url=$domain$url
  # output=$dir"/nagisa.html"
  output=`mktemp`
  # echo $output

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

  # echo `grep -o "<td>[0-9]\{4\}-[0-9]\{4\}</td>" $output`
  iidx_id=`grep -o "<td>[0-9]\{4\}-[0-9]\{4\}</td>" $output | sed -e 's|<[^>]*>||g' | tr -d '-'`

  #DJP(ALL), DJP(SP), DJP(DP), 段(SP), 段(DP)
  points=`nkf -w $output | grep -o "<td class=\"point\">[^<]*</td>" | sed -e 's/<[^>]*>//g' | sed -e 's/pt.$//' | tr '\n' ','`

  #情報を追記して出力
  echo $line$iidx_id","$points

  rm -f $output
done
