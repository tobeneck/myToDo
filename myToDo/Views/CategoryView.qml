import QtQuick 2.13
import QtQuick.Controls 2.13

import "../MyComponents"

Page {
    title: qsTr("Category View")

    property var todoListModel
    property var categoryListModel

    Text{
        text: "Category View Screen"
    }

    header: ViewHeadder{

    }

    footer: SwitchViewFooter{

    }
}
