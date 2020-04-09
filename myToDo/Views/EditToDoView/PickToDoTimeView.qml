import QtQuick 2.0
import QtQuick.Layouts 1.14 //for the Column-, Row- and GridLayout
import QtQuick.Controls 1.4 as Controls14 //for the Calendar
import QtQuick.Controls 2.14 //for the Popup

import "../../MyComponents"
import "Components" //for my componenets, duh


Page {
    id: pickDateAndTime

    signal updateValues()

    property var savedStartDate //just to save the current hour and minutes values

    function getStartDate(){
        var currentStartDate = startDatePicker.selectedDate
//        currentStartDate = new Date(currentStartDate.setHours(savedStartDate.getHours())) //TODO: delete or what?
//        currentStartDate = new Date(currentStartDate.setMinutes(SavedStartDate.getMinutes()))
//        currentStartDate = new Date(currentStartDate.setSeconds(0))
//        currentStartDate = new Date(currentStartDate.setMilliseconds(0))

        return currentStartDate
    }
    function setStartDate(startDate){ startDatePicker.selectedDate = startDate }

    function getRepeatID(){ return repeatComboBox.currentIndex }
    function setRepeatID(repeatID){ repeatComboBox.currentIndex = repeatID }

    function getRepeatTime(){ return repeatSpinBox.value }
    function setRepeatTime(repeatTime){ repeatSpinBox.value = repeatTime }

    function getRemindID(){ return reminderComboBox.currentIndex }
    function setRemindID(remindID){ reminderComboBox.currentIndex = remindID }

    function getRemindTime(){ return reminderSpinBox.value }
    function setRemindTime(remindTime){ reminderSpinBox.value = remindTime }

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
                text: qsTr("Due Date:")
            }

            Controls14.Calendar { //TODO: kame shure start date and end date are always right
                id: startDatePicker
                Layout.fillWidth: true
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


            //reminder
            Text{
                text: qsTr("Reminder: ")
            }
            RowLayout{
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
            }
            TimeTextInput{
                prefix: ""
                isEnabled: reminderComboBox.currentIndex !== 0

            }//reminder

        }//ColumnLayout
    }//ScrollView

}//Page
