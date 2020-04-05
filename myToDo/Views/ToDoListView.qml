import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import Backend 1.0
import ToDo 1.0

import "../MyComponents"

Page {
    title: qsTr("ToDo List "+ currentTag)
    id: root

    property var todoListModel
    property var categoryListModel
    property var currentTag
    property var currentIndex

    Component{
        id: editToDoView
        EditToDoView{
            currentToDo: root.todoListModel.get(currentIndex)
        }
    }

    header: ToolBar { //TODO: implement
        contentHeight: testText.implicitHeight
        Text{
            id:testText
            text: "ToDoListViewHeadder"
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
                //TODO: standardise somewhere
                todoListModel.append({"createdOn": new Date(),
                                 "title": title,
                                 "done": false,
                                 "labels": [],
                                 "status": "ToDo", //make it an ID
                                 "priority": 3, //1-5

                                 "startDate": new Date(),
                                 "startDateEnabled": false, //show the date
                                 "startTime": 0, //0 for disabled, mins from 00:00 otherwise
                                 "endDate": new Date(),
                                 "endDateEnabled": false, //show the date
                                 "endTime": 0, //0 for disabled, mins from 00:00 otherwise

                                 "repeatID": 0, //0 do not repeat, 1: days, 2: weeks, 3: months, 4: years
                                 "repeatTime": 0, //every x ID
                                 "reminder": 0, //mins bevore
                                 "duration": 0, //duration in mins
                                 "notes": ""})
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
                    text: !startDateEnabled ? title : title + "\n" + startDate.toLocaleDateString(Qt.locale("de_DE"))
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