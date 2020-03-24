import pyd.pyd;
import pyd.embedded;

/*
    Do not forget to specify the Python version installed on your system in dub.json
    "subConfigurations": {
    	"pyd": "python27",
    }

    For more information check out:
    Github:				https://github.com/ariovistus/pyd
    PyD documentation:	https://pyd.readthedocs.io/en/latest/index.html
*/

// initializing python
shared static this() {
	py_init();
}

void main() {
	// creating an interoperability context for communicating with python
	auto context = new InterpContext();

	// a string containing python code
	string pycode = "import os;os.system('python3 script.py')";

	// execute python code
	context.py_stmts(pycode); 
}
