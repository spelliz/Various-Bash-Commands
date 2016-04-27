if [ -d ./LOGFILES ]; then 
        rm -r ./LOGFILES
        echo "Removed old version"
fi

mkdir ./LOGFILES
mkdir ./LOGFILES/STABLE
mkdir ./LOGFILES/FREQ
mkdir ./LOGFILES/INFO
mkdir ./LOGFILES/COM

arr1=( $(find . -type f -iname "*.log" -printf '%P\n' | grep -v -e "run*" -e "LOGFILES" -e "p1" -e "p2" -e "run" -e "NOT_NEEDED"))
arr2=( $(find . -type f -iname "*.log" -printf '%P\n' | grep -v -e "run*" -e "LOGFILES" -e "NOT_NEEDED" | grep "p1"))
arr3=( $(find . -type f -iname "*.log" -printf '%P\n' | grep -v -e "run*" -e "LOGFILES" -e "NOT_NEEDED" | grep "p2"))
arr4=( $(find . -type f -iname "*.info" -printf '%P\n' | grep -v -e "run*" -e "LOGFILES" -e "NOT_NEEDED"))
arr5=( $(find . -type f -iname "*.com" -printf '%P\n' | grep -v -e "run*" -e "LOGFILES" -e "NOT_NEEDED"))


for FILE1 in ${arr1[@]}; do
        cp $FILE1  ./LOGFILES
done

for FILE2 in ${arr2[@]}; do
        cp $FILE2  ./LOGFILES/STABLE
done

for FILE3 in ${arr3[@]}; do
        cp $FILE3  ./LOGFILES/FREQ
done

for FILE4 in ${arr4[@]}; do
        cp $FILE4  ./LOGFILES/INFO
done

for FILE5 in ${arr5[@]}; do
        cp $FILE5  ./LOGFILES/COM
done


