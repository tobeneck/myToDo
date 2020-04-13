import QtQuick 2.0
import QtQuick.Layouts 1.13 //RowLayout
import QtQuick.Controls 2.13 //Buttons

//sub EditToDos
Rectangle{
    id: subToDos
    height: childrenRect.height + 10 //the anchor marginns * 2
    border.color: "grey"
    border.width: 2
    radius: 3

    property var subToDosModel

    Text{
        id: subToDosHeadline
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 5
        text: qsTr("Sub ToDos")
    }

    TextField{
        id: addSubToDo
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: subToDosHeadline.bottom
        anchors.margins: 5
        onAccepted: {
            if(addSubToDo.text.trim() !== ""){
                currentToDo.subToDos.append({"name": addSubToDo.text, "done": false})
                addSubToDo.text = ""
                subToDos.height = subToDos.childrenRect.height + 10 //10 = anchor margins * 2
            }
        }
    }


    ListView{
        id: subToDoListView
        anchors.left: parent.left
        anchors.right: parent.right
        //anchors.bottom: parent.bottom
        anchors.top: addSubToDo.bottom
        anchors.margins: 5

        model: subToDosModel

        height: subToDosModel.count * 40 + subToDosModel.count*spacing//delegateHeight

        spacing: 5

        delegate: Rectangle{
            border.color: "grey"
            border.width: 2
            radius: 3
            height: 40//delegateHeight
            anchors.left: parent.left
            anchors.right: parent.right

            RadioButton{
                id: subToDoDone
                checked: done
                anchors.left: parent.left
                onClicked: {
                    currentToDo.subToDos.get(index).done = !currentToDo.subToDos.get(index).done
                }
            }
            Text{
                anchors.left: subToDoDone.right
                anchors.right: delSubToDo.left
                text: name
                color: done ? "grey" : "black"

            }

            Button{
                id: delSubToDo
                anchors.right: parent.right
                text: "x"
                onClicked: {
                    currentToDo.subToDos.remove(index)
                    subToDos.height = subToDos.childrenRect.height + 10 //10=anchor margins * 2
                }
            }

        }

    }//Delegate Rectangle
}
