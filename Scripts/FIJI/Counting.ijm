inputDir = "E:/OneDrive - The Francis Crick Institute/Training/RMS-DAIM-MSI Workshop/Data"

images = getFileList(inputDir);

for (i = 0; i < images.length; i++) {
	run("Bio-Formats Importer", "open=[" + inputDir + File.separator() + images[i] + "] autoscale color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	run("Split Channels");
	selectImage(1);
	run("Gaussian Blur...", "sigma=1");
	setAutoThreshold("Huang dark");
	//run("Threshold...");
	setAutoThreshold("Default dark");
	setOption("BlackBackground", false);
	run("Convert to Mask");
	run("Analyze Particles...", "summarize");
	close("*");
}