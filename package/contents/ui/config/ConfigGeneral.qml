import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.kcoreaddons 1.0 as KCoreAddons

import ".."
import "../lib"

ConfigPage {
	id: page
	showAppletVersion: true

	function getTopItem(item) {
		var curItem = item
		while (curItem.parent) {
			curItem = curItem.parent
		}
		return curItem
	}
	function hideKeyboardShortcutTab() {
		// console.log('root', root)
		// console.log('root.parent', root.parent)
		// console.log('getTopItem(root)', getTopItem(root))
		
		// https://github.com/KDE/plasma-desktop/blob/master/desktoppackage/contents/configuration/AppletConfiguration.qml
		// The "root" id can't always be referenced here, so use one of the child id's and get it's parent.
		var appletConfiguration
		if (typeof mainColumn !== "undefined") { // Plasma 5.14 and below
			appletConfiguration = mainColumn.parent
		} else if (typeof root !== "undefined") { // Plasma 5.15 and above
			// root is the StackView { id: pageStack } in plasmoidviewer
			// walk up to the top node of the "DOM" for AppletConfiguration
			// However root in plasmashell is AppletConfiguration for some reason...
			appletConfiguration = getTopItem(root)
		}
		if (typeof appletConfiguration !== "undefined" && typeof appletConfiguration.globalConfigModel !== "undefined") {
			// Remove default Global Keyboard Shortcut config tab.
			var keyboardShortcuts = appletConfiguration.globalConfigModel.get(0)
			appletConfiguration.globalConfigModel.removeCategoryAt(0)
		}
	}

	Component.onCompleted: {
		hideKeyboardShortcutTab()
	}

	AppletConfig {
		id: config
	}

	XdgPathsLoader { id: xdgPathsLoader }

	ConfigSection {
		label: i18n("Panel Icon")

		ConfigIcon {
			configKey: 'icon'
			previewIconSize: units.iconSizes.large

			RowLayout {
				ConfigCheckBox {
					text: i18n("Fixed Size")
					configKey: 'fixedPanelIcon'
				}

				ConfigCheckBox {
					text: i18n("Wide Button")
					configKey: 'widePanelButton'
				}
			}
		}
	}

	ConfigSection {
		label: i18n("Sidebar Shortcuts")

		ColumnLayout {
			ConfigStringList {
				id: sidebarShortcuts
				configKey: 'sidebarShortcuts'
				Layout.fillHeight: true

				KCoreAddons.KUser {
					id: kuser
				}

				function startsWith(a, b) {
					return a.substr(0, b.length) === b
				}

				function parseText(text) {
					var urls = text.split("\n")
					for (var i = 0; i < urls.length; i++) {
						if (startsWith(urls[i], '~/')) { // Starts with '~/' (home dir)
							if (kuser.loginName) {
								urls[i] = '/home/' + kuser.loginName + urls[i].substr(1)
							}
						}
						if (startsWith(urls[i], '/')) { // Starts with '/' (root)
							urls[i] = 'file://' + urls[i] // Prefix URL file scheme when serializing.
						}
					}
					return urls
				}

				function addUrl(str) {
					if (hasItem(str)) {
						// Skip. Kicker.FavoritesModel will remove it anyways,
						// and can cause a serialize + deserialize loop.
					} else {
						prepend(str)
					}
					selectItem(str) // Select the existing text to highlight it's existence.
				}
			}

			Label {
				text: i18n("Add Default")
			}

			RowLayout {
				id: sidebarDefaultsColumn

				ConfigIconButton {
					iconName: "folder-documents-symbolic"
					text: xdgPathsLoader.displayName('DOCUMENTS')
					onClicked: sidebarShortcuts.addUrl('xdg:DOCUMENTS')
				}
				ConfigIconButton {
					iconName: "folder-download-symbolic"
					// Component.onCompleted: contentItem.alignment = Qt.AlignLeft
					text: xdgPathsLoader.displayName('DOWNLOAD')
					onClicked: sidebarShortcuts.addUrl('xdg:DOWNLOAD')
				}
				ConfigIconButton {
					iconName: "folder-music-symbolic"
					text: xdgPathsLoader.displayName('MUSIC')
					onClicked: sidebarShortcuts.addUrl('xdg:MUSIC')
				}
				ConfigIconButton {
					iconName: "folder-pictures-symbolic"
					text: xdgPathsLoader.displayName('PICTURES')
					onClicked: sidebarShortcuts.addUrl('xdg:PICTURES')
				}
				ConfigIconButton {
					iconName: "folder-videos-symbolic"
					text: xdgPathsLoader.displayName('VIDEOS') // Uhg, it's displayed 'Movies' instead of 'Videos'...
					onClicked: sidebarShortcuts.addUrl('xdg:VIDEOS')
				}
				ConfigIconButton {
					iconName: "system-file-manager-symbolic"
					text: i18nd("dolphin", "Dolphin")
					onClicked: sidebarShortcuts.addUrl('org.kde.dolphin.desktop')
				}
				ConfigIconButton {
					iconName: "configure"
					text: i18nd("systemsettings", "System Settings")
					onClicked: sidebarShortcuts.addUrl('systemsettings.desktop')
				}
				Item { Layout.fillHeight: true }
			}
		}
	}

	ConfigSection {
		label: i18n("App List")

		ConfigSpinBox {
			id: appListWidthControl
			configKey: 'appListWidth'
			before: i18n("App List Area Width")
			suffix: i18n("px")
			minimumValue: 0
		}

		RowLayout {
			ConfigCheckBox {
				id: showRecentAppsCheckBox
				text: i18nd("plasma_applet_org.kde.plasma.kicker", "Show:")
				configKey: 'showRecentApps'
			}
			ConfigSpinBox {
				configKey: 'numRecentApps'
				enabled: showRecentAppsCheckBox.checked
				// Kicker's RecentUsageModel limits to 15 apps.
				// https://github.com/KDE/plasma-desktop/blob/master/applets/kicker/plugin/recentusagemodel.cpp#L449
				minimumValue: 1
				maximumValue: 15
			}

			ConfigComboBox {
				configKey: 'recentOrdering'
				label: ""
				model: [
					{ value: 0, text: i18nd("plasma_applet_org.kde.plasma.kicker", "Show recent applications") },
					{ value: 1, text: i18nd("plasma_applet_org.kde.plasma.kicker", "Show often used applications") },
				]
			}
		}
	}

}
