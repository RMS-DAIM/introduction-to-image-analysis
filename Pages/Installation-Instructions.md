Please read the following instructions carefully to prepare for the workshop.

# Installing FIJI

1. Download FIJI from [here](https://fiji.sc/).

![FIJI Webpage](/assets/FIJI.png)

2. To avoid any permissions issues, install FIJI is in your home directory:
  * PC: `C:\users\<your user name>`
  * Mac: `/Users/<your user name>`

> [!WARNING]
> FIJI *must* be installed in a location where it has write permission - otherwise, it cannot update itself

3. Start FIJI and allow the updater to run:

![FIJI Webpage](/assets/Updater.png)

4. (Optional) If the updater does not run automatically, select `Help > Update`:

![FIJI Webpage](/assets/Run_Updater.png)

5. If FIJI produces any error messages, it is most likely because it does not have the necessary permissions to update itself - return to step #2 and double-check the location of the installation.

# Installing conda

1. Install Miniconda by following the installation instructions for your operating system at [this page](https://docs.anaconda.com/free/miniconda/miniconda-install/)
2. Please check that the installation worked properly by opening the Terminal (MacOS) or Anaconda Prompt (Windows) and typing `conda list`. If conda has been installed correctly, a list of installed packages appears.
3. Switch to the faster `libmamba` solver, by updating conda and then installing and activating the solver. Do so by typing the following command in the Terminal/Anaconda Prompt one at a time and pressing Enter after each one:
  
  `conda update -n base conda`

  `conda install -n base conda-libmamba-solver`

  `conda config --set solver libmamba`

