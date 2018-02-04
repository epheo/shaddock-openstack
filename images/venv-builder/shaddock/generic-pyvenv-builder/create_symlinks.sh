#!/bin/bash

if [ -z "$BUILD_PATH" ]
then    
    echo "You need set the BUILD_PATH env variable."
    echo "A venv will be created in $BUILD_PATH/name-DATE/"
    exit 1
fi

if [ -z "$VENV_PATH" ]
then    
    echo "You need set the VENV_PATH env variable."
    echo "This is the exec PATH of your current build"
    echo "The symlink-creator will symlink a build into $VENV_PATH/name/"
    exit 1
fi

if [ ! -d "$VENV_PATH" ]; then
  mkdir -p $VENV_PATH
fi
cd $VENV_PATH
srv_list=`ls $BUILD_PATH \
           |rev \
           |cut -d '-' -f 2- \
           |rev \
           |uniq`

for srv in $srv_list
do
  venv_dir=`ls $BUILD_PATH \
             |grep $srv'-' \
             |sort -r \
             |head -n1`
  
  if [ -d "$srv" ]; then
    rm $srv
  fi
  ln -sf $BUILD_PATH/$venv_dir $srv
done
