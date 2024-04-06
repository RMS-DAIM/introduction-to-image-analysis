/*
 * Introduction to Image Analysis Workshop
 * 
 * Author: Dave Barry (david.barry@crick.ac.uk)
 * 
 * Counts all objects in a specified channel in a series of input images
 * 
 * CC-BY-SA-4.0 license: creativecommons.org/licenses/by-sa/4.0/
 * 
 */

// Specify default values for variables
var inputDir = "C:/Users/davej/GitRepos/Pages/introduction-to-image-analysis/Data/idr0028"
var gaussRad = 1.0;
var thresholdMethod = "Default";
var allThreshMethods = getList("threshold.methods");
var DAPIIndex = 1;

// Create dialog to obtain input from user
Dialog.create("Batch Counting");
Dialog.addDirectory("Input Directory:", inputDir);
Dialog.addNumber("DAPI Channel:", DAPIIndex);
Dialog.addNumber("Gaussian Filter Radius:", gaussRad);
Dialog.addChoice("Threshold Method:", allThreshMethods);
Dialog.show();

inputDir = Dialog.getString();
DAPIIndex = Dialog.getNumber();
gaussRad = Dialog.getNumber();
thresholdMethod = Dialog.getChoice();

// Get the list of files in the input directory
images = getFileList(inputDir);

setBatchMode(true);

print("Input Directory: " + inputDir);

// Iterate over all files
for (i = 0; i < images.length; i++) {
	print("Processing " + images[i]);
	// Open each image with Bio-Formats (www.openmicroscopy.org/bio-formats) to ensure correct reading of metadata
	run("Bio-Formats Importer", "open=[" + inputDir + File.separator() + images[i] + "] autoscale color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	// Split the image into constituent channels - this could also be done in the step above via Bio-Formats
	run("Split Channels");
	// Select the nth image, assuming this is the channel of interest
	selectImage(DAPIIndex);
	// Smooth the image with Gaussian blurring using the specified radius
	run("Gaussian Blur...", "sigma=" + gaussRad);
	// Segment objects of interest using grey-level thresholding
	setAutoThreshold(thresholdMethod + " dark");
	setOption("BlackBackground", false);
	run("Convert to Mask");
	// Get the number of objects in the image, which will be printed in the results table
	run("Analyze Particles...", "summarize");
	// Close all open images
	close("*");
}

setBatchMode(false);

print("All Done");
