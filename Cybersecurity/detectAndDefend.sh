#!/bin/bash

SYSNAME=`uname -n`

# sudo modprobe pcspkr

####################Builds an array of all users################################
# This logic is used below in the infinite loop in order to get the initial list
# of users used below to remove anyone not in this list's .bashrc and .bash_profile
let ORIG_COUNTER=0
HASH_ARR=()
DIR_ARR=()
#create array of all users
ARRAY=($(getent passwd | grep /bin/bash | awk -F: '{print $6}'))
for user in ${ARRAY[@]}
do
    if [ -f "$user/.profile" ]
    then
        HASH_ARR+=($(shasum $user/.profile  | awk '{print $1}' | grep '.*'))
        DIR_ARR+=("$user/.profile")
    fi

    if [ -f "$user/.bash_profile" ]
    then
        HASH_ARR+=($(shasum $user/.bash_profile  | awk '{print $1}' | grep '.*'))
        DIR_ARR+=("$user/.bash_profile")
    fi

    if [ -f "$user/.bashrc" ]
    then
        HASH_ARR+=($(shasum $user/.bashrc  | awk '{print $1}' | grep '.*'))
        DIR_ARR+=("$user/.bashrc")
    fi
done
################################################################################



#################################Infinite Loop##################################
while [[ true ]];
do
	#######################Find and kill all cron jobs##########################
	# loop through all users and delete any cron jobs you find
	for user in $(cut -f1 -d: /etc/passwd)
	do
		crontab -r
		# echo -e '\a'
	done
	############################################################################

	#######################Find and kill all at jobs############################
	if service --status-all | grep -Fq 'atd'
	then
		for i in $(atq | awk '{print $1}')
		do
			atrm $i
			# echo -e '\a'
		done
	fi
	############################################################################

	#######################Find and kill keyloggers#############################
	# use top to grab all processes matching the most known keyloggers in linux
	# [lkl, uberkey, THC-vlogger, PyKeylogger, logkeys] = most known keyloggers for linux systems
	PROCESS=$(top -b -n 1 | awk '{print $12}' | grep -wi 'lkl\|uberkey\|THC-vlogger\|PyKeylogger\|logkeys')
	echo $PROCESS
	# check if the length of $PROCESS is greater than 0
	if [[ -n $PROCESS ]]
	then
		killall -s 9 $PROCESS # kill the keylogger
		# echo -e '\a'
	fi

	#####################Repeatedly kill all !port 22###########################
	 PORTS=$(netstat -tulpn | awk 'FNR > 2 {print $4}' | sed 's/.*://')

	 for port in $PORTS
	 do
		 if [[ $port != 22 ]]
		 then
			 piTCP=$(lsof -i tcp:$port | awk 'NR!=1 {print $2}')
			 kill -15 -$pidTCP
			 pidUDP=$(lsof -i udp:$port | awk 'NR!=1 {print $2}')
			 kill -15 -$pidUDP
			 #lsof -i udp:$port | awk 'NR!=1 {print $2}' | xargs kill
		 fi
	 done
	############################################################################
	SSHD_CONFIG_HASH=$(shasum /etc/ssh/sshd_config)
    let ORIG_COUNTER=0
    HASH_ARR=()
    DIR_ARR=()
    #getent passwd|awk -F: '{print $1}'
    #find ~$user/.ssh -type f -exec shasum {} \;
    #create array of all users
    ARRAY=($(getent passwd|awk -F: '{print $6}'))
    for user in ${ARRAY[@]}
    do
        if [ -d $user/.ssh ]
        then
        	DIRS=($(find $user/.ssh -type f ))
        	for x in ${DIRS[@]}
        	do
                HASH_ARR+=($(shasum $x | awk '{print $1}' | grep '.*'))
                DIR_ARR+=("$x")
        	done
        	let ORIG_COUNTER=ORIG_COUNTER+1
        fi
    done

##########################Check SSH Keys########################################
    ARRAY=($(getent passwd | awk -F: '{print $6}'))
	let index=0
	for user in ${ARRAY[@]}
	do
        if [ -d $user/.ssh ]
        then
            DIRS=($(find $user/.ssh -type f ))
            for x in ${DIRS[@]}
            do
                if [ "$x" != "${DIR_ARR[$index]}" ]
                then
                    echo "FILE ${DIR_ARR[$index]} HAS BEEN EDITED (DELETED OR ADDED)"
                else
                    temp_HASH=$(shasum $x | awk '{print $1}' | grep '.*')
                    if [ $temp_HASH != ${HASH_ARR[$index]} ]
                    then
                        echo "HASH FOR FILE $x HAS BEEN EDITED"
                    fi
                    let index=index+1
                fi
            done
        fi
    done
	TEMP_CONFIG=$(shasum /etc/ssh/sshd_config)
	if [ “$TEMP_CONFIG” != “$SSHD_CONFIG_HASH” ]
	then
		echo “SSHD_CONFIG HAS BEEN MODIFIED”
    	echo “SSHD_CONFIG HAS BEEN MODIFIED”
    	echo “SSHD_CONFIG HAS BEEN MODIFIED”
    	echo “SSHD_CONFIG HAS BEEN MODIFIED”
	fi
	############################################################################

	#####################Create users from CSV##################################
	if [ -f $1 ]
	then
		while IFS=, read -r col1 col2
		do
			mkdir /home/$col1
			useradd -d "/home/$col1" $col1
			echo "$col1:$col2" | chpasswd
	   done < $1
	fi
	########################Bash Profile########################################

    let index=0
    for val in ${HASH_ARR[@]}
    do
        temp_HASH=$(shasum ${DIR_ARR[$index]} | awk '{print $1}' | grep '.*')
        if [ $temp_HASH != ${HASH_ARR[$index]} ]
        then
            echo "FILE ${DIR_ARR[$index]} HAS BEEN EDITED"
        fi
        let index=index+1
    done

	#########################passwd and shadow##################################
	let ORIG_COUNTER=0
	HASH_ARR=()
	DIR_ARR=()
	HASH_ARR+=($(shasum /etc/passwd | awk '{print $1}' | grep '.*'))
	HASH_ARR+=($(shasum /etc/shadow | awk '{print $1}' | grep '.*'))
	DIR_ARR+=("/etc/passwd")
	DIR_ARR+=("/etc/shadow")
	let index=0
	for val in ${HASH_ARR[@]}
	do
    	temp_HASH=$(shasum ${DIR_ARR[$index]} | awk '{print $1}' | grep '.*')
    	if [ $temp_HASH != ${HASH_ARR[$index]} ]
      	then
    		echo "FILE ${DIR_ARR[$index]} HAS BEEN EDITED"
    	fi
    	let index=index+1
    done
	############################################################################

	##########################Kick unauth users#################################
	badguy=$(who | grep -v ‘root’ | awk ‘{print $1}’)
	if [ “$badguy” != “” ]
    then
        skill -KILL -u $badguy >> .kill_history
		echo “*****WARNING*****”
		echo “Killed $badguy”
	fi
	############################################################################

done

	#################################Old code###################################

	# ps -aux | awk '{print $11}' | awk -F '^[\/|\[]*[a-z-A-Z-]*[\/|\]]*$' # old way
	# for process in $(top -b -n 1 | awk '{print $12}' | grep -wi 'lkl\|uberkey\|THC-vlogger\|PyKeylogger\|logkeys')
	# do
	# 	# [lkl, uberkey, THC-vlogger, PyKeylogger, logkeys] = most known keyloggers for linux systems
	# 	kill 9 $process
	# done



	# clear
	# echo ""
	# df -h / # report file system disk space usage in human-readable format (e.g., 1K, 234M, 2G)
	# echo ""
	# tail -5 /var/log/auth.log # print last 5 lines of auth.log to check for unauthorized breaches
	#  tail -5 /var/log/secure # same as above but for Redhat and CentOS based systems
	# grep CRON /var/log/syslog | awk '{print $5}' | awk -F '[^0-9]*' '$0=$2' # print the cron job id values for jobs currently running
	# echo ""
	# vmstat 1 5 # report virtual memory statistics
	# sleep 15 # sleep for 15 seconds
