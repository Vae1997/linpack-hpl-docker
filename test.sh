#!/bin/sh
# run test
# /root/openmpi/build/bin/mpirun -n 4 --allow-run-as-root ./xhpl > result.txt
# mpirun -n 4 --allow-run-as-root ./xhpl > result.txt
# 理论CPU浮点运算峰值：1.2GHz*1*4核=4.8Gflops/s
#（注意：此处假设CPU每个时钟周期的浮点运算次数为1）
THEORY_GFLOPS=4.8
echo " "
echo "理论浮点计算峰值:4.8Gflops"
# start print from 47 line, step is 10 line.
sed -n '47~10p' result.txt >> a.txt
# delete the last line of file
sed -i '$d' a.txt
# delete the first col of file
awk '{$1="";print $0}' a.txt >> b.txt
rm a.txt
# get first test data
N=$(cat b.txt | awk '{print $1}' | sed -n '1p')
NB=$(cat b.txt | awk '{print $2}' | sed -n '1p')
P=$(cat b.txt | awk '{print $3}' | sed -n '1p')
Q=$(cat b.txt | awk '{print $4}' | sed -n '1p')
echo " "
echo "				   N:$N NB:$NB P:$P Q:$Q"

# init per test time and gflops
Time=0
Gflops=0
# init per test count
count=0
# init per test MAX & MIN & AVR time and gflops
# note: MAX_TIME <=> MIN_GFLOPS
#       MIN_TIME <=> MAX_GFLOPS
MAX_TIME=0
MAX_GFLOPS=0
MIN_TIME=10		# min time ensure can be set
MIN_GFLOPS=0
#AVR_TIME=0
#AVR_GFLOPS=0
#init total test count
COUNT=1
# init total test MAX & MIN & AVR time and gflops
MAXTIME=0
MAXGFLOPS=0
MINTIME=10
MINGFLOPS=0
AVRTIME=0
AVRGFLOPS=0
# Total time and gflops
TIME=0
GFLOPS=0
# test group count
Gcount=1
# init MAX effect var
Mn=$N
Mnb=$NB
Mp=$P
Mq=$Q
Maxeffect=0
# read every line data
cat b.txt | while read n nb p q time gflops
do
	# change gflops to float
	gflops=$(printf "%f" $gflops)	
	# current not a same test
	if [[ $N != $n || $NB != $nb || $P != $p || $Q != $q ]]; then
		# print before test result
		echo "TestCount:$count,TotalTime:$Time."
		echo "MAXTime:$MAX_TIME,MINGflops:$MIN_GFLOPS."
		echo "MINTime:$MIN_TIME,MAXGflops:$MAX_GFLOPS."
		echo "AVRTime:$(awk 'BEGIN{printf "%.2f\n",'$Time'/'$count'}')s." 
		echo "AVRGflops:$(awk 'BEGIN{printf "%.6f\n",'$Gflops'/'$count'}')."
		echo "===================================效率范围:$(awk 'BEGIN{printf "%.2f\n",('$MIN_GFLOPS'/'$THEORY_GFLOPS')*100}')%~$(awk 'BEGIN{printf "%.2f\n",('$MAX_GFLOPS'/'$THEORY_GFLOPS')*100}')%"
		# init result before next test
		count=0
		Time=0
		Gflops=0
		MAX_TIME=0
		MAX_GFLOPS=0
		MIN_TIME=10
		MIN_GFLOPS=0
		# next test
		Gcount=$(($Gcount + 1))
		echo " "
		echo "				   N:$n NB:$nb P:$p Q:$q"
		N=$n
		NB=$nb
		P=$p
		Q=$q
	fi
	# echo "Time:$time Gflops:$gflops"
	# set MAX & MIN data
	if [[ `echo "$time > $MAX_TIME "|bc` -eq 1 ]]; then
		MAX_TIME=$time
		MIN_GFLOPS=$gflops
	fi
	if [[ `echo "$time < $MIN_TIME "|bc` -eq 1 ]]; then
		MIN_TIME=$time
		MAX_GFLOPS=$gflops
	fi
	if [[ `echo "$time > $MAXTIME "|bc` -eq 1 ]]; then
		MAXTIME=$time
		MINGFLOPS=$gflops
	fi
	if [[ `echo "$time < $MINTIME "|bc` -eq 1 ]]; then
		MINTIME=$time
		MAXGFLOPS=$gflops
	fi
	# store effect data
	var=$(awk 'BEGIN{printf "%.2f\n",('$MAXGFLOPS'/'$THEORY_GFLOPS')*100}')
	if [[ `echo "$var > $Maxeffect "|bc` -eq 1 ]];then
		Maxeffect=$var
		Mn=$N
		Mnb=$NB
		Mp=$P
		Mq=$Q
	fi
	# add time and gflops
	Time=$(echo "$Time + $time"|bc)
	TIME=$(echo "$TIME + $time"|bc)
	Gflops=$(echo "$Gflops + $gflops"|bc)
	GFLOPS=$(echo "$GFLOPS + $gflops"|bc)
	# add per test count		
	count=$(($count + 1))
	# not last test
	if [[ $COUNT != $(awk 'END{print NR}' b.txt) ]]; then
		COUNT=$(($COUNT + 1))
	else
		# print last test result
		echo "TestCount:$count,TotalTime:$Time."
		echo "MAXTime:$MAX_TIME,MINGflops:$MIN_GFLOPS."
		echo "MINTime:$MIN_TIME,MAXGflops:$MAX_GFLOPS."
		echo "AVRTime:$(awk 'BEGIN{printf "%.2f\n",'$Time'/'$count'}')s." 
		echo "AVRGflops:$(awk 'BEGIN{printf "%.6f\n",'$Gflops'/'$count'}')."
		echo "===================================效率范围:$(awk 'BEGIN{printf "%.2f\n",('$MIN_GFLOPS'/'$THEORY_GFLOPS')*100}')%~$(awk 'BEGIN{printf "%.2f\n",('$MAX_GFLOPS'/'$THEORY_GFLOPS')*100}')%"
		# print total test result
		echo ""
		echo "总体测试结果"
		echo ""
		echo "测试总数:$COUNT,总时间:$TIME秒."
		echo ""
		echo "最大时间:$MAXTIME秒,最小Gflops:$MINGFLOPS"
		echo ""
		echo "最小时间:$MINTIME秒,最大Gflops:$MAXGFLOPS"
		echo ""
		echo "平均时间:$(awk 'BEGIN{printf "%.2f\n",'$TIME'/'$COUNT'}')秒." 
		echo ""
		echo "平均Gflops:$(awk 'BEGIN{printf "%.6f\n",'$GFLOPS'/'$COUNT'}')"
		echo ""
		echo "测试参数一共$Gcount组"
		echo ""
		echo "效率最大的测试参数:N:$Mn NB:$Mnb P:$Mp Q:$Mq"
		echo ""
		echo "效率最大:$Maxeffect%"
		echo ""
		echo "总体效率范围:$(awk 'BEGIN{printf "%.2f\n",('$MINGFLOPS'/'$THEORY_GFLOPS')*100}')%~$(awk 'BEGIN{printf "%.2f\n",('$MAXGFLOPS'/'$THEORY_GFLOPS')*100}')%"
	fi
done
	
rm b.txt
