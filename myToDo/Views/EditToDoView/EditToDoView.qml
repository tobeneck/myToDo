import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13

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
        timeComponent.updateValues(currentToDo)

    }

    Component.onCompleted: updateUI()

    Component{
        id: pickTimeView
        PickTimeView{
            currentToDo: editToDoView.currentToDo
            onUpdateValues: updateUI()
        }
    }

    ScrollView{
        id: scrolView
        clip: true
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.rightMargin: 20
        anchors.topMargin: 10
//        anchors.bottomMargin: 10
        contentWidth: -1
        contentHeight: timeComponent.height + subToDosComponent.height + notesComponent.height + 15 //15=3*anchorMargins

//            //Categorys
//            RowLayout{
//                Layout.fillWidth: true
//                ComboBox {
//                    Layout.fillWidth: true
//                    id: categoryBox
//                    editable: true
//                    model: categorys

//                    textRole: "text"

//                    onAccepted: {
//                        if (find(currentText) === -1) {
//                            categorys.append({text: editText})
//                            currentIndex = find(editText)
//                        }
//                    }
//                }
//                Button{
//                    text: qsTr("Edit Categorys")
//                    onClicked: print("ToDo: add edit categorys")
//                }
//            }

//            //Status
//            ComboBox {
//                id: statusBox

//                textRole: "text"

//                editable: true
//                model: categorys
//                onAccepted: {
//                    if (find(currentText) === 0) {
//                        model.append({text: editText})
//                        currentIndex = find(editText)
//                    }
//                }
//            }

        TimeComponent{
            id: timeComponent
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

        }

        SubToDosComponent{
            id: subToDosComponent

            onHeightChanged: timeComponent.height + subToDosComponent.height + notesComponent.height + 15

            anchors.topMargin: 5
            anchors.top: timeComponent.bottom
            anchors.left: parent.left
            anchors.right: parent.right

        }


        //Notes
        NotesComponent{
            id: notesComponent
            anchors.topMargin: 5
            anchors.top: subToDosComponent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
        }

        //TODO: comments

    }


    header: ViewHeadder{

    }


}//Page
