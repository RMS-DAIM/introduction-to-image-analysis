/*
 * Introduction to Image Analysis Workshop
 * 
 * Author: Dave Barry (david.barry@crick.ac.uk)
 * 
 * Calculates the nuclear-to-cytoplasmic intensity of a particular signal in a series of input images
 * 
 * CC-BY-SA-4.0 license: creativecommons.org/licenses/by-sa/4.0/
 * 
 */

// Specify the input directory
inputDir = "C:/Users/davej/GitRepos/Pages/introduction-to-image-analysis/Data/idr0028"

// Get the list of files in the input directory
images = getFileList(inputDir);

// Iterate over all files
for (i = 0; i < 1; i++) {
	// Open each image with Bio-Formats (www.openmicroscopy.org/bio-formats) to ensure correct reading of metadata
	run("Bio-Formats Importer", "open=[" + inputDir + File.separator() + images[i] + "] autoscale color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	// Split the image into constituent channels - this could also be done in the step above via Bio-Formats
	run("Split Channels");
	// Get names of each channel and assign to variables
	selectImage(1);
	nuc = getTitle();
	selectImage(2);
	mito = getTitle();
	selectImage(3);
	actin = getTitle();
	selectImage(4);
	fluor = getTitle();
	// Let's start with the nuclear channel
	selectImage(nuc);
	// Smooth the nuclei before segmenting
	run("Gaussian Blur...", "sigma=1");
	// Segment the nuclei using grey scale thresholding
	setAutoThreshold("Default dark");
	setOption("BlackBackground", false);
	run("Convert to Mask");
	// Move on to the actin channel
	selectImage(actin);
	// Smooth before segmenting
	run("Gaussian Blur...", "sigma=1");
	// Segment using grey level thresholding
	setAutoThreshold("Huang dark");
	setOption("BlackBackground", false);
	run("Convert to Mask");
	// Now we label the segmented nuclear image
	selectImage(nuc);
	run("Connected Components Labeling", "connectivity=4 type=[16 bits]");
	// Save the name of the nuclear labelled image
	nuc_labels = getTitle();
	// Segment the cells using marker-controlled watershed, specifying the labelled nuclear image and segmented actin channel as inputs
	run("Marker-controlled Watershed", "input=[" + actin + "] marker=[" + nuc_labels + "] mask=[" + actin + "] compactness=0 calculate use");
	// Save the title of the labelled cell image
	watershed = getTitle();
	// Calculated the difference between the labelled cell image and the labelled nuclei image to generate a labelled cytoplasm image
	imageCalculator("Difference create", nuc_labels, watershed);
	// Save the title of the labelled cytoplasm image
	cyto = getTitle();
	// Measure fluorescent intensity in the nuclei
	run("Intensity Measurements 2D/3D", "input=[" + fluor + "] labels=[" + nuc_labels + "] mean");
	// Save the mean intensities as a variable
	nuc_intens = Table.getColumn("Mean");
	// Measure the fluorescence intensity in the cytoplasm
	run("Intensity Measurements 2D/3D", "input=[" + fluor + "] labels=[" + cyto + "] mean");
	// Save the mean intensities as a variable
	cyto_intens = Table.getColumn("Mean");
	// Create a table for the results
	Table.create("Nuclear-to-cytoplasmic Ratios");
	// Loop over all the values in the fluorescence intensities measured in the nuclei
	for (j = 0; j < nuc_intens.length; j++) {
		Table.set("Label", j, j + 1);
		// Calculate the nuclear-to-cytoplasmic ratio for each cell
		Table.set("Ratio", j, nuc_intens[j] / cyto_intens[j]);
	}
	// Save the results as a CSV file
	saveAs("Results", "E:/OneDrive - The Francis Crick Institute/Training/RMS-DAIM-MSI Workshop/Outputs/Nuclear-to-cytoplasmic Ratios.csv");
	// Generate a visualisation of the results, based on the segmented cell image, using a look-up table based on the nuclear-to-cytoplasmic ration in each cell
	selectImage(watershed);
	call("inra.ijpb.plugins.LabelToValuePlugin.process", "Table=Nuclear-to-cytoplasmic Ratios.csv", "Column=Ratio", "Min=0.0", "Max=10.0");
	run("Assign Measure to Label");
	run("gem");
	// Generate a calibration bar for the visualisation
	run("Calibration Bar...", "location=[Upper Right] fill=White label=Black number=5 decimal=0 font=12 zoom=1");
	// Save the visualisation
	saveAs("PNG", "E:/OneDrive - The Francis Crick Institute/Training/RMS-DAIM-MSI Workshop/Outputs/C3-003003-10-watershed-Ratio with bar.png");
	// Close all open images
	close("*");
}