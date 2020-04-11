import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import QtQml.Models 2.1 // for the dekegateModel

import "../MyComponents"

Page {
    id: root

    property var todoListsModel

    function addToList(name, type){
            todoListsModel.append({"name": name,
                                  "type": type,
                                  "attributes": []})
        //TODO: if name exists, make it _2
        return;
    }

    signal openList(int index)

    Component {
        id: dragDelegate

        MouseArea {
            id: dragArea

            property bool held: false

            anchors { left: parent.left; right: parent.right }
            height: content.height

            drag.target: held ? content : undefined
            drag.axis: Drag.YAxis

            onPressAndHold: held = true
            onReleased: held = false

            onClicked: openList(index)

            Rectangle {
                id: content
//![0]
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }
                width: dragArea.width; height: column.implicitHeight + 4

                border.width: 1
                border.color: "grey"

                color: dragArea.held ? "lightsteelblue" : "white"
                Behavior on color { ColorAnimation { duration: 100 } }

                radius: 3
//![1]
                Drag.active: dragArea.held
                Drag.source: dragArea
                Drag.hotSpot.x: width / 2
                Drag.hotSpot.y: height / 2
//![1]
                states: State {
                    when: dragArea.held

                    ParentChange { target: content; parent: root }
                    AnchorChanges {
                        target: content
                        anchors { horizontalCenter: undefined; verticalCenter: undefined }
                    }
                }

                Column {
                    id: column
                    anchors { fill: parent; margins: 2 }
                    Text { text: type }
                    Text { text: name }
                }
//![2]
            }
//![3]
            DropArea {
                anchors { fill: parent; margins: 10 }

                onEntered: {
                    visualModel.items.move(
                            drag.source.DelegateModel.itemsIndex,
                            dragArea.DelegateModel.itemsIndex)
                }
            }
//![3]
        }
    }

    DelegateModel {
        id: visualModel

        model: todoListsModel
        delegate: dragDelegate
    }

    ListView {
        id: view

        anchors { fill: parent; margins: 2 }

        model: visualModel

        spacing: 4
        cacheBuffer: 50
    }

//    ListView{
//        anchors.top: parent.top
//        anchors.bottom: newToDoListButton.top
//        anchors.right: parent.right
//        anchors.left: parent.left

//        spacing: 5

//        delegate: Rectangle{
//            id: todo
//            anchors.left: parent.left
//            anchors.right: parent.right
//            anchors.margins: 5
//            height: root.height / 11

//            border.color: "grey"
//            radius: 3

//            Text{
//                text: name
//            }
//        }

//        model: todoListsModel
//    }

    Button{
        id: newToDoListButton
        text: qsTr("+ add new")
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        onClicked: newToDoListPopup.open()
    }



    Popup {
        id: newToDoListPopup
        x: parent.width/20
        y: parent.height/4
        width: parent.width - 2 * x
        height: parent.height - 2 * y
        modal: true
        focus: true

        Item{
            anchors.fill: parent
            RadioButton{
                id: toggleList
                text: qsTr("new List")
                anchors.top: parent.top
                anchors.left: parent.left
                checked: true
                onCheckedChanged: {
                    if(checked && newListName.text == "NewGroup")
                        newListName.text = "NewList"
                }
            }

            RadioButton{
                id: toggleGroup
                text: qsTr("new Group")
                anchors.top: parent.top
                anchors.right: parent.right
                checked: false
                onCheckedChanged: {
                    if(checked && newListName.text == "NewList")
                        newListName.text = "NewGroup"
                }
            }

            TextField {
                id: newListName
                text: qsTr("NewList")
                anchors.top: toggleList.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                onAccepted: {
                    var type = ""
                    if(toggleList.checked)
                        type = "list"
                    else if(toggleGroup.checked)
                        type = "group"
                    addToList(newListName.text, type)
                    newToDoListPopup.close()
                }
            }
            Button{
                text: qsTr("Accept")
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                onClicked: {
                    //TODO: add new List
                    var type = ""
                    if(toggleList.checked)
                        type = "list"
                    else if(toggleGroup.checked)
                        type = "group"
                    addToList(newListName.text, type)
                    newToDoListPopup.close()
                }
            }
            Button{
                text: qsTr("Cancel")
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                onClicked: newToDoListPopup.close()
            }
        }
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    }

    header: ToolBar{
        //TODO: implement
    }

    footer: SwitchViewFooter{

    }

}
