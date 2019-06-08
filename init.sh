#! /bin/bash

function printError() {
    echo "$(tput setaf 1)$1$(tput sgr0)"
}


APP_NAME="app.cordova"
APP_DISPLAY_NAME="Cordova App"
APP_DESCRIPTION="Cordova App template"
APP_AUTHOR="someone"

while [ $# -ne 0 ]; do
    case $1 in
        "-p"|"--path")
            CORDOVA_PROJECT_PATH=$2
            shift
        ;;
        "-n"|"--name")
            APP_NAME=$2
            # remove parameter from $*
            shift
        ;;
        "-dn"|"--display-name")
            APP_DISPLAY_NAME=$2
            # remove parameter from $*
            shift
        ;;
        "-d"|"--description")
            APP_DESCRIPTION=$2
            # remove parameter from $*
            shift
        ;;
        "-a"|"--author")
            APP_AUTHOR=$2
            # remove parameter from $*
            shift
        ;;
        "-h"|"--help")
            echo "You can use the script as follows ($0 -p|--path ... [-a|author ...] [-n|--name ...] [-dn|--display-name ...] [-d|--descriptin])"
            exit 0
    esac

    # remove paramter from $*
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
