#!/bin/zsh

#USAGE
#./solve_standard_score ./RESULT_FILE_DIR/result.txt MY_SCORE

result_file=$1
my_score=$2

dir=`dirname $result_file`

awk -F, '{print $4}' $result_file | grep "[0-9]*" | sort -nr > $dir/sample.txt
mean=`awk 'BEGIN{sum = 0}; { sum = sum + $0}; END{print (sum / FNR)}' $dir/sample.txt`
sd=`awk -v mean="${mean}" 'BEGIN{sum = 0}; { sum = sum + ( $0 - mean )**2 }; END{print sqrt(sum / FNR)}' $dir/sample.txt`
standard_score=$[10 * ($my_score - $mean) / $sd + 50]


echo "平均: "$mean
echo "標準偏差: "$sd
echo "偏差値: "$standard_score

