#!/bin/bash

sudo apt-get -y install ipython ipython-notebook
sudo -H pip install --upgrade pip
sudo -H pip install jupyter

# to run pyspark on jupyter notebook, enter
echo "PYSPARK_DRIVER_PYTHON=jupyter" >> /etc/environment
echo "PYSPARK_DRIVER_PYTHON_OPTS='notebook --ip=0.0.0.0 --port=9000'" >> /etc/environment
source /etc/environment

# to run pyspark on jupyter, simply run
# pyspark
mkdir /root/jupyter-notebooks
# to run jupyter
jupyter notebook --allow-root --generate-config
echo "c.NotebookApp.ip = '0.0.0.0'" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.port = 9000" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.open_browser = False" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.password = u'sha1:33532cda8624:0f16e1af56365d9e6c65ccfbcae9c12daccb6cd9'" >> ~/.jupyter/jupyter_notebook_config.py
echo "c.NotebookApp.notebook_dir = u'/root/jupyter-notebooks'" >> ~/.jupyter/jupyter_notebook_config.py

# jupyter init script
cp $1/components/files/jupyter.conf /etc/init

# create pyspark kernel
mkdir -p /usr/local/share/jupyter/kernels/pyspark

cp $1/components/files/pyspark-kernel.json /usr/local/share/jupyter/kernels/pyspark/kernel.json

cp $1/components/files/PNDA+minimal+notebook.ipynb /root/jupyter-notebooks

mkdir -p /data/year=2017/month=7/day=4/hour=14
cp $1/components/files/dump.json /data/year=2017/month=7/day=4/hour=14
cp $1/components/files/tutorial.ipynb /root/jupyter-notebooks

sudo service jupyter restart

# javascript widget - enable
jupyter nbextension enable --py --sys-prefix widgetsnbextension