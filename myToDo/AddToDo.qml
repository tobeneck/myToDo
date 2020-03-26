import QtQuick 2.0
import QtQuick.Controls 2.14

Rectangle {
    border.color: "black"
    border.width: 2
    radius: 10

    signal accepted(string title)

    TextField{
        id: newToDo

        anchors.fill: parent

        onAccepted: {
            //TODO: test if valid/zero entery
            var newTitle = newToDo.text
            if(newTitle.trim() === '')
                return
            else{
                parent.accepted(newTitle)
                newToDo.text = ""
            }
        }
    }
}
