#!/usr/bin/env bash

if [ -z "$GIT_URL" ]
then    
    echo "You need to specify a GIT_URL"
    exit 1
fi
if [ -z "$GIT_BRANCH" ]
then    
    echo "You need to specify a GIT_BRANCH"
    exit 1
fi
if [ -z "$PROJECT_NAME" ]
then    
    echo "You need to specify a PROJECT_NAME"
    exit 1
fi
if [ -z "$BUILD_PATH" ]
then    
    echo "You need set the BUILD_PATH env variable."
    echo 'A venv will be created in $BUILD_PATH/name-DATE/'
    exit 1
fi
if [ -z "$VENV_PATH" ]
then    
    echo "You need set the VENV_PATH env variable."
    echo "This is the exec PATH of your current build"
    echo 'The symlink-creator will symlink a build into $VENV_PATH/name/'
    exit 1
fi

DATE=`date -Iseconds |sed -r 's/[^a-zA-Z0-9]//g; s/0000/0/g'`
echo TimeStamp is: $DATE

echo Project Name is: $PROJECT_NAME
EXEC_PATH=$VENV_PATH/$PROJECT_NAME
BUILD_DIR=$BUILD_PATH/$PROJECT_NAME-$DATE

mkdir -p $VENV_PATH
mkdir -p $BUILD_DIR
echo Build directory is: $BUILD_DIR
echo Venv symlink is: $EXEC_PATH

git clone -b $GIT_BRANCH $GIT_URL $BUILD_DIR --depth 1 --single-branch

rm $EXEC_PATH; ln -s $BUILD_DIR $EXEC_PATH; cd $EXEC_PATH

if [ ! -d "venv" ]; then virtualenv2 .; fi
curl \
  https://raw.githubusercontent.com/openstack/requirements/$GIT_BRANCH/upper-constraints.txt \
  > upper-constraints.txt

. bin/activate

if pip install -c upper-constraints.txt . --upgrade ; then
  echo "Installed respecting Upper Constraints"
else
  echo "Installation failed, trying without constraints"
  pip install .
fi


virtualenv2 --relocatable .

IS_GENCONFIG=`grep -r genconfig tox.ini`
case "$IS_GENCONFIG" in
    *testenv*) pip install tox && tox -egenconfig -r ;;
    *)echo "No config to generate";;
esac
