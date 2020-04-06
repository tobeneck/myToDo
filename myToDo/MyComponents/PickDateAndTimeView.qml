import QtQuick 2.0
import QtQuick.Layouts 1.14 //for the Column-, Row- and GridLayout
import QtQuick.Controls 1.4 as Controls14 //for the Calendar
import QtQuick.Controls 2.14 //for the Popup


Page {
    id: pickDateAndTime

    signal updateValues()

    property var startDate
    property var endDate

    property bool allDay

    property var currentStartEndTimeDiff: startDate.getTime() - endDate.getTime()

    property var type

    function updateStartDate(){
        startDate = new Date(new Date(startDatePicker.selectedDate.setHours(startTimeInput.hoursValue)).setMinutes(startTimeInput.minutesValue))
        endDate = new Date(startDate - currentStartEndTimeDiff)
        endTimeInput.hoursValue = endDate.getHours()
        endTimeInput.minutesValue = endDate.getMinutes()
        endDatePicker.selectedDate = endDate

        currentStartEndTimeDiff = startDate.getTime() - endDate.getTime()

    }

    function updateEndDate(){
        endDate = endDatePicker.selectedDate
        currentStartEndTimeDiff = endDate.getTime() - startDate.getTime()
        print(currentStartEndTimeDiff)
        var minInMs = 60000
        if(currentStartEndTimeDiff < 5*minInMs){

            startDate = new Date(endDate.getTime() - minInMs * 5)//5 min down delay
            startTimeInput.hoursValue = startDate.getHours()
            startTimeInput.minutesValue = startDate.getMinutes()
            startDatePicker.selectedDate = startDate

            currentStartEndTimeDiff = startDate.getTime() - endDate.getTime()
            currentStartEndTimeDiff = endDate.getTime() - startDate.getTime()
        }

    }

    Component.onCompleted: {
        //set this values here to avoid bindings
        startDatePicker.selectedDate = startDate
        startTimeInput.hoursValue = startDate.getHours()
        startTimeInput.minutesValue = startDate.getMinutes()
        endDatePicker.selectedDate = endDate
        endTimeInput.hoursValue = endDate.getHours()
        endTimeInput.minutesValue = endDate.getMinutes()
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
                onSelectedDateChanged: updateStartDate()
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
                onSelectedDateChanged: updateEndDate()
            }

            RowLayout{
                Text{
                    text: qsTr("All day")
                    color: type === "Event" ? "black" : "grey"
                }
                Switch{
                    position: allDay ? 1.0 : 0.0
                    enabled: type === "Event"
                    onPositionChanged: {
                        if(position == 1.0)
                            allDay == true
                        else
                            allDay == false
                    }
                }
            }

            TimeTextInput{
                id: startTimeInput
                isEnabled: type === "Event" && !allDay
                prefix: qsTr("Pick start time: ")

                onUpdateStartTime: updateStartDate()
            }

            TimeTextInput{
                id: endTimeInput
                isEnabled: type === "Event" && !allDay
                prefix: qsTr("Pick end time: ")

                onUpdateStartTime: updateStartDate()
            }
        }//ColumnLayout
    }//ScrollView


    header: ToolBar{
        RowLayout{
            anchors.fill: parent
            ToolButton{
                text: qsTr("Accept")
                onClicked: {
                    startDate = new Date(new Date(startDatePicker.selectedDate.setHours(startTimeInput.hoursValue)).setMinutes(startTimeInput.minutesValue))
                    endDate = new Date(new Date(endDatePicker.selectedDate.setHours(endTimeInput.hoursValue)).setMinutes(endTimeInput.minutesValue))
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
