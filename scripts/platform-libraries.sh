#/bin/bash
cd /opt/pnda
wget https://github.com/pndaproject/platform-libraries/archive/develop.zip
unzip develop.zip
rm develop.zip
ln -s /opt/pnda/platform-libraries-develop /opt/pnda/platform-libraries
cd platform-libraries
sudo pip install -r requirements.txt
python setup.py bdist_egg
sudo easy_install dist/platformlibs-0.6.8-py2.7.egg