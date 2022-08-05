#!/bin/bash

# Script to replace es-retrorama files
# from /etc/emulationstation/themes/retrorama/
# for the raspberry pi

# Variables
src=$(pwd)
dest=/etc/emulationstation/themes/retrorama/
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
    printf "      -T    Replace main theme.xml\n\n"
}

replace_files ()
{
    echo "Replacing $1 files now"
    echo "Deleting $1 files from $dest"
    echo "Copying from $src to $dest"

    while read line; do
	path=$(echo "$dest/$line")
	
	if [ -d $path ] && [ $line != "_art" ]; then
	    rm $dest/$line/$1
	    cp $src/$line/$1 $dest/$line/$1
	fi
    done < tmp_s.txt

    echo -e "Done\n"
}

replace_main () 
{
    echo "Deleted main theme.xml"
    echo "New theme.xml was applied"
    rm $dest/theme.xml
    cp $src/theme.xml $dest/
    echo "Done"
}

# Remove temporal systems file if exists
# and create new one
[[ -f tmp_s.txt ]] && rm tmp_s.txt
ls $src > tmp_s.txt

# Save options to an array
index=0

while getopts ':ghstT' flag; do
    flags[$index]=$flag
    index=$((index + 1))
done

# Look for repeated options, if true exit
n_times=0
options=$((${#flags[@]} + 1))

for i in ${flags[@]}; do
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








