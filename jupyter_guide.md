# Jupyter 

### Connecting

Jupyter is deployed with two kernel supports: Python2 kernel and PySpark (Python2) kernel. An example Jupyter notebook is also provided with details instructions on how to rapid prototype using Jupyter PySpark kernel. 

By default, Jupyter is installed on port `9000`. In order to access Jupyter portal go to:

    http://<Accessible-IP>:9000
    
When prompted for a password, enter `pnda`

### QuickStart

You should see a jupyter login page as seen below

<img src="images/jupyter_images/login_page.png" alt="login" style="width: 600px;"/>

Enter `pnda` to login to the server, you should see the default notebook list view

<img src="images/jupyter_images/Step_1.png" alt="login" style="width: 600px;"/>

#### Open Example Notebook

Click on the link `PNDA minimal notebook.ipynb` 

<img src="images/jupyter_images/Step_2.png" alt="login" style="width: 600px;"/>

### Create a notebook

To create a Spark notebook, click on New -> PySpark kernel.

<img src="images/jupyter_images/Step_3.png" alt="login" style="width: 600px;"/>

Edit your file, save it going to File -> Save and Checkpoint.