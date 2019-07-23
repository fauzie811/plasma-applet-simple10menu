import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import org.kde.plasma.components 2.0 as PlasmaComponents

GridView {
	id: jumpToSectionView

	// Layout.fillWidth: true
	// Layout.fillHeight: true
	anchors.centerIn: parent

	Connections {
		target: appsModel.allAppsModel
		onRefreshed: jumpToLetterView.update()
	}

	signal update()

	property var availableSections: []
	property var presetSections: []
	property var allSections: []
	model: allSections

	property int buttonSize: 48 * units.devicePixelRatio

	cellWidth: buttonSize
	cellHeight: buttonSize

	delegate: AppToolButton {
		width: jumpToLetterView.cellWidth
		height: jumpToLetterView.cellHeight

		readonly property string section: modelData || ''
		readonly property bool isRecentApps: section == appsModel.recentAppsSectionKey
		readonly property var sectionIcon: appsModel.allAppsModel.sectionIcons[section] || null

		enabled: availableSections.indexOf(section) >= 0

		font.pixelSize: 20

		iconSource: {
			if (isRecentApps) {
				return 'view-history'
			} else {
				return ''
			}
		}
		text: {
			if (isRecentApps) {
				return  '' // Use '◷' icon
			} else if (section == '0-9') {
				return '#'
			} else {
				return section
			}
		}
		
		onClicked: {
			appsView.show(stackView.zoomIn)
			appsView.jumpToSection(section)
		}
	}
}
