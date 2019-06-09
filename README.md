# cordova-app-initializer
Script and boierplates to initialize cordova application

### How to use
Clone this repository to a directory of your choice
After that change directory to the repository directory and run `./init.sh -p PUT_CORDOVA_PROJECT_PATH_HERE`.
And it will start copying and installing dependencies for you to start cordova

### Optionals 
You can pass additional paramaters alongside with the (-p = path) parameter (short-param-name|long-param name):
1) -a|--author AUTHOR_NAME_HERE
2) -n|--name PROJECT_NAME_HERE (something like com.example.app)
3) -dn|--display-name DISPLAY_NAME_HERE
4) -d|--description DESCRIPTION_HERE
5) -u|--url URL_HERE

### Examples
`./init.sh -p PUT_CORDOVA_PROJECT_PATH_HERE`
`./init/sh -p PUT_CORDOVA_PROJECT_PATH_HERE -a kyosifov -n com.kyosifov -dn "Kaloyan App" -d "App example" -u "https://kyosifov.com"`
