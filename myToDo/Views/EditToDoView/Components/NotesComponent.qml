import QtQuick 2.0
import QtQuick.Controls 2.13 //TextArea

Rectangle{
    border.width: 2
    border.color: "grey"
    radius: 3
    height: 250
    Flickable {
        id: flickable
        anchors.fill: parent

        TextArea.flickable: TextArea{
            anchors.fill: parent
            text: currentToDo.notes
            onTextChanged: currentToDo.notes = text
            wrapMode: TextArea.Wrap

        }

        ScrollBar.vertical: ScrollBar { }
    }
}
