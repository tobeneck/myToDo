import QtQuick 2.0
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13
import Backend 1.0
import ToDo 1.0

import "../MyComponents"
import "./EditToDoView"

Page {
    title: qsTr("ToDo List "+ currentTag)
    id: root

    property var todoListModel
    property var categoryListModel
    property var currentTag
    property var currentIndex

    function addNewToDo(title){
        var startDate = new Date()
        startDate = new Date(startDate.setHours(9))
        startDate = new Date(startDate.setMinutes(0))
        startDate = new Date(startDate.setSeconds(0))
        startDate = new Date(startDate.setMilliseconds(0))

        var endDate = new Date()
        endDate = new Date(endDate.setHours(10))
        endDate = new Date(endDate.setMinutes(0))
        endDate = new Date(endDate.setSeconds(0))
        endDate = new Date(endDate.setMilliseconds(0))

        var remindDate = new Date(startDate.getTime() - 15 * 60000) //15 mins bevore start date
        remindDate = new Date(endDate.setSeconds(0))
        remindDate = new Date(endDate.setMilliseconds(0))

        todoListModel.append({
                         "creationDate": new Date(),
                         "changedDate": new Date(),
                         "changedNumber": 0,

                         "title": title,
                         "done": false,
                         "labels": [],
                         "status": "ToDo", //make it an ID

                         "startDateEnabled": false, //show the date
                         "allDay": false,
                         "type": "ToDo", //show the date
                         "startDate": startDate,
                         "endDate": endDate,

                         "repeatID": 0, //0 do not repeat, 1: days, 2: weeks, 3: months, 4: years
                         "repeatTime": 0, //every x ID

                         "remindID": 0, //0 don't remind, 2: mins, 2: hours, 3:days, 4:weeks, 5:months: 6:years
                         "remindTime": 15,
                         "remindDate": remindDate,

                         "subToDos": [],

                         "notes": ""
                             })
    }

    function reAddToDo(title, done, labels, status, startDateEnabled, allDay, type, startDate, endDate, repeatID, repeatTime, remindID, remindTime, remindDate, subToDos, notes){

        todoListModel.append({
                         "creationDate": new Date(),
                         "changedDate": new Date(),
                         "changedNumber": 0,

                         "title": title,
                         "done": done,
                         "labels": [],
                         "status": status, //make it an ID

                         "startDateEnabled": startDateEnabled,
                         "allDay": allDay,
                         "type": type,
                         "startDate": startDate,
                         "endDate": endDate,

                         "repeatID": repeatID,
                         "repeatTime": repeatTime,

                         "remindID": remindID,
                         "remindTime": remindTime,
                         "remindDate": remindDate,

                         "subToDos": [],

                         "notes": notes
                             })
        //set the subToDos right. Otherwise the data type is not set correctly
        for(var i = 0; i < subToDos.count; i++)
            todoListModel.get(todoListModel.count - 1).subToDos.append({"name": subToDos.get(i).name, "done": subToDos.get(i).done})
        //set the labels
        for(var i = 0; i < labels.count; i++)
            todoListModel.get(todoListModel.count - 1).labels.append({"name": labels.get(i).name, "color": labels.get(i).done})
    }

    Component{
        id: editToDoView
        EditToDoView{
            currentToDo: root.todoListModel.get(currentIndex)
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

            onAccepted: addNewToDo(title)
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

                visible: !done

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        stackView.push(editToDoView)
                    }
                }

                RadioButton {
                    id: doneButton
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 5
                    anchors.left: parent.left

                    onPressed: {
                        print("Pressed " + index)
                        if(repeatID !== 0){
                            var newStartDate
                            var newEndDate
                            switch(repeatID){
                            case 1:
                                newStartDate = new Date(startDate.setDate(startDate.getDate() + repeatTime))
                                newEndDate = new Date(endDate.setDate(endDate.getDate() + repeatTime))
                                break;
                            case 2:
                                newStartDate = new Date(startDate.setDate(startDate.getDate() + remindTime * 7))
                                newEndDate = new Date(endDate.setDate(endDate.getDate() + remindTime * 7))
                                break;
                            case 3:
                                newStartDate = new Date(startDate.setMonth(startDate.getMonth() + remindTime))
                                newEndDate = new Date(endDate.setMonth(endDate.getMonth() + remindTime))
                                break;
                            case 4:
                                newStartDate = new Date(startDate.setMonth(startDate.getMonth() + remindTime * 12))
                                newEndDate = new Date(endDate.setMonth(endDate.getMonth() + remindTime * 12))
                                break;
                            default:
                                print("error! repeatID out of range!")
                            }
                            reAddToDo(title, done, labels, status, startDateEnabled, allDay, type, newStartDate, newEndDate, repeatID, repeatTime, remindID, remindTime, remindDate, subToDos, notes)
                        }
                        //todoListModel.remove(index)
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
    header: ViewHeadder{

    }

    footer: SwitchViewFooter{

    }

}
