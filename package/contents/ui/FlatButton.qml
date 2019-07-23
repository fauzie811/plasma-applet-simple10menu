import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import QtQuick.Controls.Private 1.0 as QtQuickControlsPrivate
import QtQuick.Controls.Styles.Plasma 2.0 as PlasmaStyles

PlasmaComponents.ToolButton {
	id: flatButton
	implicitHeight: config.flatButtonSize
	property var icon: null
	iconName: ""
	property bool expanded: true
	text: ""
	property string label: expanded ? text : ""
	property bool labelVisible: text != ""
	property color backgroundColor: config.flatButtonBgColor
	property color backgroundHoverColor: config.flatButtonBgHoverColor
	property color backgroundPressedColor: config.flatButtonBgPressedColor

	style: PlasmaStyles.ToolButtonStyle {
		label: RowLayout {
			id: labelRowLayout
			// spacing: units.smallSpacing
			spacing: 0

			Item {
				id: iconContainer
				Layout.fillHeight: true
				implicitWidth: height
				visible: !!icon.source

				PlasmaCore.IconItem {
					id: icon
					source: control.iconName || control.iconSource || control.icon
					implicitWidth: config.flatButtonIconSize
					implicitHeight: config.flatButtonIconSize
					anchors.centerIn: parent
					// colorGroup: PlasmaCore.Theme.ButtonColorGroup
				}

				// Rectangle { border.color: "#f00"; anchors.fill: parent; border.width: 1; color: "transparent"; }
			}

			PlasmaComponents.Label {
				id: label
				text: QtQuickControlsPrivate.StyleHelpers.stylizeMnemonics(control.text)
				font: control.font || theme.defaultFont
				visible: control.labelVisible
				horizontalAlignment: Text.AlignLeft
				verticalAlignment: Text.AlignVCenter
				Layout.fillWidth: true

				// Rectangle { border.color: "#f00"; anchors.fill: parent; border.width: 1; color: "transparent"; }
			}

			Item {
				id: rightPaddingItem
				Layout.fillHeight: true
				property int iconMargin: (iconContainer.width - icon.width)/2
				property int iconPadding: icon.width * (16-12)/16
				implicitWidth: iconMargin + iconPadding
				visible: control.labelVisible

				// Rectangle { border.color: "#f00"; anchors.fill: parent; border.width: 1; color: "transparent"; }
			}
		}

		background: Item {
			PlasmaCore.FrameSvgItem {
				anchors.fill: parent
				imagePath: "widgets/viewitem"
				prefix: "hover"
				visible: control.hovered
			}

			PlasmaCore.FrameSvgItem {
				anchors.fill: parent
				imagePath: "widgets/viewitem"
				prefix: "selected"
				visible: control.pressed
			}
		}
	}
}