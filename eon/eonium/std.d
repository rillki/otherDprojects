module eonium.std;

T[][] dupl(T)(T[][] data) {
	T[][] handle = data.dup;
	foreach(i, ref h; handle) { h = data[i].dup; }

	return handle;
}