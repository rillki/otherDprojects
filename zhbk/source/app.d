module main;

import dlangui;

mixin APP_ENTRY_POINT;

/// entry point for dlangui based application
extern (C) int UIAppMain(string[] args) {
    // create window
    Window window = Platform.instance.createWindow("DlangUI example - HelloWorld", null);

    // create layout from DML
    auto layout = parseML(q{
        TableLayout {
            colCount: 3
            // margins: 20; padding: 10
            // backgroundColor: "#FAFBE8"

            TextWidget { text: "Label 1"; margins: 7; padding: 3 }
            EditLine { text: "123"; margins: 7; padding: 3 }
            TextWidget { text: "Label 1"; margins: 7; padding: 3 }

            TextWidget { text: "Label 1"; margins: 7; padding: 3 }
            EditLine { text: "123"; margins: 7; padding: 3 }
            TextWidget { text: "Label 1"; margins: 7; padding: 3 }

            TextWidget { text: "Label 1"; margins: 7; padding: 3 }
            EditLine { text: "123"; margins: 7; padding: 3 }
            TextWidget { text: "Label 1"; margins: 7; padding: 3 }

            TextWidget { text: "Label 1"; margins: 7; padding: 3 }
            EditLine { text: "123"; margins: 7; padding: 3 }
            TextWidget { text: "Label 1"; margins: 7; padding: 3 }

            TextWidget { text: "Label 1"; margins: 7; padding: 3 }
            EditLine { text: "123"; margins: 7; padding: 3 }
            TextWidget { text: "Label 1"; margins: 7; padding: 3 }

            TextWidget { text: "Label 1"; margins: 7; padding: 3 }
            EditLine { text: "123"; margins: 7; padding: 3 }
            TextWidget { text: "Label 1"; margins: 7; padding: 3 }

            TextWidget { text: "Label 1"; margins: 7; padding: 3 }
            EditLine { text: "123"; margins: 7; padding: 3 }
            TextWidget { text: "Label 1"; margins: 7; padding: 3 }

            TextWidget { text: "Label 1"; margins: 7; padding: 3 }
            EditLine { text: "123"; margins: 7; padding: 3 }
            TextWidget { text: "Label 1"; margins: 7; padding: 3 }

            TextWidget { text: "Label 1"; margins: 7; padding: 3 }
            EditLine { text: "123"; margins: 7; padding: 3 }
            TextWidget { text: "Label 1"; margins: 7; padding: 3 }

            TextWidget { text: "Label 1"; margins: 7; padding: 3 }
            EditLine { text: "123"; margins: 7; padding: 3 }
            TextWidget { text: "Label 1"; margins: 7; padding: 3 }

            TextWidget { text: "Label 1"; margins: 7; padding: 3 }
            EditLine { text: "123"; margins: 7; padding: 3 }
            TextWidget { text: "Label 1"; margins: 7; padding: 3 }

            TextWidget { text: "Label 1"; margins: 7; padding: 3 }
            EditLine { text: "123"; margins: 7; padding: 3 }
            TextWidget { text: "Label 1"; margins: 7; padding: 3 }

            TextWidget { text: "Some buttons"; margins: 7; padding: 3 }
            ComboBox { items: ["item 1", "item 2", "item 3"] }
            TextWidget { text: "Some buttons"; margins: 7; padding: 3 }
            HorizontalLayout {
                Button { text: "Ok"; margins: 7; padding: 3 }
                Button { text: "Cancel"; margins: 7; padding: 3 }
            }
        }
    });

    // set window content widget
    window.mainWidget = layout;

    // show window
    window.show();

    // run message loop
    return Platform.instance.enterMessageLoop();
}


