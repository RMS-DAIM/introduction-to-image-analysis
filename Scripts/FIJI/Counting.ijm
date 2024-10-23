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

// Specify the input directory
inputDir = getDirectory("Select Input Directory");

// Get the list of files in the input directory
images = getFileList(inputDir);

print("\\Clear");
print("Found " + images.length + " files in " + inputDir);
print("0% of images processed.");

// Iterate over all files
for (i = 0; i < images.length; i++) {
	print("\\Update:" + (100.0 * i / images.length) + "% of images processed.");
	// Open each image with Bio-Formats (www.openmicroscopy.org/bio-formats) to ensure correct reading of metadata
	run("Bio-Formats Importer", "open=[" + inputDir + File.separator() + images[i] + "] autoscale color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	// Split the image into constituent channels - this could also be done in the step above via Bio-Formats
	run("Split Channels");
	// Select the nth image, assuming this is the channel of interest
	selectImage(1);
	// Smooth the image with Gaussian blurring using the specified radius
	run("Gaussian Blur...", "sigma=1");
	// Segment objects of interest using grey-level thresholding
	setAutoThreshold("Default dark");
	setOption("BlackBackground", false);
	run("Convert to Mask");
	// Get the number of objects in the image, which will be printed in the results table
	run("Analyze Particles...", "summarize");
	// Close all open images
	close("*");
}
print("\\Update:100% of images processed.");