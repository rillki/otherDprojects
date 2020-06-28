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
			AppMessageDialog dialog = new AppMessageDialog(window, "\n\n\nError: Invalid path!"); // if error, output: invalid path
		} else {
			AppMessageDialog dialog = new AppMessageDialog(window, stringPath, list, extension); // procede further
		}
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

	this(MainWindow window, string msg) {
		super(window, flags, messageType, buttonType, msg);
		setTitle("Alert!");
		setSizeRequest(200, 150);
		addOnResponse(&nothing);
		run();
		destroy();
	}

	this(MainWindow window, string path, string[] list, string extension) {
		this.path = path;
		this.list = list;
		this.extension = extension;
		this.window = window;

		string msg;
		msg ~= "CHANGE EXTENSION?\n\n";
		foreach(l; list) {
			msg ~= l ~ "\n";
		}

		super(window, flags, messageType, buttonType, msg);
		setTitle("Alert!");
		setSizeRequest(200, 150);
		addOnResponse(&doSomething);
		run();
		destroy();
	}

	
	void doSomething(int response, Dialog d) {
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

		AppMessageDialog dialog = new AppMessageDialog(window, "\n\n\nFILE EXTENSION CHANGED!"); // notify of success
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









