#! /bin/bash

ROOT_PATH=$(pwd)

function checkExecutable() {
    which $1 2>&1 > /dev/null
}

function printError() {
    echo "$(tput setaf 1)$1$(tput sgr0)"
}

function initBaseAppDirectiories() {
    echo "Creating base directories"
    # create app directory
    mkdir -p app app/{js,css,static} app/static/{images,fonts}
    touch app/js/main.js app/css/main.scss
}

function moveAllDependencies() {
    echo "Moving Dependencies"
    # move all dependencies to the path the user provided us with
    cp -rf $ROOT_PATH/config $ROOT_PATH/.editorconfig $ROOT_PATH/package.json.template $ROOT_PATH/config.xml.template $ROOT_PATH/index.html .
    # move the index file to app folder
    mv index.html app
}

function formatTemplate() {
    echo "Preparing package json"
    # replace constants with the variables user passed
    # using awk
    awkVariablesArray=(
        -v APP_NAME=''$APP_NAME''
        -v APP_DISPLAY_NAME=''$APP_DISPLAY_NAME''
        -v APP_DESCRIPTION=''$APP_DESCRIPTION''
        -v APP_AUTHOR=''$APP_AUTHOR''
        -v APP_URL=''$APP_URL''
    )

    # eval so we can pass the variables to awk
    # since if we escape quotes like \" it will print errors
    awk "${awkVariablesArray[@]}" -f $ROOT_PATH/replace-templates.awk package.json.template > package.json
    awk "${awkVariablesArray[@]}" -f $ROOT_PATH/replace-templates.awk config.xml.template > configs.xml

    # replace simple app name with sed
    sed -i -e s/%APP_NAME%/"$APP_NAME"/ app/index.html

    rm -rf package.json.template config.xml.template
}

function installDependencies() {
    echo "Installing dependencies"
    # use the package maanager to install dependencies from package.json
    $PACKAGE_MANAGER install
}

function initCordova() {
    echo "Initializing cordova"
    CORDOVA_EXEC="cordova"
    # check if cordova exists
    # install cordova in local app
    # and use the node modules bin version
    checkExecutable $CORDOVA_EXEC
    if [ $? -ne 0 ]; then
        #add latest cordova
        $PACKAGE_MANAGER add cordova
        CORDOVA_EXEC="./node_modules/.bin/cordova"
    fi

    # build the app so it is recognized as cordova
    $PACKAGE_MANAGER build

    # build cordova
    $CORDOVA_EXEC prepare

    # doing this step because sometimes cordova
    # remove packages from node modules
    echo "reinstalling packages"
    rm -rf node_modules
    $PACKAGE_MANAGER install
}

APP_NAME="com.example.app"
APP_DISPLAY_NAME="Cordova App"
APP_DESCRIPTION="Cordova App template"
APP_AUTHOR="someone"
APP_URL=""

# we do serilization
# so we can pass the data to sed to replace with
# because if we have unescaped slash it can break the sed program

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
        "-u"|"--url")
            APP_URL=$2
            # remove parameter from $*
            shift
        ;;
        "-h"|"--help")
            echo "You can use the script as follows ($0 -p|--path ... [-a|author ...] [-n|--name ...] [-dn|--display-name ...] [-d|--description ...] [-u|--url ...])"
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
checkExecutable $PACKAGE_MANAGER
if [ $? -ne 0 ]; then
    PACKAGE_MANAGER="npm"
fi

# check if npm exists
if [ $? -ne 0 ]; then
    printError "Please install npm so we can initialize the project"
    exit 1
fi

initBaseAppDirectiories
moveAllDependencies
formatTemplate
installDependencies
initCordova

echo "You are ready to start the project run (yarn dev) then open a new terminal and run (yarn start-server)"
