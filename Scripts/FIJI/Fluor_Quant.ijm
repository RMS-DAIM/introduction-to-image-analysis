inputDir = "E:/OneDrive - The Francis Crick Institute/Training/RMS-DAIM-MSI Workshop/Data"

images = getFileList(inputDir);

for (i = 0; i < 1; i++) {
	run("Bio-Formats Importer", "open=[" + inputDir + File.separator() + images[i] + "] autoscale color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	run("Split Channels");
	selectImage(1);
	nuc = getTitle();
	selectImage(2);
	mito = getTitle();
	selectImage(3);
	actin = getTitle();
	selectImage(4);
	fluor = getTitle();
	selectImage(nuc);
	run("Gaussian Blur...", "sigma=1");
	setAutoThreshold("Huang dark");
	//run("Threshold...");
	setAutoThreshold("Default dark");
	setOption("BlackBackground", false);
	run("Convert to Mask");
	selectImage(actin);
	run("Gaussian Blur...", "sigma=1");
	setAutoThreshold("Huang dark");
	//run("Threshold...");
	setOption("BlackBackground", false);
	run("Convert to Mask");
	selectImage(nuc);
	run("Connected Components Labeling", "connectivity=4 type=[16 bits]");
	nuc_labels = getTitle();
	run("Marker-controlled Watershed", "input=[" + actin + "] marker=[" + nuc_labels + "] mask=[" + actin + "] compactness=0 calculate use");
	watershed = getTitle();
	imageCalculator("Difference create", nuc_labels, watershed);
	cyto = getTitle();
	run("Intensity Measurements 2D/3D", "input=[" + fluor + "] labels=[" + nuc_labels + "] mean");
	nuc_intens = Table.getColumn("Mean");
	run("Intensity Measurements 2D/3D", "input=[" + fluor + "] labels=[" + cyto + "] mean");
	cyto_intens = Table.getColumn("Mean");
	
	Table.create("Nuclear-to-cytoplasmic Ratios");
	
	for (j = 0; j < nuc_intens.length; j++) {
		Table.set("Label", j, j + 1);
		Table.set("Ratio", j, nuc_intens[j] / cyto_intens[j]);
	}
	
	saveAs("Results", "E:/OneDrive - The Francis Crick Institute/Training/RMS-DAIM-MSI Workshop/Outputs/Nuclear-to-cytoplasmic Ratios.csv");
	selectImage(watershed);
	call("inra.ijpb.plugins.LabelToValuePlugin.process", "Table=Nuclear-to-cytoplasmic Ratios.csv", "Column=Ratio", "Min=0.0", "Max=10.0");
	run("Assign Measure to Label");
	run("gem");
	run("Calibration Bar...", "location=[Upper Right] fill=White label=Black number=5 decimal=0 font=12 zoom=1");
	saveAs("PNG", "E:/OneDrive - The Francis Crick Institute/Training/RMS-DAIM-MSI Workshop/Outputs/C3-003003-10-watershed-Ratio with bar.png");

	close("*");
}