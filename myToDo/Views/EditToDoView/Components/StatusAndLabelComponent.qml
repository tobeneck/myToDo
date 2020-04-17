import QtQuick 2.0
import QtQuick.Layouts 1.13 //for the rowLayout
import QtQuick.Controls 2.13 //for the comboBox

Rectangle{
    border.width: 2
    border.color: "grey"
    radius: 3

    property var statusList
    property var statusID

    signal currentStatusChanged(var status)

    GridLayout{
        columns: 3
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 5

        //Categorys
            Text{
                Layout.topMargin: 5
                text: qsTr("Status: ")
            }

            ComboBox {
                Layout.fillWidth: true
                Layout.topMargin: 5

                id: statusBox
                editable: true
                model: statusList

                currentIndex: statusID

                textRole: "name"

                onCurrentIndexChanged: currentStatusChanged(currentIndex)
                onAccepted: {
                    if (find(currentText) === -1) {
                        categorys.append({text: editText})
                        currentIndex = find(editText)
                    }
                }
            }
            Button{
                text: qsTr("Edit Status")
                Layout.topMargin: 5
                onClicked: print("ToDo: add edit status")
            }

        //Status
            Text{
                Layout.bottomMargin: 5
                text: qsTr("Categorys: ")
            }

            ComboBox {
                Layout.fillWidth: true
                Layout.bottomMargin: 5
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
                Layout.bottomMargin: 5
                onClicked: print("ToDo: add edit categorys")
            }
    }

}
