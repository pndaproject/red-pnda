#/bin/bash
cd /opt/pnda

rm -r platform-libraries-develop >/dev/null 2>&1
rm platform-libraries >/dev/null 2>&1

wget https://github.com/pndaproject/platform-libraries/archive/develop.zip
unzip develop.zip
rm develop.zip
ln -s /opt/pnda/platform-libraries-develop /opt/pnda/platform-libraries
cd platform-libraries
if [[ $1 -eq 1 ]]; then
	sudo pip --proxy ${http_proxy} install -r requirements.txt
else
	sudo pip install -r requirements.txt
fi
python setup.py bdist_egg
sudo easy_install dist/platformlibs-0.6.8-py2.7.egg