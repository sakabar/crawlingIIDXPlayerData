#!/bin/zsh

play_style=$1
grade_id=$2
date_dir=`date "+%Y%m%d"`
dir=./data/$date_dir/$play_style/$grade_id

mkdir -p $dir

#TODO
#0時から7までは実行させない


#cookieの取得(手動)

#json => txt
ruby read_json.rb > cookies.txt

./getDaniHTML.sh $play_style $grade_id $dir

if test $? -eq 1; then
  echo "途中終了しました"
  exit
fi

./extractPlayerData.sh $play_style $grade_id $dir

#./getPlayerData.sh
