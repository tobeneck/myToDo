import QtQuick 2.14
import QtQuick.Controls 2.14

import "../MyComponents"

Page {
    title: qsTr("Calendar")

    property var todoListModel
    property var categoryListModel

    Text{
        text: "CalendarViewScreen"
    }
}
