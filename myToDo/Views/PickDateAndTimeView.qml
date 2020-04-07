import QtQuick 2.0
import QtQuick.Layouts 1.14 //for the Column-, Row- and GridLayout
import QtQuick.Controls 1.4 as Controls14 //for the Calendar
import QtQuick.Controls 2.14 //for the Popup

import "../MyComponents" //for my componenets, duh


Page {
    id: pickDateAndTime

    signal updateValues()

    property var allDay

    property var currentStartEndTimeDiff

    property var type

    function getStartDate(){
        var currentStartDate = startDatePicker.selectedDate
        currentStartDate = new Date(currentStartDate.setHours(startTimeInput.getHours()))
        currentStartDate = new Date(currentStartDate.setMinutes(startTimeInput.getMinutes()))
        currentStartDate = new Date(currentStartDate.setSeconds(0))
        currentStartDate = new Date(currentStartDate.setMilliseconds(0))

        return currentStartDate
    }

    function getEndDate(){
        var currentEndDate = endDatePicker.selectedDate
        currentEndDate = new Date(currentEndDate.setHours(endTimeInput.getHours()))
        currentEndDate = new Date(currentEndDate.setMinutes(endTimeInput.getMinutes()))
        currentEndDate = new Date(currentEndDate.setSeconds(0))
        currentEndDate = new Date(currentEndDate.setMilliseconds(0))

        return currentEndDate
    }

    function setStartDate(startDate){ //date input
        startTimeInput.setValues(startDate.getHours(), startDate.getMinutes())
        startDatePicker.selectedDate = startDate
    }

    function setEndDate(endDate){ //date input
        endTimeInput.setValues(endDate.getHours(), endDate.getMinutes())
        endDatePicker.selectedDate = endDate
    }

    function getStartEndTimeDiff(){
        var currentStartDate = getStartDate()
        var currentEndDate = getEndDate()

        return currentStartDate.getTime() - currentEndDate.getTime()
    }

    function updateStartDate(){
        //get the current start date
        var currentStartDate = getStartDate()

        //get the right end date
        var currentEndDate = new Date(currentStartDate.getTime() - currentStartEndTimeDiff)

        //update the endDate values
        setEndDate(currentEndDate)

        //re-set the currentStartEndTimeDiff
        currentStartEndTimeDiff = getStartEndTimeDiff()
    }

    function updateEndDate(){

        if(getStartEndTimeDiff() >= 0){
            var currentEndDate = getEndDate(9)

            var minInMs = 60000
            var currentStartDate = new Date(currentEndDate.getTime() - 5 * minInMs)
            //update the startDate
            setStartDate(currentStartDate)
        }

        //re-set the currentStartEndTimeDiff
        currentStartEndTimeDiff = getStartEndTimeDiff()
    }

    ScrollView {
        contentWidth: -1


        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40 //= 2* margins of the columnLayout
        anchors.top: parent.top


        ColumnLayout{
            anchors.fill: parent
            anchors.margins: 20
            spacing: 10

            Text{
                text: type === "ToDo" ? qsTr("Due Date:") : qsTr("Start Date:")
            }

            Controls14.Calendar { //TODO: kame shure start date and end date are always right
                id: startDatePicker
                Layout.fillWidth: true
                onClicked: updateStartDate()
            }

            Text{
                text: qsTr("Start Time: ")
                color: type === "Event" ? "black" : "grey"
            }
            RowLayout{
                TimeTextInput{
                    id: startTimeInput
                    isEnabled: type === "Event" && allDay1.checked === false //not !allDay
                    prefix: qsTr("")

                    onTimeManuallyChanged: updateStartDate()
                }

                Switch{
                    id: allDay1
                    position: allDay ? 1.0 : 0.0
                    enabled: type === "Event"
                    onClicked: {
                        if(position == 1.0){
                            allDay = true
                            allDay2.checked = true
                        }
                        else{
                            allDay = false
                            allDay2.checked = false
                        }
                    }
                }
                Text{
                    text: qsTr("All day")
                    color: type === "Event" ? "black" : "grey"
                }
            }

            Text{
                text: qsTr("End Date:")
                color: type === "Event" ? "black" : "grey"
            }

            Controls14.Calendar {
                id: endDatePicker
                Layout.fillWidth: true
                enabled: type === "Event"
                minimumDate: startDatePicker.selectedDate
                onClicked: updateEndDate()
            }

            Text{
                text: qsTr("End Time: ")
                color: type === "Event" ? "black" : "grey"
            }

            RowLayout{
                TimeTextInput{
                    id: endTimeInput
                    isEnabled: type === "Event" && allDay === false //not !allDay
                    prefix: qsTr("")

                    onTimeManuallyChanged: updateEndDate()
                }

                Switch{
                    id: allDay2
                    position: allDay ? 1.0 : 0.0
                    enabled: type === "Event"

                    onClicked: {
                        if(position == 1.0){
                            allDay = true
                            allDay1.checked = true
                        }
                        else{
                            allDay = false
                            allDay1.checked = false
                        }
                    }
                }
                Text{
                    text: qsTr("All day")
                    color: type === "Event" ? "black" : "grey"
                }
            }

        }//ColumnLayout
    }//ScrollView


    header: ToolBar{
        RowLayout{
            anchors.fill: parent
            ToolButton{
                text: qsTr("Accept")
                onClicked: {
                    updateValues()
                    stackView.pop()
                }
            }

            RowLayout{
                Text{
                    text: qsTr("ToDo")
                    color: type !== "ToDo" ? "grey" : "black"
                }
                Switch {
                    id: toDoEventSwitch
                    onPositionChanged: position === 0.0 ? pickDateAndTime.type = "ToDo" : pickDateAndTime.type = "Event"
                    Component.onCompleted: position = pickDateAndTime.type === "ToDo" ? 0.0 : 1.0
                }
                Text{
                    text: qsTr("Event")
                    color: type !== "Event" ? "grey" : "black"
                }
            }

            ToolButton{
                text: qsTr("Cancel")
                onClicked: stackView.pop()
            }
        }
    }

}//Page
