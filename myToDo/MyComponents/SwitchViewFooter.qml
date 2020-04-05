import QtQuick 2.0
import QtQuick.Controls 2.14//ToolBar, RadioButton
import QtQuick.Layouts 1.14 //RowLayout

ToolBar {
    anchors.left: parent.left
    anchors.right: parent.right
    RowLayout{
        anchors.fill: parent
        RadioButton {
            id: todoViewButton
            checked: true //TODO: change
            text: "ToDo"
            //visible: stackView.depth > 1
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            //property bool isCurrent: true
            onClicked: {
                currentView = "toDoListView"
                if(stackView.depth > 1){
                    stackView.pop()
                    stackView.push(toDoListView)
                }
            }
        }

        RadioButton {
            id: categoryViewButton
            text: "Cat"
            //visible: stackView.depth > 1
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            //property bool isCurrent: false
            onClicked: {
                currentView = "categoryView"
                if(stackView.depth > 1){
                    stackView.pop()
                    stackView.push(categoryView)
                }
            }
            property var isCurrent: true
        }

        RadioButton {
            id: calendarViewButton
            text: "Cal"
            //visible: stackView.depth > 1
            font.pixelSize: Qt.application.font.pixelSize * 1.6

            //property bool isCurrent: false
            onClicked: {
                currentView = "calendarView"
                if(stackView.depth > 1){
                    stackView.pop()
                    stackView.push(calendarView)
                }
            }
        }
    }
}
