import QtQuick 2.3
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.5 as QQC2
import org.kde.kirigami 2.4 as Kirigami

Kirigami.FormLayout {
    id: page
    property alias cfg_focusInterval: focusInterval.value
    property alias cfg_maxReloadTime: maxReloadTime.value
    property alias cfg_debugConsole: debugConsole.checked

    Layout.fillHeight: true

    QQC2.Slider {
        Kirigami.FormData.label: i18n("Focus input after: %1ms", focusInterval.value)
        id: focusInterval
        from: 0
        stepSize: 10
        value: 0
        to: 1000
        live: true
    }

    QQC2.Label {
        font.pixelSize: 8
        font.italic: true
        text: i18n("This sets the interval (in milliseconds) to focus on the input field after using a shortcut.")
    }

    QQC2.CheckBox {
        id: debugConsole
        Layout.alignment: Qt.AlignBottom
        Kirigami.FormData.label: i18n("Show debug console")
    }

    QQC2.Slider {
        Kirigami.FormData.label: i18n("Max reload interval is set to: %1 seconds", maxReloadTime.value)
        id: maxReloadTime
        from: 0
        stepSize: 10
        value: 30
        to: 3600
        live: true
    }
    QQC2.Label {
        font.pixelSize: 8
        font.italic: true
        text: i18n("This sets the maximum interval (in seconds) for auto-reloading the page when hidden, if the page failed to load.")
    }
}
