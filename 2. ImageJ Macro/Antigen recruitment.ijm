run("Clear Results");
imax=91;
run("Set Measurements...", "area mean centroid min max center bounding fit shape integrated stack redirect=None decimal=3");

i_init=1
for (i=i_init;i<=imax;i++){
	setSlice(i);
	roiManager("Select", i-i_init);
	run("Measure");
	roiManager("Deselect");
}