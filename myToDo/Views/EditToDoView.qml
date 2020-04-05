import QtQuick 2.14
import QtQuick.Controls 1.4
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

import "../MyComponents"

Page {
    title: todoListModel.get(currentIndex).title

    property var currentToDo

    function updateUI(){
        //due date is picked
        if(!currentToDo.startDateEnabled){
            pickStartTimeText.text = qsTr("Pick Due Date")
            pickStartTimeText.color = "grey"
            deleteDueDate.enabled = false
        }
        else{
            pickStartTimeText.text = qsTr("Due ") + currentToDo.startDate.toLocaleDateString(Qt.locale("de_DE"))
            pickStartTimeText.color = "black"
            deleteDueDate.enabled = true
        }

        //if due date
//            if(currentToDo.startDateEnabled && !currentToDo.endDateEnabled && currentToDo.startTime === 0 && currentToDo.endTime === 0){
//                pickStartTimeText.text = qsTr("Pick Date and Time")
//                pickStartTimeText.color = "grey"
//            }
        //if just due date and end date
        //if just due date and time
        //if both due and end date aswell as time

//            startTimeText.text = currentToDo.startTime === 0 ? qsTr("No starting time") : qsTr("Starting Time: ") + currentToDo.startTime
//            startTimeText.color = currentToDo.startTime === 0 ? "grey" : "black"

//            durationText.text = currentToDo.duration === 0 ? qsTr("No duration") : qsTr("Duration: ") + currentToDo.duration
//            durationText.color = currentToDo.duration === 0 ? "grey" : "black"

//            reminderText.text = currentToDo.reminder === 0 ? qsTr("Don't remind me") : qsTr("Remind me ") + currentToDo.reminder + "bevore" //TODO: change
//            reminderText.color = currentToDo.reminder === 0 ? "grey" : "black"

//            repeatText.text = currentToDo.repeatID === -1 ? qsTr("Don't repeat") : qsTr("Repeat every ") + currentToDo.repeatTime + " " + repeatListModel.get(currentToDo.repeatID).name
//            repeatText.color = currentToDo.repeatID === -1 ? "grey" : "black"
    }


    ListModel{
        id: repeatListModel
        ListElement{ name: qsTr("Don't repeat") }
        ListElement{ name: qsTr("Day") }
        ListElement{ name: qsTr("Week") }
        ListElement{ name: qsTr("Month") }
        ListElement{ name: qsTr("Year") }
    }

    ColumnLayout{
        id: root
        anchors.fill: parent

        Component.onCompleted: updateUI()


        GridLayout{
            columns: 2
            Text{ //TODO: include start time
                id: pickStartTimeText
                Layout.fillWidth: true
                MouseArea{
                    anchors.fill: parent
                    onClicked: pickStartTimePopup.open()
                }
            }
            Button{
                id: deleteDueDate
                text: "x"
                onClicked: {
                    currentToDo.startDateEnabled = false
                    currentToDo.startDate = new Date()
                    root.updateUI()
                }
            }

            Text{ //TODO: include start time
                id: endTimeText
                Layout.fillWidth: true
                MouseArea{
                    anchors.fill: parent
                    onClicked: pickEndTimePopup.open()
                }
            }
            Button{
                text: "x"
                onClicked: {
                    currentToDo.endDateEnabled = false
                    currentToDo.endDate = new Date()
                    root.updateUI()
                }
            }

            Text{ //TODO: activate/show when ready
                id: reminderText
                Layout.fillWidth: true
                MouseArea{
                    anchors.fill: parent
                    onClicked: pickStartTimePopup.open()
                }
            }
            Button{
                text: "x"
            }

            Text{ //TODO: activate/enable when ready
                id: repeatText
                Layout.fillWidth: true
                MouseArea{
                    anchors.fill: parent
                    //onClicked: pickTimePopup.open()
                }
            }
            Button{
                text: "x"
                onClicked: {
                    currentToDo.repeatID = -1
                    root.updateUI()
                }
            }
        } //GridLayout


        //Categorys
        RowLayout{
            Layout.fillWidth: true
            ComboBox {
                Layout.fillWidth: true
                id: categoryBox
                editable: true
                model: categorys

                textRole: "text"

                onAccepted: {
                    if (find(currentText) === -1) {
                        categorys.append({text: editText})
                        currentIndex = find(editText)
                    }
                }
            }
            Button{
                text: qsTr("Edit Categorys")
                onClicked: print("ToDo: add edit categorys")
            }
        }

        //Status
        ComboBox {
            id: statusBox

            textRole: "text"

            editable: true
            model: categorys
            onAccepted: {
                if (find(currentText) === 0) {
                    model.append({text: editText})
                    currentIndex = find(editText)
                }
            }
        }

        //TODO: sub EditToDos


        //Notes
        Rectangle{
            border.width: 3
            border.color: "grey"
            radius: 3
            Layout.fillWidth: true
            Layout.fillHeight: true
            TextArea{
                anchors.fill: parent
                text: currentToDo.notes
                onTextChanged: currentToDo.notes = text
            }
        }

        //TODO: comments

    }


    PickDueDatePopup{
        id: pickStartTimePopup
        onUpdateValues: {
            currentToDo.startDateEnabled = true
            currentToDo.startDate = date
            updateUI()
        }
    }

    PickDateAndTimePopup{
        id: pickEndTimePopup
        onUpdateValues: {
            currentToDo.endDateEnabled = true
            currentToDo.endDate = date
            currentToDo.endTime = hours * 60 + minutes
            updateUI()
        }
    }


}//Page
