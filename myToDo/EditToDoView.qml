import QtQuick 2.14
import QtQuick.Controls 1.4
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14


Page {
    title: todoListModel.get(currentIndex).title

    property var todoListModel
    property var currentToDoIndex

    ColumnLayout{
        anchors.fill: parent


        //DueDate
        Text{
            text: qsTr("Due Date: ")
            Layout.fillWidth: true
            MouseArea{
                anchors.fill: parent
                onClicked: pickDatePopup.open()
            }
            //TODO: setDueDate
        }

        //startingTime
        EditTime{
            name: qsTr("Start Time: ")
        }


        //ProcessingTime
        EditTime{
            name: qsTr("Duration: ")
        }

        //Reminder
        EditTime{
            name: qsTr("remind me: ")
            end: qsTr("bevore")
        }

        //repeat
        RowLayout{
            Text{
                text: "Repeat every "
            }
            TextField{
                validator: IntValidator {bottom: 1; top: 60}
                text: ""
            }

            Text{
                text: "days"
            }
        }

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
                if (find(currentText) === -1) {
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
                text: qsTr("Notes...")
            }
        }

        //TODO: comments

    }



    Popup {
        id: pickDatePopup
        x: parent.width/20
        y: parent.height/10
        width: parent.width - 2 * x
        height: parent.height - 2 * y
        modal: true
        focus: true

        Item{
            anchors.fill: parent
            Calendar {
                id: datePicker
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                //minimumDate: new Date(2017, 0, 1)
                //maximumDate: new Date(2018, 0, 1)
            }
            Button{
                text: qsTr("Accept")
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                onClicked: {
                    //TODO
                    pickDatePopup.close()
                }
            }
            Button{
                text: qsTr("Cancel")
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                onClicked: pickDatePopup.close()
            }
        }

        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    }

//    Popup {
//        id: pickTimePopup
//        x: parent.width/20
//        y: parent.height/10
//        width: parent.width - 2 * x
//        height: parent.height - 2 * y
//        modal: true
//        focus: true

//        Item{
//            anchors.fill: parent
//            TimePicker {
//                id: timePicker
//                anchors.top: parent.top
//                anchors.left: parent.left
//                anchors.right: parent.right
//                height: 500
//            }
//            Button{
//                text: qsTr("Accept")
//                anchors.left: parent.left
//                anchors.bottom: parent.bottom
//                onClicked: {
//                    //TODO
//                    pickTimePopup.close()
//                }
//            }
//            Button{
//                text: qsTr("Cancel")
//                anchors.right: parent.right
//                anchors.bottom: parent.bottom
//                onClicked: pickTimePopup.close()
//            }
//        }

//        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
//    }

}
