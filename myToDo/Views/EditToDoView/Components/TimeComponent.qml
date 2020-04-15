import QtQuick 2.0
import QtQuick.Layouts 1.13 //GridLayout
import QtQuick.Controls 2.4

Rectangle{
    border.width: 2
    border.color: "grey"
    radius: 3

    function updateValues(currentToDo){
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


    GridLayout{
        columns: 2
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 5

        rowSpacing: 5

        MouseArea{
            Layout.fillWidth: true
            height: childrenRect.height

            Layout.topMargin: 5

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

            Layout.topMargin: 5

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

            Layout.bottomMargin: 5

            Layout.fillWidth: true
            text: qsTr("Repeat: ")
            MouseArea{
                anchors.fill: parent
                onClicked: stackView.push(pickTimeView)
            }
        }
        Button{
            id: deleteReminder

            Layout.bottomMargin: 5

            text: "x"
            onClicked: {
                currentToDo.remindID = 0
                updateUI()
            }
        }
    } //GridLayout
}
