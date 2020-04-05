import QtQuick 2.0
import QtQuick.Layouts 1.14 //for the Column-, Row- and GridLayout
import QtQuick.Controls 1.4 //for the Calendar
import QtQuick.Controls 2.14 //for the Popup


Popup {
    id: popup
    x: parent.width/90
    y: parent.height/160
    width: parent.width - 2 * x
    height: parent.height - 2 * y
    modal: true
    focus: true

    signal updateValues(var date, int hours, int minutes)

    ColumnLayout{
        anchors.fill: parent

        Calendar {
            id: datePicker
            Layout.fillWidth: true
        }

        TimeTextInput{
            id: startTimeInput
        }

        TimeTextInput{
            id: stopTimeInput
        }

        RowLayout{
            Button{
                text: qsTr("Accept")
                onClicked: {
                    updateValues(datePicker.selectedDate, startTimeInput.hoursValue, startTimeInput.minutesValue)

                    popup.close()
                }
            }
            Button{
                text: qsTr("Cancel")
                onClicked: popup.close()
            }
        }
    }//ColumnLayout

    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
}//Popup
