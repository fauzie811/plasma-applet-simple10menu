import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.draganddrop 2.0 as DragAndDrop
import org.kde.kquickcontrolsaddons 2.0 // KCMShell

import "Utils.js" as Utils

Item {
	id: sidebarView
	anchors.left: parent.left
	anchors.top: parent.top
	anchors.bottom: parent.bottom
	z: 1

	width: sidebarMenu.width
	Behavior on width { NumberAnimation { duration: 100 } }

	DragAndDrop.DropArea {
		anchors.fill: sidebarMenu

		onDrop: {
			if (event && event.mimeData && event.mimeData.url) {
				var url = event.mimeData.url.toString()
				url = Utils.parseDropUrl(url)
				appsModel.sidebarModel.addFavorite(url, 0)
			}
		}
	}

	SidebarMenu {
		id: sidebarMenu
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.bottom: parent.bottom

		ColumnLayout {
			id: sidebarMenuTop
			spacing: 0

			SidebarItem {
				iconName: "open-menu-symbolic"
				text: i18n("START")
				closeOnClick: false
				onClicked: sidebarMenu.open = !sidebarMenu.open
			}
		}
		ColumnLayout {
			anchors.bottom: parent.bottom
			spacing: 0

			SidebarItem {
				iconName: kuser.faceIconUrl ? kuser.faceIconUrl : 'user-identity'
				text: kuser.fullName
				submenu: userMenu

				SidebarContextMenu {
					id: userMenu

					Item {
						implicitHeight: 8 * units.devicePixelRatio
					}

					SidebarContextMenuItem {
						iconName: 'system-users'
						text: i18n("User Manager")
						onClicked: KCMShell.open('user_manager')
						visible: KCMShell.authorize('user_manager.desktop').length > 0
					}

					SidebarItemRepeater {
						model: appsModel.sessionActionsModel
					}

					Item {
						implicitHeight: 8 * units.devicePixelRatio
					}
				}
			}

			SidebarFavouritesView {
				model: appsModel.sidebarModel
				maxHeight: sidebarMenu.height - sidebarMenuTop.height - 2 * config.flatButtonSize
			}

			SidebarItem {
				iconName: "system-shutdown-symbolic"
				text: i18n("Power")
				submenu: powerMenu

				SidebarContextMenu {
					id: powerMenu
					
					Item {
						implicitHeight: 8 * units.devicePixelRatio
					}

					SidebarItemRepeater {
						model: appsModel.powerActionsModel
					}

					Item {
						implicitHeight: 8 * units.devicePixelRatio
					}
				}
			}
		}

		onFocusChanged: {
			logger.debug('searchView.onFocusChanged', focus)
			if (!focus) {
				open = false
			}
		}
	}


}
