import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13

import "../../MyComponents"
import "Components"

Page {
    id: editToDoView
    title: todoListModel.get(currentIndex).title

    property var currentToDo
    property var statusListModel

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

        TimeComponent{
            id: timeComponent
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            height: childrenRect.height

        }

        StatusAndLabelComponent{
            id: statusAndLabelComponent
            anchors.topMargin: 5
            anchors.top: timeComponent.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            height: childrenRect.height

            statusList: statusListModel
            statusID: currentToDo.status

            onCurrentStatusChanged: currentToDo.status = status
        }

        SubToDosComponent{
            id: subToDosComponent

            onHeightChanged: timeComponent.height + subToDosComponent.height + notesComponent.height + 20 + statusAndLabelComponent.height

            anchors.topMargin: 5
            anchors.top: statusAndLabelComponent.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            subToDosModel: currentToDo.subToDos

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
