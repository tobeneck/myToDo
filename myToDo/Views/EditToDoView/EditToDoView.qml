import QtQuick 2.14
import QtQuick.Controls 1.4
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

import "../../MyComponents"
import "Components"

Page {
    id: editToDoView
    title: todoListModel.get(currentIndex).title

    property var currentToDo

    ListModel{
        id: repeatListModel
        ListElement{ name: qsTr("Don't repeat") }
        ListElement{ name: qsTr("Day") }
        ListElement{ name: qsTr("Week") }
        ListElement{ name: qsTr("Month") }
        ListElement{ name: qsTr("Year") }
    }

    ListModel{
        id: remindListModel
        ListElement{ name: qsTr("Don't remind") }
        ListElement{ name: qsTr("Minutes bevore") }
        ListElement{ name: qsTr("Hours bevore") }
        ListElement{ name: qsTr("Days bevore") }
        ListElement{ name: qsTr("Weeks bevore") }
        ListElement{ name: qsTr("Months bevore") }
        ListElement{ name: qsTr("Years bevore") }
    }

    function updateUI(){
        //set the date and time texts
        if(currentToDo.startDateEnabled){
            startDatePrefix.color = "black"
            deleteDueDate.enabled = true
            if(currentToDo.type === "ToDo"){
                startDatePrefix.text = qsTr("Due: ")
                startDate.text = currentToDo.startDate.toLocaleDateString(Qt.locale("de_DE"))
                startTime.text = ""
                endDatePrefix.text = ""
                endDate.text = ""
                endTime.text = ""
            }
            if(currentToDo.type === "Event"){
                startDatePrefix.text = qsTr("From: ")
                startDate.text = currentToDo.startDate.toLocaleDateString(Qt.locale("de_DE"))
                endDatePrefix.text = qsTr("to: ")
                endDate.text = currentToDo.endDate.toLocaleDateString(Qt.locale("de_DE"))
                if(currentToDo.allDay){
                    startTime.text = ""
                    endTime.text = ""
                }
                else{
                    startTime.text = currentToDo.startDate.toLocaleTimeString("hh:mm")
                    endTime.text = currentToDo.endDate.toLocaleTimeString("hh:mm")
                }
            }
        }
        else{
            startDatePrefix.text = qsTr("Pick Date ")
            startDate.text = ""
            startTime.text = ""
            endDatePrefix.text = ""
            endDate.text = ""
            endTime.text = ""
            startDatePrefix.color = "grey"
            deleteDueDate.enabled = false
        }

        if(currentToDo.remindID !== 0){
            deleteReminder.enabled = true
            reminderText.color = "black"
            if(currentToDo.type === "Event")
                reminderText.text = qsTr("Reminder: ") + currentToDo.remindTime + " " + remindListModel.get(currentToDo.remindID).name +qsTr(" bevore")
            else
                reminderText.text = qsTr("Reminder: ") + currentToDo.remindTime + " " + remindListModel.get(currentToDo.remindID).name +qsTr(" at ") + currentToDo.remindDate.toLocaleTimeString("hh:mm")
        }
        else{
            deleteReminder.enabled = false
            reminderText.color = "grey"
            reminderText.text = qsTr("No reminder")
        }

        if(currentToDo.repeatID !== 0){
            deletRepeat.enabled = true
            repeatText.color = "black"
            repeatText.text = qsTr("Repeat every ") + currentToDo.repeatTime + " " + repeatListModel.get(currentToDo.repeatID).name
        }
        else{
            deletRepeat.enabled = false
            repeatText.color = "grey"
            repeatText.text = qsTr("Don't repeat")
        }
    }

    Component{
        id: pickTimeView
        PickTimeView{
            currentToDo: editToDoView.currentToDo
            onUpdateValues: updateUI()
        }
    }

    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 5

        Component.onCompleted: updateUI()


        GridLayout{
            columns: 2

            rowSpacing: 10

            MouseArea{
                Layout.fillWidth: true
                height: childrenRect.height

                onClicked: stackView.push(pickTimeView)

                GridLayout{
                    columns: 4
                    Text{ id: startDatePrefix; text: qsTr("From ") }
                    Text{ id: startDate }
                    Text{ text: " " }
                    Text{ id: startTime }

                    Text{ id: endDatePrefix; text: qsTr("to ") }
                    Text{ id: endDate }
                    Text{ text: " " }
                    Text{ id: endTime }
                }
            }
            Button{
                id: deleteDueDate
                text: "x"
                onClicked: {
                    currentToDo.startDateEnabled = false
                    currentToDo.repeatID = 0
                    currentToDo.remindID = 0
                    updateUI()
                }
            }

            Text{ //TODO: activate/enable when ready
                id: repeatText
                Layout.fillWidth: true
                MouseArea{
                    anchors.fill: parent
                    onClicked: stackView.push(pickTimeView)
                }
            }
            Button{
                id: deletRepeat
                text: "x"
                onClicked: {
                    currentToDo.repeatID = 0
                    updateUI()
                }
            }

            Text{ //TODO: activate/show when ready
                id: reminderText
                Layout.fillWidth: true
                text: qsTr("Repeat: ")
                MouseArea{
                    anchors.fill: parent
                    onClicked: stackView.push(pickTimeView)
                }
            }
            Button{
                id: deleteReminder
                text: "x"
                onClicked: {
                    currentToDo.remindID = 0
                    updateUI()
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

    header: ViewHeadder{

    }


}//Page
