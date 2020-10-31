#!/usr/bin/env bash
#Author: Matthew Riedle
#Version: 1.3

## CHANGE NOTES

# 1.3
# Added an array of UserAgents to pull from so the script would be changed with each query in an effort to prevent getting IP banned

# 1.2
# Adjusted the sleep timer to allow for a longer pause in between the queries

# 1.1
# Added a simple counter to keep track of what number the script is currently querying

## END CHANGE NOTES


# The script needs to be executed as ./HIBPLookup.sh user.txt
# user.txt needs to contain a list of emails or usernames separated on new lines
user=$1

# Loading the list of emails / usernames into a list
IFS=$'\n' read -d '' -r -a list < $user

# Defining some variables
url="https://haveibeenpwned.com/api/v3/breachedaccount/"
parameterTruncate="?truncateResponse=true"
parameterUnverified="?includeUnverified=true"
count=1
incrementer=1

# Create an array with various UserAgents
UAarray=('User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13E238 Safari/601.1' 'User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36' 'User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36' 'User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko' 'User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 9_2_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13D15 Safari/601.1')

# Create random generator
Random=$$$(date +%s)

echo "Lookup is starting."
echo "Number of emails / usernames loaded for lookup: " ${#list[@]}
#echo ${list[@]}

# This will check if the results file already exists. If not, it will create one with the proper headings
file=./HIBPResults.txt
if [ -e "$file" ]; then
    echo ""
else 
    touch $file
fi

# For every URL listed in the URLS.txt, each of the attacks below will be executed
for line in ${list[@]}; do

# Set the current UserAgent
UserAgent=${UAarray[$Random % ${Random[*]}]}

#echo $UserAgent

# Add spacers to the beginning of the results
	echo "==========" >> $file

# Add the email / username being queried
	echo $line >> $file
	echo "" >> $file
	
# Reset the timestamp to the current time and use PST
	timestamp=$(TZ=":America/Los_Angeles" date)
	
# Load the current time into the file to record what time the HIBP Lookup was performed
	echo -e "$timestamp" >> $file

# Echo the current line number
    echo "Entry #"$count

	curl -s -i $url$line$parameterUnverified -H "$UserAgent" >> $file
	
	
# Add spacers to the end of the results
	echo "" >> $file
	echo "==========" >> $file
	echo "" >> $file
	echo "" >> $file

# Increment the line counter and add line spacing
	(( count++ ))
	echo ""
	echo ""

# Add rate-limiting delay for next request
	sleep 2s

done


echo ""
echo "Lookup is completed."
