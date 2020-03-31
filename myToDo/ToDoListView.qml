import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import Backend 1.0
import ToDo 1.0

Page {
    title: qsTr("ToDo List "+ currentTag)
    id: root

    property var todoListModel
    property var categoryListModel
    property var currentIndex
    property var currentTag: ""

    Component{
        id: editToDoView
        EditToDoView{
            todoListModel: root.todoListModel
            currentToDoIndex: root.currentIndex
        }
    }

    Item {
        anchors.fill: parent

        AddToDo{
            id: addToDoField

            anchors.margins: 5
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: parent.height/10

            onAccepted: {
                todoListModel.append({"title": title,
                                 "path": "ToDo", //TODO
                                 "done":false,
                                 "label":null,
                                 "status": null,
                                 "priority": null,
                                 "due date": null,
                                 "repeat": null,
                                 "reminder":null,
                                 "duration": null,
                                 "notes":""})
            }
        }

        ListView{
            id: todoListView

            anchors.top: addToDoField.bottom
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.margins: 5

            spacing: 3

            delegate: Rectangle{
                id: todo
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 5
                height: addToDoField.height

                border.color: "grey"
                border.width: 2
                radius: 3

                property int indexOfThisDelegate: index

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        root.currentIndex = indexOfThisDelegate
                        stackView.push(editToDoView)
                    }
                }

                RadioButton {
                    id: doneButton
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 5
                    anchors.left: parent.left

                    onPressed: {
                        print("Pressed " + indexOfThisDelegate)
                        todos.remove(indexOfThisDelegate)
                    }
                }

                Text {
                    text: title
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 5
                    anchors.left: doneButton.right
                    anchors.right: parent.right
                }

            }

            populate: Transition {
                NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 1000 }
            }

//            remove: Transition { //TODO: change this animation
//                ParallelAnimation {
//                    NumberAnimation { property: "opacity"; to: 0; duration: 1000 }
//                    //NumberAnimation { properties: "x,y"; to: 100; duration: 1000 }
//                }
//            }

            model: todoListModel
        }
    }

}
