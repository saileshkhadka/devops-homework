#!/bin/bash

#Starting in the /opt directory, locate all directories which contain a file called .prune-enable. 
#In those directories, delete any files named crash.dump.
#In those directories, for any file having the suffix ".log", if the file is larger than one megabyte, 
#replace the file with a file containing only the last 20,000 lines.

#To check if the file in /opt or not
if [ $PWD != "/opt" ]; then
        echo "I am going to /opt"
        cd /opt
        printf "I am in $PWD\n"
fi

#To find and replace *.log files
replacelogfile(){
        logfiles=$(find . -type f -name "*.log" -size +1M)
        for logfile in $logfiles; do
                echo $logfile
                printf "This log file $logfile has size exceeded 1M, so I do replacement\n"
                tail -n 20000 $logfile > tmplog.tmp
                mv tmplog.tmp $logfile
                wc -l $logfile
        done
}

#To find all directories with .prune-enable

opt_dir=$(find . -name ".prune-enable" -exec dirname {} \;)
printf "Directories where .prune-enable is found:\n$opt_dir\n"

# loop over directories
for item in $opt_dir;
        do
                cd $item
                printf "\nWork available: $PWD\n"
                if [[ $(find . -name ".prune-enable") ]]; then
                        find . -type f -name "crash.dump" -exec rm '{}' \;
                        replacelogfile $item
                fi
                cd /opt

done
