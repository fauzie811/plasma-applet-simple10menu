import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import org.kde.plasma.components 2.0 as PlasmaComponents

MouseArea {
	id: sectionDelegate

	width: parent.width
	// height: childrenRect.height
	implicitHeight: listView.iconSize

	property bool enableJumpToSection: false

	PlasmaComponents.Label {
		id: sectionHeading
		anchors {
			left: parent.left
			leftMargin: 5 * units.devicePixelRatio
			verticalCenter:  parent.verticalCenter
		}
		text: {
			if (section == appsModel.recentAppsSectionKey) {
				return appsModel.recentAppsSectionLabel
			} else {
				return section
			}
		}

		// property bool centerOverIcon: sectionHeading.contentWidth <= listView.iconSize
		// width: centerOverIcon ? listView.iconSize : parent.width
		// horizontalAlignment: centerOverIcon ? Text.AlignHCenter : Text.AlignLeft
		width: parent.width
	}

	hoverEnabled: true
	onClicked: {
		if (enableJumpToSection) {
			jumpToLetterView.show()
		}
	}
}
