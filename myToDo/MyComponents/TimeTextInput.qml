import QtQuick 2.0
import QtQuick.Layouts 1.14 //RowLayout
 import QtQuick.Controls 2.14 //TextField

RowLayout{ //time //TODO: change for the mobile version?
    Text{ text: prefix; color: isEnabled ? "black" : "grey" }

    property int minHourBound: 0
    property int maxHourBound: 23

    property int minMinutesBound: 0
    property int maxMinutesBound: 55

    property int hoursValue
    property int minutesValue

    property bool isEnabled: true

    property string prefix: qsTr("Pick time: ")

    signal updateStartTime()

    SpinBox {
        id: hoursSpinBox
        value: hoursValue
        from: -1
        to: 24
        enabled: isEnabled

        onValueModified: {
            if(value > maxHourBound)
                value = minHourBound
            if(value < minHourBound)
                value = maxHourBound
            hoursValue = value
            updateStartTime()
        }
    }

    Text{ text: ":"; color: isEnabled ? "black" : "grey" }

    SpinBox {
        id: minutesSpinBox
        value: minutesValue
        from: -1
        to: 60
        stepSize: 5
        enabled: isEnabled

        onValueModified: {
            if(value > maxMinutesBound)
                value = minMinutesBound
            if(value < minMinutesBound)
                value = maxMinutesBound
            minutesValue = value
            updateStartTime()
        }
        textFromValue: function(value, locale) {
            if(value < 10)
                return "0" + Number(value).toLocaleString(locale, 'f', 0);
            else
                return Number(value).toLocaleString(locale, 'f', 0);
        }
    }

}
