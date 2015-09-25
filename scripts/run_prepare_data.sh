#!/bin/bash
# Author: Minh-Thang Luong <luong.m.thang@gmail.com>, created on Fri Nov 14 13:32:54 PST 2014

if [[ ! $# -eq 6 && ! $# -eq 5 ]];
then
  echo "`basename $0` trainFile validFile testFile vocabSize outDir [vocabFile]" 
  exit
fi

trainFile=$1
validFile=$2
testFile=$3
vocabSize=$4
outDir=$5
vocabFile=$6
SCRIPT_DIR=$(dirname $0)

function execute_check {
  file=$1 
  cmd=$2
  
  if [[ -f $file || -d $file ]];
  then
    echo ""
    echo "! File/directory $file exists. Skip."
  else
    echo ""
    echo "# Executing: $cmd"
    eval $cmd
  fi
}

# check outDir exists
echo "# outDir $outDir"
execute_check $outDir "mkdir -p $outDir"

# vocab
if [ "$vocabFile" = "" ]; then
  basePrefix=`basename $trainFile`
  vocabFile="$outDir/$basePrefix.vocab.$vocabSize"
fi

# train
trainName=`basename $trainFile`
outFile="$outDir/$trainName"
execute_check "$outFile" "$SCRIPT_DIR/prepare_data.py --vocab_file $vocabFile --size $vocabSize $trainFile $outFile"
execute_check "$outFile.reversed" "$SCRIPT_DIR/reverse.py $outFile $outFile.reversed"

# valid
validName=`basename $validFile`
outFile="$outDir/$validName"
execute_check "$outFile" "$SCRIPT_DIR/prepare_data.py --vocab_file $vocabFile --size $vocabSize $validFile $outFile"
execute_check "$outFile.reversed" "$SCRIPT_DIR/reverse.py $outFile $outFile.reversed"

# test
testName=`basename $testFile`
outFile="$outDir/$testName"
execute_check "$outFile" "$SCRIPT_DIR/prepare_data.py --vocab_file $vocabFile --size $vocabSize $testFile $outFile"
execute_check "$outFile.reversed" "$SCRIPT_DIR/reverse.py $outFile $outFile.reversed"

