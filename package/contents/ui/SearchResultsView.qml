import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

GridLayout {
	id: searchResultsView
	rowSpacing: 0
	property alias listView: searchResultsList

	ScrollView {
		id: searchResultsListScrollView
		Layout.row: searchView.searchOnTop ? 0 : 2
		Layout.fillWidth: true
		Layout.fillHeight: true

		SearchResultsList {
			id: searchResultsList
		}
	}		
}
