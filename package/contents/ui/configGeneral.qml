import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: root

    property alias cfg_language: languageCombo.currentValue
    property alias cfg_showYear: showYearCheck.checked

    QQC2.ComboBox {
        id: languageCombo
        Kirigami.FormData.label: "Language"
        model: [
            { text: "English", value: "english" },
            { text: "Hebrew", value: "hebrew" },
            { text: "Both", value: "both" }
        ]
        textRole: "text"
        valueRole: "value"
        Component.onCompleted: {
            // initialize from config
            const idx = model.findIndex(m => m.value === plasmoid.configuration.language)
            if (idx >= 0) currentIndex = idx
        }
    }

    QQC2.CheckBox {
        id: showYearCheck
        Kirigami.FormData.label: "Show year"
        checked: plasmoid.configuration.showYear
    }
}

