import QtQuick 2.14
import QtQuick.Controls 2.14
import Backend 1.0


ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("Stack")

    //definitions -------------------------------------------------------------------------------------------------------------
    Backend{
        id: backend
    }



    Component{
        id: toDoListView
        ToDoListView{
            todoListModel: todos
            categoryListModel: categorys
        }
    }

    Component{
        id: categoryView
        CategoryView{
            todoListModel: todos
            categoryListModel: categorys
        }
    }

    Component{
        id: calendarView
        CalendarView{
            todoListModel: todos
            categoryListModel: categorys
        }
    }

    Component{
        id: emptyInitial
        Page{
            title: "If you read this, than its a bugg"
        }
    }

    //the definition stuff for the todos ---------------------------------------------------------------------------------------
    ListModel{
        id: todos
    }
    ListModel {
        id: categorys
        ListElement { text: "Banana"; color: "Yellow" }
        ListElement { text: "Apple"; color: "Green" }
        ListElement { text: "Coconut"; color: "Brown" }
    }


    //the interaction stuff ----------------------------------------------------------------------------------------------------

    header: ToolBar {
        contentHeight: toolButton.implicitHeight

        ToolButton {
            id: toolButton
            text: stackView.depth > 2 ? "\u25C0" : "\u2630"
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            onClicked: {
                if (stackView.depth > 2) {
                    stackView.pop()
                } else {
                    drawer.open()
                }
            }
        }

        Label {
            text: stackView.currentItem.title
            anchors.centerIn: parent
        }

        ToolButton {
            id: todoViewButton
            anchors.right: categoryViewButton.left
            text: "ToDo"
            visible: stackView.depth <= 2
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            onClicked: {
                stackView.pop(null)
                stackView.push(toDoListView)
                print(stackView.depth)
            }
        }

        ToolButton {
            id: categoryViewButton
            anchors.right: calendarViewButton.left
            text: "Cat"
            visible: stackView.depth <= 2
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            onClicked: {
                stackView.pop(null)
                stackView.push(categoryView)
                print(stackView.depth)
            }
        }

        ToolButton {
            id: calendarViewButton
            anchors.right: parent.right
            text: "Cal"
            visible: stackView.depth <= 2
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            onClicked: {
                stackView.pop()
                stackView.push(calendarView)
                print(stackView.depth)
            }
        }
    }

    Drawer {
        id: drawer
        width: window.width * 0.66
        height: window.height

        Column {
            anchors.fill: parent

            ItemDelegate {
                text: qsTr("ToDoList 1")
                width: parent.width
                onClicked: {
                    stackView.pop(null)
                    stackView.push(toDoListView)
                    drawer.close()
                }
            }
            //TODO: make a ListView for all ToDoLists
        }
    }

    StackView {
        id: stackView
        initialItem: emptyInitial
        anchors.fill: parent
    }

    Component.onCompleted: stackView.push(toDoListView)
}
