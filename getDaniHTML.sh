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


tmp_file=`mktemp`
change_proxy
wget "http://p.eagate.573.jp/game/2dx/22/p/ranking/dani.html?play_style="$play_style"&grade_id="$grade_id"&display=1" --load-cookie=cookies.txt -O $tmp_file

if test `grep "/game/2dx/22/p/djdata/data_another" $tmp_file | wc -l` -eq 0; then
  echo "クッキーを更新してください"
  cat /dev/null > cookies.json
  rm -f cookies.txt
  exit 1
fi

page_max=`sed -e 's|>|>\n|g' $tmp_file | grep -o "/game/2dx/22/p/ranking/dani.html?page=.*&play_style=.*&grade_id=.*&display=1" | sort | uniq | wc -l`

for page in {0..$page_max}; do
  dani_url="http://p.eagate.573.jp/game/2dx/22/p/ranking/dani.html?page="$page"&play_style="$play_style"&grade_id="$grade_id"&display=1"
  output=$dir/dani$page"_orig.html"

  #既にファイルが存在していたらスキップ
  if test -e $output; then
    continue
  fi

  my_wget $dani_url $output

  #wgetが失敗したら、proxyを切り換えて再試行
  # $? は直前のコマンドの終了ステータス(0が正常)
  if test $? -ne 0; then
    bad_proxy=`echo $http_proxy | sed -e 's|^http://||' -e 's|/$||'`
    tmp_file=`mktemp`
    grep -v $bad_proxy proxy_list.txt > $tmp_file
    echo "#"$bad_proxy >> $tmp_file
    mv $tmp_file proxy_list.txt

    my_wget $dani_url $output
  fi
done
