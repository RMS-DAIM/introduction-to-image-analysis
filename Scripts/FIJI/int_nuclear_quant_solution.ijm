/*
 * Introduction to Image Analysis with FIJI
 * 
 * Author: Sara Salgueiro Torres (sara.salgueirotorres@crick.ac.uk)
 * 
 * Measures the intensity of channel 4 (YAP/TAZ marker) from the nuclear label (channel 1) in a series of input images
 * Assumes 2D images with 4 channels in the following order:
 * 	1 - DAPI (nuclei)
 * 	2 & 3 – not used
 * 	4 – marker of interest
 * 	
 * Requirements:
 * 	- MorphoLibJ plugin: https://imagej.net/plugins/morpholibj
 * 
 * CC-BY-SA-4.0 license: creativecommons.org/licenses/by-sa/4.0/
 * 
 */
 
 
// Specify the input directory
inputDir = getDirectory("Select Input Directory");

// Specify output directory
outputDir = getDirectory("Select Output Directory");

// Get the list of files in the input directory
images = getFileList(inputDir);

print("\\Clear");
print("Found " + images.length + " files in " + inputDir);
print("0% of images processed.");

// Iterate over all files
for (i = 0; i < images.length; i++) {
	
	print("\\Update:" + (100.0 * i / images.length) + "% of images processed.");
	
	// Open each image with Bio-Formats and split channels
	
	run("Bio-Formats Importer",
		"open=[" + inputDir + File.separator() + images[i] + "] autoscale color_mode=Composite rois_import=[ROI manager] split_channels view=Hyperstack stack_order=XYCZT");
	
	// Rename channels
	selectImage(1);
	rename("nuclei");
	selectImage(2);
	rename("tubulin");
	selectImage(3);
	rename("actin");
	selectImage(4);
	rename("yap_taz");
	
	// --------- NUCLEI SEGMENTATION ---------
	selectImage("nuclei");
	// Smooth image with Gaussian blurring with specified radius
	run("Gaussian Blur...", "sigma=2");
	// Segment objects of interest with grey-level thresholding
	setAutoThreshold("Otsu dark no-reset");
	setOption("BlackBackground", true);
	run("Convert to Mask");
	// Create labelled image from binary mask
	run("Connected Components Labeling", "connectivity=4 type=[16 bits]");

	// ------- INTENSITY QUANTIFICATION -------
    selectWindow("nuclei-lbl");
    run("Intensity Measurements 2D/3D",
        "input=yap_taz labels=nuclei-lbl mean stddev median numberofvoxels");

	// Save the image results as a CSV file
	results_name = images[i] +  "_nuclear_yap_intensity_results";
	saveAs("Results", outputDir + File.separator() + results_name + ".csv"); 
	close(images[i] +  "_nuclear_yap_intensity_results.csv");

	// Close all open images
	close("*");
}
print("\\Update:100% of images processed.");