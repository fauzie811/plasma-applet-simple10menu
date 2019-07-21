import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

MouseArea {
	id: sidebarMenu
	hoverEnabled: true
	z: 1
	// implicitWidth: config.sidebarWidth
	implicitWidth: open ? config.sidebarMinOpenWidth : config.sidebarWidth
	property bool open: false
	Behavior on width { NumberAnimation { duration: 100 } }

	onOpenChanged: {
		if (open) {
			forceActiveFocus()
		} else {
			searchView.searchField.forceActiveFocus()
		}
	}

	Rectangle {
		anchors.fill: parent
		color: theme.backgroundColor
		opacity: parent.open ? 1 : 0
	}

	property alias showDropShadow: sidebarMenuShadows.visible
	SidebarMenuShadows {
		id: sidebarMenuShadows
		anchors.fill: parent
		visible: sidebarMenu.open
	}
}
