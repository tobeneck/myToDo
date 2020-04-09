import QtQuick 2.0
import QtQuick.Layouts 1.14 //for the Column-, Row- and GridLayout
import QtQuick.Controls 1.4 as Controls14 //for the Calendar
import QtQuick.Controls 2.14 //for the Popup

import "../../MyComponents"
import "Components"

Page {
    id: pickTimeView
    property var currentToDo

    function setRemindDate(remindID, remindTime){
        var newReminderTime = currentToDo.startDate
        var minToMs = 60000;
        var multiplicator = 1
        switch(remindID){
        case 1: newReminderTime = new Date (newReminderTime.setMinutes(newReminderTime.getMinutes() - remindTime))
            break;
        case 2: newReminderTime = new Date(newReminderTime.setHours(newReminderTime.getHours() - remindTime))
            break;
        case 3: newReminderTime = new Date(newReminderTime.setDate(newReminderTime.getDate() - remindTime))
            break;
        case 4: newReminderTime = new Date(newReminderTime.setDate(newReminderTime.getDate() - remindTime * 7))
            break;
        case 5: newReminderTime = new Date(newReminderTime.setMonth(newReminderTime.getMonth() - remindTime)) //one month prior means 30 days
            break;
        case 6:newReminderTime = new Date(newReminderTime.setMonth(newReminderTime.getMonth() - remindTime * 12))
            break;
        }
        print(newReminderTime.toLocaleDateString(Qt.locale("de_DE")))
        currentToDo.remindDate = newReminderTime
    }

    signal updateValues()

    Component{
        id: pickToDoTimeView
        PickToDoTimeView{
            Component.onCompleted: {
                //set this values here to avoid bindings
                setStartDate(currentToDo.startDate)
                setRepeatID(currentToDo.repeatID)
                setRepeatTime(currentToDo.repeatTime)
                setRemindID(currentToDo.remindID)
                setRemindTime(currentToDo.remindTime)
            }

            onUpdateValues: {
                currentToDo.startDate = getStartDate() //TODO: just save everythink in a date
                currentToDo.startDateEnabled = true
                currentToDo.repeatID = getRepeatID()
                currentToDo.repeatTime = getRepeatTime()
                currentToDo.remindID = getRemindID()
                currentToDo.remindTime = getRemindTime()
                setRemindDate(getRemindID(), getRemindTime())

                currentToDo.changedNumber = currentToDo.changedNumber + 1
                currentToDo.changedDate = new Date()
                pickTimeView.updateValues()
            }
        }
    }

    Component{
        id: pickEventTimeView
        PickEventTimeView{
            allDay: currentToDo.allDay
            Component.onCompleted: {
                //set this values here to avoid bindings

                setStartDate(currentToDo.startDate)
                setEndDate(currentToDo.endDate)
                currentStartEndTimeDiff = getStartEndTimeDiff()
                setRepeatID(currentToDo.repeatID)
                setRepeatTime(currentToDo.repeatTime)
                setRemindID(currentToDo.remindID)
                setRemindTime(currentToDo.remindTime)
            }

            onUpdateValues: {
                currentToDo.startDate = getStartDate() //TODO: just save everythink in a date
                currentToDo.endDate = getEndDate()
                currentToDo.allDay = allDay
                currentToDo.startDateEnabled = true
                currentToDo.repeatID = getRepeatID()
                currentToDo.repeatTime = getRepeatTime()
                currentToDo.remindID = getRemindID()
                currentToDo.remindTime = getRemindTime()
                setRemindDate(getRemindID(), getRemindTime())

                currentToDo.changedDate = new Date() //TODO: maybe set this at a more central place?
                currentToDo.changedNumber = currentToDo.changedNumber + 1
                pickTimeView.updateValues()
            }
        }
    }

    StackView{
        id: pickTimeStackView
        anchors.fill: parent
        initialItem: currentToDo.type === "ToDo" ? pickToDoTimeView : pickEventTimeView
    }


    header: ToolBar{
        RowLayout{
            anchors.fill: parent
            ToolButton{
                text: qsTr("Accept")
                onClicked: {
                    pickTimeStackView.currentItem.updateValues()
                    stackView.pop()
                }
            }

            RowLayout{
                Text{
                    id: toDoText
                    text: qsTr("ToDo")
                    color: currentToDo.type === "ToDo" ? "black" : "grey"
                }
                Switch {
                    id: toDoEventSwitch
                    onCheckedChanged: {
                        if(!checked){
                            currentToDo.type = "ToDo"
                            pickTimeStackView.pop()
                            pickTimeStackView.push(pickToDoTimeView)
                            toDoText.color = "black"
                            eventText.color = "grey"
                        }
                        else{
                            currentToDo.type = "Event"
                            pickTimeStackView.pop()
                            pickTimeStackView.push(pickEventTimeView)
                            toDoText.color = "grey"
                            eventText.color = "black"
                        }
                    }
                    Component.onCompleted: checked = currentToDo.type === "ToDo" ? false : true
                }
                Text{
                    id: eventText
                    text: qsTr("Event")
                    color: currentToDo.type === "Event" ? "black" : "grey"
                }
            }

            ToolButton{
                text: qsTr("Cancel")
                onClicked: stackView.pop()
            }
        }
    }

}
