import QtQuick 2.0
import QtQuick.Layouts 1.13 //for the Column-, Row- and GridLayout
import QtQuick.Controls 1.4 as Controls14 //for the Calendar
import QtQuick.Controls 2.13 //for the Popup

import "../../MyComponents"
import "Components" //for my componenets, duh


Page {
    id: pickDateAndTime

    signal updateValues()

    property var allDay

    property var currentStartEndTimeDiff

    function getStartDate(){
        var currentStartDate = startDatePicker.selectedDate
        currentStartDate = new Date(currentStartDate.setHours(startTimeInput.getHours()))
        currentStartDate = new Date(currentStartDate.setMinutes(startTimeInput.getMinutes()))
        currentStartDate = new Date(currentStartDate.setSeconds(0))
        currentStartDate = new Date(currentStartDate.setMilliseconds(0))

        return currentStartDate
    }
    function setStartDate(startDate){
        startTimeInput.setHours(startDate.getHours())
        startTimeInput.setMinutes(startDate.getMinutes())
        startDatePicker.selectedDate = startDate
    }

    function getEndDate(){
        var currentEndDate = endDatePicker.selectedDate
        currentEndDate = new Date(currentEndDate.setHours(endTimeInput.getHours()))
        currentEndDate = new Date(currentEndDate.setMinutes(endTimeInput.getMinutes()))
        currentEndDate = new Date(currentEndDate.setSeconds(0))
        currentEndDate = new Date(currentEndDate.setMilliseconds(0))

        return currentEndDate
    }
    function setEndDate(endDate){ //date input
        endTimeInput.setHours(endDate.getHours())
        endTimeInput.setMinutes(endDate.getMinutes())
        endDatePicker.selectedDate = endDate
    }

    function getRepeatID(){ return repeatComboBox.currentIndex }
    function setRepeatID(repeatID){ repeatComboBox.currentIndex = repeatID }

    function getRepeatTime(){ return repeatSpinBox.value }
    function setRepeatTime(repeatTime){ repeatSpinBox.value = repeatTime }

    function getRemindID(){ return reminderComboBox.currentIndex }
    function setRemindID(remindID){ reminderComboBox.currentIndex = remindID }

    function getRemindTime(){ return reminderSpinBox.value }
    function setRemindTime(remindTime){ reminderSpinBox.value = remindTime }

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
                text: qsTr("Start Date:")
            }

            Controls14.Calendar { //TODO: kame shure start date and end date are always right
                id: startDatePicker
                Layout.fillWidth: true
                onClicked: updateStartDate()
            }

            Text{
                text: qsTr("Start Time: ")
            }
            RowLayout{
                TimeTextInput{
                    id: startTimeInput
                    isEnabled: allDay1.checked === false
                    prefix: qsTr("")

                    onTimeManuallyChanged: updateStartDate()
                }

                Switch{
                    id: allDay1
                    position: allDay ? 1.0 : 0.0
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
                }
            }

            Text{
                text: qsTr("End Date:")
            }

            Controls14.Calendar {
                id: endDatePicker
                Layout.fillWidth: true
                minimumDate: startDatePicker.selectedDate
                onClicked: updateEndDate()
            }

            Text{
                text: qsTr("End Time: ")
            }

            RowLayout{
                TimeTextInput{
                    id: endTimeInput
                    isEnabled: allDay === false
                    prefix: qsTr("")

                    onTimeManuallyChanged: updateEndDate()
                }

                Switch{
                    id: allDay2
                    position: allDay ? 1.0 : 0.0

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
                }
            }

            Text{
                text: qsTr("Repeat: ")
            }
            RowLayout{ //repeat
                SpinBox {
                    id: repeatSpinBox
                    value: 1
                    from: 1
                    editable: true
                    enabled: repeatComboBox.currentIndex !== 0
                    onValueChanged: {
                        if(value === 0)
                            value = 1
                    }
                }
                ComboBox{
                    id: repeatComboBox
                    model: repeatListModel
                    textRole: "name"
                    editText: textRole
                }
            }//repeat

            Text{
                text: qsTr("Reminder: ")
            }
            RowLayout{ //reminder
                SpinBox {
                    id: reminderSpinBox
                    value: 15
                    from: 1
                    editable: true
                    enabled: reminderComboBox.currentIndex !== 0
                    onValueChanged: {
                        if(value === 0)
                            value = 1
                    }
                }
                ComboBox{
                    id: reminderComboBox
                    model: remindListModel
                    textRole: "name"
                    editText: textRole
                }
            }//reminder

        }//ColumnLayout
    }//ScrollView

}//Page
