import QtQuick 2.3
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kirigami 2.19 as Kirigami
import QtWebEngine 1.9

Item {
    id: root
    property bool themeMismatch: false;
    property int nextReloadTime: 0;
    property int reloadRetries: 0;
    property int maxReloadRetries: 25;
    property bool loadedSuccessfully: false;

    Plasmoid.compactRepresentation: CompactRepresentation {}

    Plasmoid.fullRepresentation: ColumnLayout {
        anchors.fill: parent
        width: 1600 // Adjust width as needed
        height: 600 // Adjust height as needed

        //------------------------------------- UI -----------------------------------------

        ColumnLayout {
            spacing: Kirigami.Units.mediumSpacing

            PlasmaExtras.PlasmoidHeading {
                Layout.fillWidth: true

                ColumnLayout {
                    anchors.fill: parent
                    Layout.fillWidth: true

                    RowLayout {
                        Layout.fillWidth: true

                        PlasmaComponents.ToolButton {
                            text: "Home (Discord)"
                            onClicked: {
                                // Open Discord web in the default system browser
                                Qt.openUrlExternally("https://discord.com/")
                            }
                        }

                        Kirigami.Heading {
                            id: discord
                            Layout.alignment: Qt.AlignCenter
                            Layout.fillWidth: true
                            verticalAlignment: Text.AlignVCenter
                            color: theme.textColor
                        }

                        PlasmaComponents.ToolButton {
                            text: i18n("Debug")
                            checkable: true
                            checked: discordWebViewInspector && discordWebViewInspector.enabled
                            visible: Qt.application.arguments[0] === "plasmoidviewer" || plasmoid.configuration.debugConsole
                            enabled: visible
                            icon.name: "format-text-code"
                            display: PlasmaComponents.ToolButton.IconOnly
                            PlasmaComponents.ToolTip.text: text
                            PlasmaComponents.ToolTip.delay: Kirigami.Units.toolTipDelay
                            PlasmaComponents.ToolTip.visible: hovered
                            onToggled: {
                                discordWebViewInspector.visible = !discordWebViewInspector.visible;
                                discordWebViewInspector.enabled = visible || discordWebViewInspector.visible
                            }
                        }

                        PlasmaComponents.ToolButton {
                            id: refreshButton
                            text: i18n("Reload")
                            icon.name: "view-refresh"
                            display: PlasmaComponents.ToolButton.IconOnly
                            PlasmaComponents.ToolTip.text: text
                            PlasmaComponents.ToolTip.delay: Kirigami.Units.toolTipDelay
                            PlasmaComponents.ToolTip.visible: hovered
                            onClicked: discordWebView.reload();
                        }

                        PlasmaComponents.ToolButton {
                            id: pinButton
                            checkable: true
                            checked: plasmoid.configuration.pin
                            icon.name: "window-pin"
                            text: i18n("Keep Open")
                            display: PlasmaComponents.ToolButton.IconOnly
                            PlasmaComponents.ToolTip.text: text
                            PlasmaComponents.ToolTip.delay: Kirigami.Units.toolTipDelay
                            PlasmaComponents.ToolTip.visible: hovered
                            onToggled: plasmoid.configuration.pin = checked
                        }
                    }
                }
            }

            //-------------------- Connections  -----------------------

            Binding {
                target: plasmoid
                property: "hideOnWindowDeactivate"
                value: !plasmoid.configuration.pin
            }
        }

        WebEngineView {
            Layout.fillHeight: true
            Layout.fillWidth: true

            id: discordWebView
            focus: true
            url: "https://discord.com/"

            onLoadingChanged: {
                if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
                    discordWebView.page.userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36";
                }
            }
        }

        WebEngineView {
            id: discordWebViewInspector
            enabled: false
            visible: false
            z: 100
            height: parent.height / 2

            Layout.fillWidth: true
            Layout.alignment: Qt.AlignBottom
        }
    }
}
