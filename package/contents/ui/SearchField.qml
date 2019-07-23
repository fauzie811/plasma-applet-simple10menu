import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import QtQuick.Controls.Styles.Plasma 2.0 as PlasmaStyles

TextField {
	id: searchField
	placeholderText: i18n("Search")

	onTextChanged: {
		search.query = text
	}
	Connections {
		target: search
		onQueryChanged: searchField.text = search.query
	}

	property var listView: searchResultsView.listView
	Keys.onPressed: {
		if (event.key == Qt.Key_Up) {
			event.accepted = true; listView.goUp()
		} else if (event.key == Qt.Key_Down) {
			event.accepted = true; listView.goDown()
		} else if (event.key == Qt.Key_PageUp) {
			event.accepted = true; listView.pageUp()
		} else if (event.key == Qt.Key_PageDown) {
			event.accepted = true; listView.pageDown()
		} else if (event.key == Qt.Key_Return) {
			event.accepted = true; listView.currentItem.trigger()
		} else if (event.key == Qt.Key_Escape) {
			plasmoid.expanded = false
		}
	}

	Component.onCompleted: {
		forceActiveFocus()
	}
}