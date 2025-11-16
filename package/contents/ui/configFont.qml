import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: root

    property alias cfg_fontBold: fontBoldCheck.checked
    property alias cfg_fontItalic: fontItalicCheck.checked
    property alias cfg_autoSizeByContext: autoSizeCheck.checked
    property alias cfg_desktopFontSize: desktopFontSizeSpinBox.value
    property alias cfg_panelFontSize: panelFontSizeSpinBox.value

    // Font Style Section
    Item {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: "Font Style"
    }

    QQC2.CheckBox {
        id: fontBoldCheck
        Kirigami.FormData.label: "Style"
        text: "Bold"
    }

    QQC2.CheckBox {
        id: fontItalicCheck
        text: "Italic"
    }

    // Font Size Section
    Item {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: "Font Size"
    }

    QQC2.CheckBox {
        id: autoSizeCheck
        Kirigami.FormData.label: "Auto-sizing"
        text: "Automatically adjust font size based on widget location"
        checked: true
    }

    QQC2.Label {
        text: "When enabled, the widget uses different font sizes for panel/tray vs desktop placement"
        font.pointSize: Kirigami.Theme.smallFont.pointSize
        opacity: 0.7
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
    }

    QQC2.SpinBox {
        id: desktopFontSizeSpinBox
        Kirigami.FormData.label: "Desktop Font Size"
        from: 8
        to: 72
        value: 18
        editable: true
    }

    QQC2.Label {
        text: "Font size when widget is placed on the desktop (larger for readability)"
        font.pointSize: Kirigami.Theme.smallFont.pointSize
        opacity: 0.7
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
    }

    QQC2.SpinBox {
        id: panelFontSizeSpinBox
        Kirigami.FormData.label: "Panel/Tray Font Size"
        from: 6
        to: 36
        value: 11
        editable: true
    }

    QQC2.Label {
        text: "Font size when widget is in a panel or system tray (smaller to fit compact space)"
        font.pointSize: Kirigami.Theme.smallFont.pointSize
        opacity: 0.7
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
    }
}
