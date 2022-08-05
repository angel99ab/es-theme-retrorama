#!/bin/bash

# Script to replace es-retrorama files
# from /etc/emulationstation/themes/retrorama/
# for the raspberry pi

# Variables
src=$(pwd)
dest=/etc/emulationstation/themes/retrorama/
verbose=0
flags=()

# If no options used, don't do anything
if [ $# -eq 0 ]; then
    echo "Use '$0 -h' for detailed usage information."
    exit
fi

show_usage ()
{
    printf " Usage: ./replace.sh [options]\n\n"
    printf "    Options:\n\n"
    printf "      -g    Replace every GMBG image\n"
    printf "      -h    Show availabe options\n"
    printf "      -s    Replace every SLBG image\n"
    printf "      -t    Replace every theme.xml\n"
    printf "      -T    Replace main theme.xml\n"
    printf "      -v    Show detailed information\n\n"
}

replace_files ()
{
    while read line; do
	path=$(echo "$dest/$line")
	
	if [ -d $path ] && [ $line != "_art" ] && [ $verbose -eq 0 ]; then
	    rm $dest/$line/$1
	    cp $src/$line/$1 $dest/$line/$1
	elif [ -d $path ] && [ $line != "_art" ] && [ $verbose -eq 1 ]; then
	    echo "Deleted $dest/$line/$1"
	    echo "Copied from $src/$line/$1 to $dest/$line/$1"
	    rm $dest/$line/$1
	    cp $src/$line/$1 $dest/$line/$1
	fi
    done < tmp_s.txt
}

replace_main () 
{
    rm $dest/theme.xml
    cp $src/theme.xml $dest/
}

# Remove temporal systems file if exists
# and create new one
[[ -f tmp_s.txt ]] && rm tmp_s.txt
ls $src > tmp_s.txt

# Save options to an array
index=0

while getopts ':ghstTv' flag; do
    flags[$index]=$flag
    index=$((index + 1))
done

# Look for repeated options, if true exit
n_times=0
options=$((${#flags[@]} + 1))

for i in ${flags[@]}; do
    [[ $i == "v" ]] && verbose=1
    for j in ${flags[@]}; do
        if [ $i == $j ]; then
            n_times=$((n_times + 1))
        fi
        if [ $n_times -gt $options ]; then
            echo "Options repeated, use '$0 -h' to see options"
            exit
        fi
    done
done
  
# Use options invoked
for flag in ${flags[@]}; do
    case $flag in
        g) replace_files GMBG.jpg;;
        h) show_usage;;
        s) replace_files SLBG.jpg;;
        t) replace_files theme.xml;;
        T) replace_main;;
    esac
done

# Remove temporal systems file
rm tmp_s.txt








