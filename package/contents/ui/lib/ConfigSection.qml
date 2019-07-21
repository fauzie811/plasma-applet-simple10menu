// Version 3

import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

ColumnLayout {
	id: control
	Layout.fillWidth: true
	default property alias _contentChildren: content.data
	property string label: ""

	property alias spacing: content.spacing

	Label {
		id: title
		visible: control.label
		text: control.label
		font.bold: true
		font.pointSize: 12 * units.devicePixelRatio
		anchors.left: parent.left
		anchors.top: parent.top
		anchors.right: parent.right
		height: visible ? implicitHeight : 0
	}

	ColumnLayout {
		id: content
		anchors.top: title.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.margins: control.padding
		spacing: 5 * units.devicePixelRatio

		// Workaround for crash when using default on a Layout.
		// https://bugreports.qt.io/browse/QTBUG-52490
		// Still affecting Qt 5.7.0
		Component.onDestruction: {
			while (children.length > 0) {
				children[children.length - 1].parent = control;
			}
		}
	}
}
