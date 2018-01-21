#!/bin/bash
#
# CheckTheAns.sh
#
#	usage: 	chans <myanswer_file> <Ans_file>
#		echo "right Answers" | chans <myanswer_file>


aimedFile=$1 	# the file to check
resultFile=$aimedFile.result 	# the file result will be written in
correctCount=0	# contains how many questions I aswered correctly
myAns=( cat $aimedFile ) 	# my answers (array)
questionNumb=expr `head -n 1 $aimedFile | sed -e 's/ //g' | wc -m` - 1 # how many questions are there
shift

# Right Answers
if [ -p /dev/stdin ]
then
	correctAns=(cat - )
	echo $correctAns
else if [ $# -eq 0 ]
	echo "please pass correct answers using pipe or args"
	return 1
else
	correctAns=($*)
fi

# make result file
cat <<-EOF > $resultFile
	Correct Ans : ${correctAns[@]}
	Your Ans    : ${myAns[@]}
EOF
echo -n "o / x       :" >> $resultFile # no other way not to insert \n at the end of this line

# Let's check how much was correct ;)
for num in `seq 1 $questionNumb`
do
	if [ ${myAns[$num]} = ${correctAns[$num]} ]
	then
		echo " o" >> $resultFile
		correctCount= correctCount + 1
	else
		echo " x" >> $resultFile
	fi
done


# write results summary
cat <<-EOF >> $resultFile

	------
	corrects count : ${correctCount}
	miss count     : `expr $questionNumb - $correctCount`

	Correct rate : `expr $(expr $correctCount \* 100) / $questionNumb` %
EOF


return 0
