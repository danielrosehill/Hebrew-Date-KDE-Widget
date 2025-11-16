import QtQuick
import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
        name: "Appearance"
        icon: "preferences-desktop-theme"
        source: "configAppearance.qml"
    }

    ConfigCategory {
        name: "Font"
        icon: "preferences-desktop-font"
        source: "configFont.qml"
    }

    ConfigCategory {
        name: "Location"
        icon: "preferences-desktop-locale"
        source: "configLocation.qml"
    }
}
