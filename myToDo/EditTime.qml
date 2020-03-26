import QtQuick 2.0
import QtQuick.Layouts 1.14
import QtQuick.Controls 2.14

RowLayout{
    Layout.fillWidth: true

    property var hours: hourInput.text
    property var minutes: minutesInput.text
    property var name: "TODO"
    property var end: ""

    Text{
        text: name
    }
    TextField{
        id: hourInput
        validator: IntValidator {bottom: 1; top: 100}
        text: ""

    }
    Text{
        text: "h "
    }
    TextField{
        validator: IntValidator {bottom: 1; top: 60}
        text: ""
    }
    Text{
        text: "min"
    }
    Rectangle{
        id: minutesInput
        Layout.fillWidth: true
    }
    Text{
        text: end
    }
}
