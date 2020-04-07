import QtQuick 2.14
import QtQuick.Controls 1.4
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

import "../MyComponents"

Page {
    title: todoListModel.get(currentIndex).title

    property var currentToDo

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

//            startTimeText.text = currentToDo.startTime === 0 ? qsTr("No starting time") : qsTr("Starting Time: ") + currentToDo.startTime
//            startTimeText.color = currentToDo.startTime === 0 ? "grey" : "black"

//            durationText.text = currentToDo.duration === 0 ? qsTr("No duration") : qsTr("Duration: ") + currentToDo.duration
//            durationText.color = currentToDo.duration === 0 ? "grey" : "black"

//            reminderText.text = currentToDo.reminder === 0 ? qsTr("Don't remind me") : qsTr("Remind me ") + currentToDo.reminder + "bevore" //TODO: change
//            reminderText.color = currentToDo.reminder === 0 ? "grey" : "black"

//            repeatText.text = currentToDo.repeatID === -1 ? qsTr("Don't repeat") : qsTr("Repeat every ") + currentToDo.repeatTime + " " + repeatListModel.get(currentToDo.repeatID).name
//            repeatText.color = currentToDo.repeatID === -1 ? "grey" : "black"
    }

    Component{
        id: pickDateAndTimeView
        PickDateAndTimeView{
            type: currentToDo.type
            allDay: currentToDo.allDay
            Component.onCompleted: {
                //set this values here to avoid bindings
                setStartDate(currentToDo.startDate)
                setEndDate(currentToDo.endDate)
                currentStartEndTimeDiff = getStartEndTimeDiff()
            }

            onUpdateValues: {
                currentToDo.startDate = getStartDate() //TODO: just save everythink in a date
                currentToDo.endDate = getEndDate()
                currentToDo.allDay = allDay
                currentToDo.type = type
                currentToDo.startDateEnabled = true
                //TODO: set the changedTate and changedTime here
                currentToDo.changedNumber = currentToDo.changedNumber + 1
                updateUI()
            }
        }
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

            MouseArea{
                id: openPickTimeAndDateView

                function resize(){
                    width =  childrenRect.width
                    height = childrenRect.height
                }

                Layout.fillWidth: true
                height: childrenRect.height

                onClicked: stackView.push(pickDateAndTimeView)

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
                    root.updateUI()
                }
            }

            Text{ //TODO: activate/show when ready
                id: reminderText
                Layout.fillWidth: true
                MouseArea{
                    anchors.fill: parent
                    //onClicked:
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
                    //onClicked:
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

    header: ViewHeadder{

    }


}//Page
