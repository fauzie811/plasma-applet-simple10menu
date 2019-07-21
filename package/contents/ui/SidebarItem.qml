import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Controls 2.0 as QQC2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents


import QtQuick.Controls.Private 1.0 as QtQuickControlsPrivate
import QtQuick.Controls.Styles.Plasma 2.0 as PlasmaStyles

FlatButton {
	id: sidebarItem
	Layout.fillWidth: true
	Layout.minimumWidth: expanded ? config.sidebarMinOpenWidth : implicitWidth
	property var sidebarMenu: parent.parent // Column.SidebarMenu
	property bool expanded: sidebarMenu ? sidebarMenu.open : false
	labelVisible: expanded
	property bool closeOnClick: true
	property Item submenu: null
	readonly property bool submenuOpen: submenu ? submenu.open : false
	
	property string svgIconName: ""
	readonly property string svgIconFilename: svgIconName ? plasmoid.file("", "icons/" + svgIconName + ".svg") : ""

	onClicked: {
		if (sidebarMenu && sidebarMenu.open && closeOnClick) {
			sidebarMenu.open = false
		}
		if (submenu) {
			submenu.open = !submenu.open
		}
	}
	
	PlasmaCore.SvgItem {
		id: svgIcon
		visible: !!sidebarItem.svgIconName

		svg: PlasmaCore.Svg {
			imagePath: sidebarItem.svgIconFilename
		}

		// From FlatButton.qml, modifed so icon is also 16px
		property int iconSize: units.roundToIconSize(config.flatButtonIconSize)
		width: iconSize
		height: iconSize
		anchors.centerIn: parent
	}

	QQC2.ToolTip {
		id: control
		visible: sidebarItem.hovered && !(sidebarItem.expanded || sidebarItem.submenuOpen)
		text: sidebarItem.text
		delay: 0
		x: parent.width + rightPadding
		y: (parent.height - height) / 2
	}
}
