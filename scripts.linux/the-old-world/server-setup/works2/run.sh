#!/bin/bash
#
# usage:
#
#	./run.sh -p1 -p2
#	./run.sh -p1 -p2 2>&1 | tee /usr/local/log/run.out
#	bash -x ./run.sh -p1 -p2 2>&1 | tee /usr/local/log/run.out
#

###
### variables
###

CURRENT_DIR=`pwd`
WORKING_DIR=/usr/local
PHASE1=
PHASE2=

###
### process arguments
###

while [ "$1" != "" ]; do
	case $1 in
		-p1|--phase1)	PHASE1="Y"
						;;
		-p2|--phase2)	PHASE2="Y"
						;;
	esac
	shift
done

###
### functions
###

# parameters: str_to_remove file_name
function remove_from_file {

	TMP_FILE=/tmp/remove_from_file.$$
	TMP_STR='1h;1!H;${;g;s/'
	sed -n "$TMP_STR$1//g;p;}" $2 > $TMP_FILE && mv $TMP_FILE $2
}

# parameters: str_to_replace new_str file_name
function replace_in_file {

	TMP_FILE=/tmp/replace_in_file.$$
	sed "s/$1/$2/g" $3 > $TMP_FILE && mv $TMP_FILE $3
}

###
### script
###

echo "Script $(readlink -f $0) started on $(date)"

cd $WORKING_DIR

# create log directory
[ ! -d $WORKING_DIR/log ] && mkdir -p $WORKING_DIR/log

# start phase 1
if [ "$PHASE1" = "Y" ]; then

	# replace kernel
	$WORKING_DIR/replace-kernel.sh 2>&1 | tee --append $WORKING_DIR/log/replace-kernel.out

	if [ "$PHASE2" = "Y" ]; then
		# schedule phase 2 on startup
		remove_from_file "\n# BEGIN: startup.*END: startup" /etc/rc.local
		remove_from_file "\nexit 0" /etc/rc.local
		(	echo -e "# BEGIN: startup" && \
			echo -e "sleep 30" && \
			echo -e "$(readlink -f $0) --phase2 2>&1 | tee --append /usr/local/log/run.out" && \
			echo -e "# END: startup" && \
			echo -e "exit 0" \
		) >> /etc/rc.local
		chmod u+x /etc/rc.local
	fi

	read -p "Press any key to reboot..."
	reboot

fi

# start phase 2
if [ ! "$PHASE1" = "Y" ] && [ "$PHASE2" = "Y" ]; then

	# clean up
	remove_from_file "\n# BEGIN: startup.*END: startup" /etc/rc.local
	chmod u-x /etc/rc.local

	# config interfaces
	$WORKING_DIR/config-interfaces.sh 2>&1 | tee --append $WORKING_DIR/log/config-interfaces.out

	# install lxc
	$WORKING_DIR/install-lxc.sh 2>&1 | tee --append $WORKING_DIR/log/install-lxc.out

fi

cd $CURRENT_DIR

echo "Script $(readlink -f $0) ended on $(date)"
