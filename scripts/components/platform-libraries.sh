#!/bin/bash
set -e
set -x
source ../utils.sh
cd $MAIN_DIR

rm -r platform-libraries-develop >/dev/null 2>&1 || true
rm platform-libraries >/dev/null 2>&1 || true

wget https://github.com/pndaproject/platform-libraries/archive/release/$PNDA_RELEASE.zip
unzip $PNDA_RELEASE.zip
rm $PNDA_RELEASE.zip
ln -s $MAIN_DIR/platform-libraries-release-$PNDA_RELEASE $MAIN_DIR/platform-libraries
cd platform-libraries
sudo pip install -r requirements.txt
python setup.py bdist_egg
sudo easy_install dist/platformlibs-0.6.8-py2.7.egg
