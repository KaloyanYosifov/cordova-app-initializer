#! /bin/bash

function printError() {
    echo "$(tput setaf 1)$1$(tput sgr0)"
}

while [ $# -ne 0 ]; do
    case $1 in
        "-p"|"--path")
            CORDOVA_PROJECT_PATH=$2
            shift
        ;;
        "-h"|"--help")
            echo "You can use the script as follows ($0 -p|--path ...)"
            exit 0
    esac
    
    shift
done

if [ -z $CORDOVA_PROJECT_PATH ]; then
    printError "Please add a (--path|-p) to init cordova project"
    exit 1
fi

if ! [ -d $CORDOVA_PROJECT_PATH ]; then
    echo "Creating directory!"
    mkdir $CORDOVA_PROJECT_PATH
fi

# change directory to the cordova project
cd $CORDOVA_PROJECT_PATH

# check if we have yarn command
PACKAGE_MANAGER="yarn"

# check if yarn package manager exists
# if not use npm
which $PACKAGE_MANAGER
if [ $? -ne 0 ]; then
    PACKAGE_MANAGER="npm"
fi

# check if npm exists
if [ $? -ne 0 ]; then
    printError "Please install npm so we can initialize the project"
    exit 1
fi