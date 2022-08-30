run("Clear Results");
imax=101;
run("Set Measurements...", "area mean centroid center bounding fit shape integrated stack redirect=None decimal=3");

i_init=45
for (i=i_init;i<=imax;i++){
	setSlice(i);
	roiManager("Select", i-i_init);
	run("Measure");
	BX=getResult("BX",2*(i-i_init));
	BY=getResult("BY", 2*(i-i_init));
	Major=getResult("Major",2*(i-i_init));
	Width=getResult("Width",2*(i-i_init));
	Height=getResult("Height",2*(i-i_init));
	roiManager("Select",i-i_init);
	run("Specify...", "width="+Width/2+" height="+Height+" x="+BX+" y="+BY+" slice="+i+" scaled");
	roiManager("Add");
	roiManager("Select", newArray(i-i_init,imax-i_init+1+2*(i-i_init)));
	roiManager("AND");
	roiManager("Add");
	roiManager("Select", imax-i_init+2+2*(i-i_init));
	run("Measure");
	roiManager("Deselect");
}

for (i=i_init;i<=imax;i++){
	setSlice(i);
	roiManager("Select", i-i_init);
	run("Measure");
	BX=getResult("BX",2*(i-i_init));
	BY=getResult("BY", 2*(i-i_init));
	Major=getResult("Major",2*(i-i_init));
	Width=getResult("Width",2*(i-i_init));
	Height=getResult("Height",2*(i-i_init));
	roiManager("Select",i-i_init);
	run("Specify...", "width="+Width/2+" height="+Height+" x="+BX+Width/2+" y="+BY+" slice="+i+" scaled");
	roiManager("Add");
	roiManager("Select", newArray(i-i_init, 3*(imax-i_init+1)+2*(i-i_init)));
	roiManager("AND");
	roiManager("Add");
	roiManager("Select", 3*(imax-i_init+1)+1+2*(i-i_init));
	run("Measure");
	roiManager("Deselect");
}