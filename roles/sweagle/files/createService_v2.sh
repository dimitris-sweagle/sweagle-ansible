#!/bin/bash

function startService() {
	serviceName=$1

	echo "Reload daemons"
	sudo systemctl daemon-reload

	sudo systemctl enable ${serviceName}.service

	echo "Start Service ${serviceName}"
	sudo service ${serviceName} restart

	sleep 0.5
	sudo service ${serviceName} status | grep -A 3 "Active:"

	echo "List of sweagle services"
	sleep 0.5
	sudo systemctl | grep -i sweagl
}

function writeServiceFile() {
	serviceName=$1
	pathToComponent=$2
	jarName=$3
	newrelic=$5
	componentConfFile=${pathToComponent}"/application.yml"

	javaHeap=""
	if [ ! -z "$5" ]; then
		javaHeap="-Xms${size} -Xmx${size}"
	fi

	if [ -f ${componentConfFile} ]; then
		locArg="-Dspring.config.location=${componentConfFile}"
	else
		locArg=""
	fi

	if [ "$newrelic" == "true" ] || [ "$newrelic" == "TRUE" ] || [ "$newrelic" == "True" ]; then
		# Retrieve sweagle installation folder from component path by removing last 2 directories
		pathToSweagle=$(echo $pathToComponent | rev | cut -d'/' -f3- | rev)
		if [ ! -f "$pathToSweagle/monitoring/newrelic/newrelic.jar" ]; then
			echo "Newrelic not found"
			exit 1
		else
			locArg="$locArg -javaagent:$pathToSweagle/monitoring/newrelic/newrelic.jar"
		fi
	fi

	if [ "$serviceName" == "sweagleCore" ]; then
			echo "Adding mysql-connector"
			echo
			if [ ! -f "$pathToComponent/libs/mysql-connector-java"* ]; then
					echo "Mysql connector not found"
			else
					echo "Mysql connector found. Continue..."
					lib=$(ls -t "$pathToComponent/libs/mysql"* | head -1)
					locArg="$locArg -Dloader.path=$lib"
					echo "New args: $locArg"
			fi
	fi


sudo cat > /etc/systemd/system/${serviceName}.service << EOL
[Unit]
Description=${serviceName} Service

[Service]
ExecStart=/usr/bin/java ${javaHeap} ${locArg} -jar ${pathToComponent}/${jarName}
SuccessExitStatus=143
TimeoutStopSec=10
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target

EOL

}


function validateInput() {
	serviceName=$1
	pathToComponent=$2
	jarName=$3
	newrelic=$5

	jarFile=${pathToComponent}/${jarName}

	errorOccurred="false"
	if echo $serviceName | grep -q '[^0-9A-Za-z]'; then
		echo "Invalid service name."
		errorOccurred="true"
	fi

	if [ ! -d "$pathToComponent" ]; then
		echo "Path to component not found"
		errorOccurred="true"
	fi

	if [ ! -f ${pathToComponent}/${jarName} ]; then
		echo "jar file not found"
		errorOccurred="true"
	fi

	if [ "$newrelic" == "true" ] || [ "$newrelic" == "TRUE" ] || [ "$newrelic" == "True" ]; then
		# Retrieve sweagle installation folder from component path by removing last 2 directories
		pathToSweagle=$(echo $pathToComponent | rev | cut -d'/' -f3- | rev)
		if [ ! -f "$pathToSweagle/monitoring/newrelic/newrelic.jar" ]; then
			echo "Newrelic not found"
			errorOccurred="true"
		fi
	fi

	if [ "$#" -ge 4 ] || [ "$#" -le 5 ]; then
		size=$4
		if [[ "$size" != *k ]] && [[ "$size" != *m ]] && [[ "$size" != *g ]]; then
			echo "Size of heap is missing of Measurement unit"
			errorOccurred="true"
		fi
	fi

	if [ "$errorOccurred" == "true" ]; then
		printMenu
		exit
	fi

}

function printMenu() {
	echo "Wrong number of arguments"
	echo "argument 1 required: SERVICE_NAME"
	echo "argument 2 required: PATH_TO_COMPONENT"
	echo "argument 3 required: JAR_FILE"
	echo "argument 4 required: SIZE_OF_HEAP eg. 1000k, 1000m, 1g"
	echo "argument 5 optional: newrelic support: true/false (default false)"
}

function main() {
	if [ "$#" -ge 5 ] || [ "$#" -le 6 ]; then
		serviceName=$1
		pathToComponent=$2
		jarName=$3
		heapSize=$4
		newrelic=$5

		validateInput $serviceName $pathToComponent $jarName $heapSize $newrelic

		writeServiceFile $serviceName $pathToComponent $jarName $heapSize $newrelic

		startService $serviceName
	else
		printMenu
	fi
}

main $1 $2 $3 $4 $5
