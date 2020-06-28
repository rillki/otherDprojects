import gtk.Main;
import gtk.MainWindow;
import gtk.Entry;
import gtk.Button;
import gtk.Widget;
import gtk.Box;
import gtk.CheckButton;
import gtk.ToggleButton;
import gtk.Dialog;
import gtk.MessageDialog;

immutable winTitle = "Extension-er";
immutable winWidth = 360;
immutable winHeight = 140;

void main(string[] args) {
	AppWindow window;												// window class
	
	Main.init(args);												// init gtkd

	window = new AppWindow();										// create a window
		
	Main.run();														// give control over to gtkd's loop
}

// Window
class AppWindow : MainWindow {
	EntryBox box;
		
	this() {
		super(winTitle);
		setSizeRequest(winWidth, winHeight);
		addOnDestroy(&quitApp);
		
		box = new EntryBox(this);
		add(box);
		
		showAll();
	}
	
	
	void quitApp(Widget w) {
		//	
	}
}

// EntryBox for entering text
class EntryBox : Box {
	int globalPadding = 15;

	Entry entryPath, entryExtension;								// entries
	Button button;													// button

	MainWindow window;

	this(MainWindow window) {										// init
		this.window = window;
		super(Orientation.VERTICAL, globalPadding);

		entryPath = new Entry();
		entryExtension = new Entry();
		entryPath.setText("folder path");
		entryExtension.setText("new extension");

		button = new Button("START");
		button.addOnClicked(delegate void(Button b) { start(); });
		
		add(entryPath);
		add(entryExtension);
		add(button);
	}

	void start() {
		import std.conv: to;

		char[] path = entryPath.getText().to!(char[]);				// get text from an entry
		string extension = entryExtension.getText();				// get text from an entry

		foreach(ref c; path) {
			if(c == '\\') {
				c = '/';
			}
		}

		if(path[path.length-1] != '/') {
			path ~= "/";
		}

		string stringPath = path.to!string;							// convert char[] to string
		string[] list;

	    import std.exception : collectException;					// catch any exception
		auto e = collectException(list = listdir(stringPath));
		if (e) {
			AppMessageDialog dialog = new AppMessageDialog(window, "Alert!", "\n\n\nError: Invalid path!"); // if error, output: invalid path
		} else {
			changeExtension(stringPath, list, extension);
		}
	}

	void changeExtension(string path, string[] list, string extension) {
		import std.file: rename;

		foreach(l; list) {												// get file name without the old extension
			string newFilename;
			foreach(c; l) {
				if(c == '.') {
					break;
				}

				newFilename ~= c;
			}

			rename(path ~ l, path ~ newFilename ~ "." ~ extension);  	// change file extention to new extention specified by the user
		}

		AppMessageDialog dialog = new AppMessageDialog(window, "Alert!", "\n\n\nFILE EXTENSION CHANGED!"); // notify of success
	}
}

// Dialog
class AppMessageDialog : MessageDialog {
	GtkDialogFlags flags = GtkDialogFlags.MODAL;
	MessageType messageType = MessageType.INFO;
	ButtonsType buttonType = ButtonsType.OK;
	int responseID;
	
	string[] list;
	string path, extension;

	MainWindow window;

	this(MainWindow window, string title, string msg) {
		super(window, flags, messageType, buttonType, msg);
		setTitle(title);
		setSizeRequest(winWidth, winHeight);
		addOnResponse(&nothing);
		run();
		destroy();
	}

	void nothing(int response, Dialog d) {}
}

string[] listdir(string pathname) {										// get all files in the directory
    import std.algorithm;
    import std.array;
    import std.file;
    import std.path;

    return std.file.dirEntries(pathname, SpanMode.shallow)
        .filter!(a => a.isFile)
        .map!(a => std.path.baseName(a.name))
        .array;
}









