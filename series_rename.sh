#!/bin/bash
declare _RET=""
declare _USRI_S=""
declare _USRI_I=""
declare _USRI_IH=""

	#ignore case in regex
	shopt -s nocasematch

#######################
##
## has_string()
##
## determines if $2 is in $1
##
#######################
function has_string()
{
    length=`expr length "$1"`
    str=${1/"$2"*/}
    search=`expr length "$str"`

    if [ $search -eq $length ]
    then
	   return 1
    else
	   return 0
    fi
}

function escape()
{
	echo -n "$1" | sed 's/ /\\ /g'
}

function cut_leading_zero()
{
	input="$1"

	if ([ $input -lt "10" ] && [ ${#input} -gt 1 ])
	then
		echo -n ${input:1:1}
	else
		echo -n $1
	fi

}

function move_it()
{
	current_season=$1
	s=$(cut_leading_zero $2)
	e=$3
	prefix=$4

	# if [ "$s" != "$current_season" ]
	# then
	#	parent_dir=`dirname "$dir"`
	#	filename=`basename "$inventory"`			

	#	move_to_dir="$parent_dir/Staffel $s/"
		
		#mv "$inventory" "$move_to_dir"
	# fi

	echo -n -e "Rename \n\t'$(basename "$inventory")' into \
		\n\t'$prefix - Season $s - $e - '\n ? [Y|n|s for split|r repeat split]"
	read ANSWER

	case $ANSWER in
		r)
			repeat_splitting "$(basename "$inventory")"
			echo -n "Rename '$(basename "$inventory")'\n\tinto
				\n\t'$prefix - Season $s - $e - $_RET' ?
				\n[y|n|s for split]"
			read REPEAT_ANSWER

			if [ "$REPEAT_ANSWER" == "y" ]
			then
				echo "Moving \t '$(basename "$inventory")' into \n\t
					'$prefix - Season $s - $e - $_RET'"
				mv "$inventory" "$dir/$prefix - Season $s - $e - $_RET"
			else if [ "$REPEAT_ANSWER" == "s" ]
				then
					interacted_splitting "$(basename "$inventory")"
					echo "Moving \t'$(basename "$inventory")'
					 into\n\t '$prefix - Season $s - $e - $_RET'"
					mv "$inventory" "$dir/$prefix - Season $s - $e - $_RET"
				fi
			fi
		 ;;
		s)
			interacted_splitting "$(basename "$inventory")"
			echo "Moving \t'$(basename "$inventory")' into \n\t
				'$prefix - Season $s - $e - $_RET'"
			mv "$inventory" "$dir/$prefix - Season $s - $e - $_RET"
		 ;;
		*)
			mv "$inventory" "$dir/$prefix - Season $s - $e - "
		 ;;
	esac

	
}

function repeat_splitting()
{
	_RET=""

	if [ "$_USRI_S" == "3qoas8dy9uf0938j4afdsassdf0o8uy" ]
	then
		_USRI_S=" "
	fi

	if [ "$_USRI_S" == "" ]
	then
		echo "no user input done yet..."
		interacted_splitting "$1"
		return 0
	fi

	splittet=${1//"$_USRI_S"/ }

	i=1
	for us in ${splittet[@]}
	do
		#echo "$us $i $_USRI_I"
		if [ "$i" -ge "$_USRI_I" ]
		then	
			if [ "$_RET" == "" ]
			then
				_RET="$us"
			else
				_RET="${_RET} $us"
			fi
		fi

		(( i=$i+1 ))
	done
}

function interacted_splitting()
{
	_RET=""

	echo -n "split '$1' by? "
	read SPLIT

	if [ "$SPLIT" == "" ]
	then
		_USRI_S="3qoas8dy9uf0938j4afdsassdf0o8uy"
	else		
		_USRI_S="$SPLIT"
	fi

	splittet=${1//"$SPLIT"/ }
	i=1

	echo "Use which part(s) as name? [separate with space]" 
	for item in ${splittet[@]}
	do
		echo "$i) $item"
		splittetu[$i]="$item"
		(( i=$i+1 ))
	done

	read USE

	usea=${USE// / }
	_USRI_I=""

	for us in ${usea[@]}
	do
		if [ "$_USRI_I" == "" ]
		then
			_USRI_I=$us
		fi

		if [ "$_RET" == "" ]
		then
			_RET="${splittetu[$us]}"
		else
			_RET="${_RET} ${splittetu[$us]}"
		fi
	done

	_USRI_IH=$us

	#_RET=${splittetu[$USE]}
}

function get_current_season()
{
	echo "$1" | awk 'match($0,/Staffel [0-9]{1,2}/) { print substr($0,RSTART+8,RLENGTH-8)  }'
	#gawk '{ print gensub(/Staffel ([0-9])/, "\\1", "0" ) }'

	#awk 'match($0,/Staffel [0-9]/) { print substr($0,RSTART,RLENGTH)  }'
}


###############################################
function sezon_1_episod_01_get_s()
{
	echo "$1" | awk 'match($0,/[sS]ezon [0-9]+/) { print substr($0,RSTART+6,RLENGTH-6) }'
}

function sezon_1_episod_01_get_e()
{
	echo "$1" | awk 'match($0,/[eE]pisod [0-9]+/) { print substr($0,RSTART+7,RLENGTH-7) }'
}

###############################################
function season_01_episode_01_get_s()
{
	echo "$1" | awk 'match($0,/[sS]eason_[0-9]+/) { print substr($0,RSTART+7,RLENGTH-7) }'
}

function season_01_episode_01_get_e()
{
	echo "$1" | awk 'match($0,/[eE]pisode_[0-9]+/) { print substr($0,RSTART+8,RLENGTH-8) }'
}

###############################################
function s01e01_get_s()
{
	echo "$1" | awk 'match($0,/[sS][0-9]+/) { print substr($0,RSTART+1,RLENGTH-1) }'
}

function s01e01_get_e()
{
	echo "$1" | awk 'match($0,/[eE][0-9]+/) { print substr($0,RSTART+1,RLENGTH-1) }'
}

###############################################
function x101_get_s()
{
	echo "$1" | awk 'match($0,/[0-9][0-9][0-9]/) { print substr($0,RSTART,RLENGTH-2) }'
}

function x101_get_e()
{
	echo "$1" | awk 'match($0,/[0-9][0-9][0-9]/) { print substr($0,RSTART+1,RLENGTH-1) }'
}

###############################################
function x0101_get_s()
{
	echo "$1" | awk 'match($0,/[0-9][0-9][0-9][0-9]/) { print substr($0,RSTART,RLENGTH-2) }'
}

function x0101_get_e()
{
	echo "$1" | awk 'match($0,/[0-9][0-9][0-9][0-9]/) { print substr($0,RSTART+2,RLENGTH-2) }'
}


###############################################
function xbrackx01_get_s()
{
	echo "$1" | awk 'match($0,/\[[0-9]\([0-9]\)[xX][0-9]*\]/) { print substr($0,RSTART+1,RLENGTH-8) }'
}

function xbrackx01_get_e()
{
	echo "$1" | awk 'match($0,/\[[0-9]\([0-9]\)[xX][0-9]*\]/) { print substr($0,RSTART+6,RLENGTH-7) }'
}

###############################################
function x1__1_get_s()
{
	echo "$1" | awk 'match($0,/[0-9]-[0-9]/) { print substr($0,RSTART,RLENGTH-2) }'
}

function x1__1_get_e()
{
	echo "$1" | awk 'match($0,/[0-9]-[0-9]/) { print substr($0,RSTART+2,RLENGTH-2) }'
}

###############################################
function x01__01_get_s()
{
	echo "$1" | awk 'match($0,/[0-9][0-9] - [0-9][0-9]/) { print substr($0,RSTART,RLENGTH-5) }'
}

function x01__01_get_e()
{
	echo "$1" | awk 'match($0,/[0-9][0-9] - [0-9][0-9]/) { print substr($0,RSTART+5,RLENGTH-5) }'
}

###############################################
function s01e_01_get_e()
{
	echo "$1" | awk 'match($0,/[eE]_[0-9]+/) { print substr($0,RSTART+2,RLENGTH-2) }'
}



###############################################
function x1x01_get_s()
{
	echo "$1" | awk 'match($0,/[0-9]*x/) { print substr($0,RSTART,RLENGTH-1) }'
}

function x1x01_get_e()
{
	echo "$1" | awk 'match($0,/[0-9]*x[0-9]+/) { print substr($0,RSTART+2,RLENGTH-2) }'
}

###############################################
function staffel1e1_get_s()
{
	echo "$1" | awk 'match($0,/[sS]taffel [0-9]+/) { print substr($0,RSTART+8,RLENGTH-8) }'
}


# using s01e01_get_s()

function sttr_get_e()
{
	echo "$1" | awk 'match($0,/ep\._[0-9]+/) { print substr($0,RSTART+4,RLENGTH-4) }'
}


###############################################
function again_get_s()
{
	echo "$1" | awk 'match($0,/Staffel [0-9]/) { print substr($0,RSTART+8,RLENGTH-8) }'
}

function again_get_e()
{
	echo "$1" | awk 'match($0,/- [0-9]+ -/) { print substr($0,RSTART+2,RLENGTH-2) }'
}




#################################################################

input="$1"
current_season=$(get_current_season)
s=""
e=""


for inventory in "$input"*
do
	dir=$(dirname "$inventory")
	filename=$(basename "$inventory")
	realpath=$(realpath "$dir")
	path_series_name=$(realpath "$realpath/../")
	path_series_name=$(basename "$path_series_name")	

	# error??
	#has_string "$filename" "Staffel"
	#if [ $? -eq 1 ]
	#then
	#	s=$(again_get_s "$inventory")
	#	e=$(again_get_e "$inventory")
	#fi

	#ignore part files
	has_string "$filename" ".part"
	if [ $? -eq 0 ]
	then
		echo "ignoring part file: '$filename'"
		continue
	fi

	#matches also 720p etc.
	if [[ "$filename" =~ [0-9]{3} ]]
	then
		s=$(x101_get_s "$inventory")
		e=$(x101_get_e "$inventory")
	fi
	
	if [[ "$filename" =~ [0-9]{1,2}[[:space:]]-[[:space:]][0-9]{1,2} ]]
	then
		s=$(x01__01_get_s "$inventory")
		e=$(x01__01_get_e "$inventory")
	fi

	if [[ "$filename" =~ [0-9]{1,2}-[0-9]{1,2} ]]
	then
		s=$(x1__1_get_s "$inventory")
		e=$(x1__1_get_e "$inventory")
	fi

	if [[ "$filename" =~ [sS][0-9]{1,2}[eE][0-9]{1.2} ]]
	then
		s=$(s01e01_get_s "$inventory")
		e=$(s01e01_get_e "$inventory")
	fi

	if [[ "$filename" =~ [0-9]{4} ]]
	then
		s=$(x0101_get_s "$inventory")
		e=$(x0101_get_e "$inventory")
	fi

	if [[ "$filename" =~ \[[0-9]([0-9])[xX][0-9]*\] ]]
	then
		s=$(xbrackx01_get_s "$inventory")
		e=$(xbrackx01_get_e "$inventory")
	fi

	has_string "$filename" "Sezon"
	if [ $? -eq 0 ]
	then
		s=$(sezon_1_episod_01_get_s "$inventory")
		e=$(sezon_1_episod_01_get_e "$inventory")
	fi

	if [[ "$filename" =~ ^[0-9]*$ ]]
	then
		s=$current_season
		e=$filename
		echo $current_season
	fi

	if [[ "$filename" =~ ^[0-9]*[\.\-\_] ]]
	then
		s=$current_season
		e=${filename:0:2}
	fi

	if [[ "$filename" =~ ^[0-9]-[0-9][0-9] ]]
	then
		s=${filename:0:1}
		e=${filename:2:2}
	fi

	if [[ "$filename" =~ ^Staffel[[:space:]][0-9][[:space:]]-[[:space:]][0-9][0-9] ]]
	then
		s=${filename:8:1}
		e=${filename:12:2}
	fi

	if [[ "$filename" =~ ^Staffel[[:space:]][0-9][[:space:]]-[[:space:]][0-9][0-9] ]]
	then
		s=${filename:8:1}
		e=${filename:12:2}
	fi

	regex="^$2[_-][0-9]{1,2}[_-][0-9]{2}"
	if [[ "$filename" =~ $regex ]]
	then
		length=${#2}
		s=${filename:$length+1:2}

		if [[ "$filename" =~ [0-9]{2}[_-][0-9]{2} ]]
		then
			e=${filename:$length+4:2}
		else
			e=${filename:$length+3:2}		
		fi
	fi

	if [[ "$filename" =~ ^[0-9][0-9][[:space:]]-[[:space:]][0-9][0-9] ]]
	then
		s=${filename:0:2}
		e=${filename:5:2}
	fi

	#if [[ "$filename" =~ ^$2 - Staffel [0-9] - [0-9][0-9] - - ]]
	#then
	#	s=$current_season
	#	e=${filename:${#2}+15:2}
	#fi

	if [[ "$filename" =~ [sS]eason_[0-9]{1,2}_[eE]pisode_[0-9]{1,2} ]]
	then
		s=$(season_01_episode_01_get_s "$filename")
		e=$(season_01_episode_01_get_e "$filename")
	fi

	if [[ "$filename" =~ [sS][0-9]{1,2}[eE][0-9]{1,2} ]]
	then
		s=$(s01e01_get_s "$filename")
		e=$(s01e01_get_e "$filename")
	fi

	if [[ "$filename" =~ [sS][0-9]{1,2}\.[eE][0-9]{1,2} ]]
	then
		s=$(s01e01_get_s "$inventory")
		e=$(s01e01_get_e "$inventory")
	fi

	if [[ "$filename" =~ [sS][0-9]{1,2}.[eE]_[0-9]{1,2} ]]
	then
		s=$(s01e01_get_s "$inventory")
		e=$(s01e_01_get_e "$inventory")
	fi

	if [[ "$filename" =~ [sS]taffel[0-9]{1,2}-[eE][0-9]{1,2} ]]
	then
		s=$(staffel1e1_get_s "$inventory")
		e=$(s01e01_get_e "$inventory")
	fi

	if [[ "$filename" =~ [0-9]{1,2}x[0-9]{1,2} ]]
	then
		s=$(x1x01_get_s "$inventory")
		e=$(x1x01_get_e "$inventory")
	fi

	# this is an error correction...
	# if [[ "$filename" =~ ^[[:space:]]-[[:space:]]Staffel[[:space:]][0-9][[:space:]]-[[:space:]][0-9][0-9] ]]
	#then
	#	s=${filename:1:1}
	#	e=${filename:15:2}

	#	echo "$s $e"
	#fi

	#if [[ "$filename" =~ ^[0-9] ]]
	#then
	#	s=$current_season
	#	e=$filename
	#fi

	if [ -n "$2" ]
	then
		series_name=$2
	else
		series_name=$path_series_name
	fi

	if [ "$s" != "" ]
	then
		move_it "$current_season" "$s" "$e" "$series_name"
	else
		echo "No match for '$filename'"
	fi

	s=""
	e=""
done	
