import QtQuick 2.0
import QtQuick.Layouts 1.14 //RowLayout
 import QtQuick.Controls 2.14 //TextField

RowLayout{ //time //TODO: change for the mobile version?
    Text{ text: qsTr("Pick time: ") }

    property int minHourBound: 0
    property int maxHourBound: 23

    property int minMinutesBound: 0
    property int maxMinutesBound: 59

    property int hoursValue
    property int minutesValue

    TextField{ //TODO: make this a comboBox?
        id: timeH
        Layout.fillWidth: true
        validator: IntValidator {bottom: 0; top: 23}
        text: hoursValue
        onFocusChanged: {
            if(focus && hoursValue === 00)
                text = ""
        }
        onTextChanged: {
            if(parseInt(text) > maxHourBound)
                text = maxHourBound
            if(parseInt(text) < minHourBound)
                text = minHourBound
        }
    }
    Text{ text: ":" }
    TextField{ //TODO: make this a comboBox?
        id: timeMin
        Layout.fillWidth: true
        validator: IntValidator {bottom: 0; top: 59}
        text: minutesValue
        onFocusChanged: {
            if(focus && minutesValue === 00)
                text = ""
        }
        onTextChanged: {
            if(parseInt(text) > maxMinutesBound)
                text = maxMinutesBound
            if(parseInt(text) < minMinutesBound)
                text = minMinutesBound
        }
    }
    Text{ text: "" }
}
