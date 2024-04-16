# Preparation For Introduction to Image Analysis Workshop

Please read the following instructions carefully to prepare for the workshop. Completing these steps prior to the workshop is essential to ensure we stay on schedule. If you are having any trouble with the below instructions, please reach out for help:
* For issues with FIJI, contact Dave (David.Barry@crick.ac.uk)
* For conda issues, contact Stefania (stefania.marcotti@kcl.ac.uk)

## Installing FIJI

1. Download FIJI from [here](https://fiji.sc/).

   ![FIJI Webpage](https://github.com/RMS-DAIM/introduction-to-image-analysis/raw/dublin-2024.04.24/assets/FIJI.png)

2. To avoid any permissions issues, install FIJI is in your home directory:
   * PC: `C:\users\<your user name>`
   * Mac: `/Users/<your user name>`

   > **WARNING: FIJI *must* be installed in a location where it has write permission - otherwise, it cannot update itself**

3. Start FIJI and allow the updater to run:

   ![FIJI Webpage](https://github.com/RMS-DAIM/introduction-to-image-analysis/raw/dublin-2024.04.24/assets/Updater.png)

4. (Optional) If the updater does not run automatically, select `Help > Update`:

   ![FIJI Webpage](https://github.com/RMS-DAIM/introduction-to-image-analysis/raw/dublin-2024.04.24/assets/Run_Updater.png)

5. If FIJI produces any error messages, it is most likely because it does not have the necessary permissions to update itself - return to step #2 and double-check the location of the installation.

## Installing conda

1. Install Miniconda by following the installation instructions for your operating system at [this page](https://docs.anaconda.com/free/miniconda/miniconda-install/)
2. Please check that the installation worked properly by opening the Terminal (MacOS) or Anaconda Prompt (Windows) and typing `conda list`. If conda has been installed correctly, a list of installed packages appears.

FAQ: "What should I do if I already have `conda` installed on my machine?"

Please make sure that your `conda` installation is up to date. To do so, run the following command:
```
conda --version
```
If this returns a version older than `23.10.0`, please update your `conda` by running:
```
conda update -n base conda
```
