import QtQuick 2.14
import QtQuick.Controls 2.14
import Backend 1.0
import QtQuick.Layouts 1.14 //for RowLayout


ApplicationWindow {
    id: window
    visible: true
    width: 480
    height: 640
    title: qsTr("Stack")

    //definitions -------------------------------------------------------------------------------------------------------------
    Backend{
        id: backend
    }

    property var currentView: "todoListView"
    property var currentListIndex


    Component{
        id: toDoListView
        ToDoListView{
            todoListModel: todoLists.get(currentListIndex).attributes
            title: todoLists.get(currentListIndex).name
            categoryListModel: categorys
            currentIndex: currentListIndex
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
        id: pickToDoListView
        PickToDoListView{
            todoListsModel: todoLists

            onOpenList: { //open the new screen
                var name = todoListsModel.get(index).name
                var type = todoListsModel.get(index).type

                if(type === "list"){
                    currentListIndex = index
                    if(currentView == "todoListView")
                        stackView.push(toDoListView)
                    if(currentView == "categoryView")
                        stackView.push(categoryView)
                    if(currentView == "calendarView")
                        stackView.push(calendarView)
                }
                else if(type === "group"){
                    print("TODO: implement")
                }
            }
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
        ListElement {
            text: "Apple"
            cost: 2.45
            attributes: [
                ListElement { description: "Core" },
                ListElement { description: "Deciduous" }
            ]
        }
        ListElement {
            text: "Orange"
            cost: 3.25
            attributes: [
                ListElement { description: "Citrus" }
            ]
        }
        ListElement {
            text: "Banana"
            cost: 1.95
            attributes: [
                ListElement { description: "Tropical" },
                ListElement { description: "Seedless" }
            ]
        }
    }
    ListModel{
        id: todoLists
    }


    //the interaction stuff ----------------------------------------------------------------------------------------------------

    header: ToolBar {
        contentHeight: toolButton.implicitHeight

        ToolButton {
            id: toolButton
            text: stackView.depth > 1 ? "\u25C0" : "\u2630"
            font.pixelSize: Qt.application.font.pixelSize * 1.6
            onClicked: {
                if (stackView.depth > 1) {
                    stackView.pop()
                } else {
                    //drawer.open()
                    print("TODO: implement")
                }
            }
        }

        Label {
            text: stackView.currentItem.title
            anchors.centerIn: parent
        }




    }

    StackView {
        id: stackView
        initialItem: pickToDoListView
        anchors.fill: parent
    }

    footer: ToolBar {
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

//    Component.onCompleted: {
//        for(var i = 0; i < categorys.rowCount(); i++){ //<-- this is how to iterate over toDos
//            print(categorys.get(i).text)
//            for(var j = 0; j < categorys.get(i).attributes.count; j++)
//                print(categorys.get(i).attributes.get(j).description)
//        }
//    }
}
