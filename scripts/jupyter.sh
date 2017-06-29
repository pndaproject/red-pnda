#!/bin/bash

if [[ ! $(pip freeze | grep jupyter)  ]]; then
	sudo apt-get -y install ipython ipython-notebook
	if [[ $2 -eq 1 ]]; then
		sudo pip --proxy ${http_proxy} install --upgrade pip
		sudo pip --proxy ${http_proxy} install jupyter
	else
		sudo -H pip install --upgrade pip
		sudo -H pip install jupyter
	fi
	# to run pyspark on jupyter notebook, enter
	echo "export PYSPARK_DRIVER_PYTHON=jupyter" >> ~/.bashrc
	echo "export PYSPARK_DRIVER_PYTHON_OPTS='notebook --ip=0.0.0.0 --port=9000'" >> ~/.bashrc
	source ~/.bashrc

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
	cp $1/scripts/files/jupyter.conf /etc/init

	# create pyspark kernel
	mkdir -p /usr/local/share/jupyter/kernels/pyspark

	cp $1/scripts/files/pyspark-kernel.json /usr/local/share/jupyter/kernels/pyspark/kernel.json

	cp $1/scripts/files/PNDA+minimal+notebook.ipynb /root/jupyter-notebooks

	sudo service jupyter restart

	# javascript widget - enable
	jupyter nbextension enable --py --sys-prefix widgetsnbextension
else
	echo "Jupyter already installed. Moving on!"
fi