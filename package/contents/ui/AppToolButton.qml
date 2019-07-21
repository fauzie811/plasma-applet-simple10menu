import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import QtQuick.Controls.Private 1.0 as QtQuickControlsPrivate

MouseArea {
	id: control
	hoverEnabled: true

	property string iconName: ""
	property var iconSource: null
	property string text: ""
	property string tooltip: ""

	property font font: theme.defaultFont
	property real minimumWidth: 0
	property real minimumHeight: 0

	Item {
		// id: buttonArea
		anchors.fill: parent
		opacity: control.enabled ? 1 : 0.5

		RowLayout {
			id: buttonContent
			anchors.fill: parent
			spacing: units.smallSpacing

			Layout.preferredHeight: Math.max(units.iconSizes.small, label.implicitHeight)

			PlasmaCore.IconItem {
				id: icon
				source: control.iconName || control.iconSource

				implicitHeight: label.implicitHeight
				implicitWidth: implicitHeight

				visible: valid
				Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
				active: control.containsMouse
				colorGroup: control.containsMouse ? PlasmaCore.Theme.ButtonColorGroup : PlasmaCore.ColorScope.colorGroup
			}

			PlasmaComponents.Label {
				id: label
				Layout.minimumWidth: implicitWidth
				text: QtQuickControlsPrivate.StyleHelpers.stylizeMnemonics(control.text)
				font: control.font || theme.defaultFont
				visible: control.text != ""
				Layout.fillWidth: true
				height: parent.height
				color: control.containsMouse ? theme.buttonTextColor : PlasmaCore.ColorScope.textColor
				horizontalAlignment: icon.valid ? Text.AlignLeft : Text.AlignHCenter
				verticalAlignment: Text.AlignVCenter
				elide: Text.ElideRight
			}
		}
	}
}
