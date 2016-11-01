#!/usr/bin/env bash
# clone 
# activate
# install

if [ -z "$GIT_URL" ]
then    
    echo "You need to run the builder with -e GIT_URL=your_git_url"
    exit 1
fi

if [ -z "$1" ]
then    
    echo "You need give a path as first argument to this script"
    exit 1
fi

DATE=`date -Iseconds |sed -r 's/[^a-zA-Z0-9]//g; s/0000/0/g'`
PROJECT_NAME=`echo $GIT_URL           \
              | sed -e 's/\/$//'      \
              | awk -F/ '{print $NF}' \
              | sed -e 's/.git$//'    \
             `
GIT_DIR=$1/$PROJECT_NAME-$DATE

git clone $GIT_URL $GIT_DIR
cd $GIT_DIR
if [ ! -d "venv" ]; then virtualenv2 .; fi
. bin/activate
pip install .
virtualenv2 --relocatable .

IS_GENCONFIG=`grep -r genconfig tox.ini`
case "$IS_GENCONFIG" in
    *testenv*) pip install tox && tox -egenconfig -r ;;
    *)echo "No config to generate";;
esac
