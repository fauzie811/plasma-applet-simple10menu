import QtQuick 2.0
import QtQuick.Window 2.2

Item {
	function setAlpha(c, a) {
		var c2 = Qt.darker(c, 1)
		c2.a = a
		return c2
	}

	//--- Sizes
	readonly property int panelIconSize: 24 * units.devicePixelRatio
	readonly property int flatButtonSize: 48 * units.devicePixelRatio
	readonly property int flatButtonIconSize: 20 * units.devicePixelRatio
	readonly property int sidebarWidth: flatButtonSize
	readonly property int sidebarMinOpenWidth: 200 * units.devicePixelRatio
	readonly property int sidebarRightMargin: 4 * units.devicePixelRatio
	readonly property int appListWidth: plasmoid.configuration.appListWidth * units.devicePixelRatio

	property bool showSearch: false
	readonly property int appAreaWidth: (showSearch ? appListWidth : 0)
	readonly property int leftSectionWidth: sidebarWidth + sidebarRightMargin + appAreaWidth

	readonly property int searchFieldHeight: 32 * units.devicePixelRatio

	readonly property int popupWidth: leftSectionWidth
	readonly property int popupHeight: plasmoid.configuration.popupHeight * units.devicePixelRatio
	
	readonly property int menuItemHeight: 32 * units.devicePixelRatio
	readonly property int menuIconSize: 22 * units.devicePixelRatio
	
	readonly property int searchFilterRowHeight: 40 * units.devicePixelRatio

	//--- Colors
	readonly property color themeButtonBgColor: theme.highlightColor
	readonly property color menuItemTextColor2: setAlpha(theme.textColor, 0.6)
	readonly property color flatButtonBgHoverColor: Qt.rgba(themeButtonBgColor.r, themeButtonBgColor.g, themeButtonBgColor.b, 0.5)
	readonly property color flatButtonBgColor: Qt.rgba(flatButtonBgHoverColor.r, flatButtonBgHoverColor.g, flatButtonBgHoverColor.b, 0)
	readonly property color flatButtonBgPressedColor: theme.highlightColor
	readonly property color flatButtonCheckedColor: theme.highlightColor

	//--- Settings
	// Search
	readonly property bool searchResultsMerged: plasmoid.configuration.searchResultsMerged
	readonly property bool searchResultsCustomSort: plasmoid.configuration.searchResultsCustomSort
	readonly property int searchResultsDirection: plasmoid.configuration.searchResultsReversed ? ListView.BottomToTop : ListView.TopToBottom

	property var tileColors: {
        "brave-fiombgjlkfpdpkbhfioofeeinbehmajg-Default.desktop": "#103f91",
        "brave-iljnkagajgfdmfnnidjijobijlfjfgnb-Default.desktop": "#185c37",
		"wine-Programs-Access 2016.desktop": "#ae4d50",
		"wine-Programs-Excel 2016.desktop": "#39825a",
		"wine-Programs-OneNote 2016.desktop": "#8e4f89",
		"wine-Programs-Outlook 2016.desktop": "#007acc",
		"wine-Programs-PowerPoint 2016.desktop": "#dc6141",
		"wine-Programs-Publisher 2016.desktop": "#228479",
		"wine-Programs-Word 2016.desktop": "#4269a5",
		"brave-browser.desktop": "#5F6368",
		"firefox.desktop": "#000f40",
		"jetbrains-studio.desktop": "#4a662a",
        "libreoffice-startcenter.desktop": "#00A500",
        "libreoffice-calc.desktop": "#185c37",
        "libreoffice-math.desktop": "#00A500",
        "libreoffice-writer.desktop": "#103f91",
		"whatsapp-desktop.desktop": "#25d366",
        "code.desktop": "#2d2d30",
	}
}
