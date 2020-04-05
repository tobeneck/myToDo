import QtQuick 2.14
import QtQuick.Controls 2.14
import Backend 1.0
import QtQuick.Layouts 1.14 //for RowLayout


import "../MyComponents"
import "../Views"


ApplicationWindow {
    id: window
    visible: true
    width: 480
    height: 640
    title: qsTr("Stack")

    //definitions -------------------------------------------------------------------------------------------------------------
//    Backend{
//        id: backend
//    }

    property var currentView: "todoListView"
    property var currentListIndex


    Component{
        id: toDoListView
        ToDoListView{
            todoListModel: todoLists.get(currentListIndex).attributes
            title: todoLists.get(currentListIndex).name
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
    StackView {
        id: stackView
        initialItem: pickToDoListView
        anchors.fill: parent
    }

//    Component.onCompleted: {
//        for(var i = 0; i < categorys.rowCount(); i++){ //<-- this is how to iterate over toDos
//            print(categorys.get(i).text)
//            for(var j = 0; j < categorys.get(i).attributes.count; j++)
//                print(categorys.get(i).attributes.get(j).description)
//        }
//    }
}
