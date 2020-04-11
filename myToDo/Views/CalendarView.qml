import QtQuick 2.13
import QtQuick.Controls 2.13

import "../MyComponents"

Page {
    title: qsTr("Calendar")

    property var todoListModel
    property var categoryListModel

    Text{
        text: "CalendarViewScreen"
    }

    header: ViewHeadder{

    }

    footer: SwitchViewFooter{

    }
}
