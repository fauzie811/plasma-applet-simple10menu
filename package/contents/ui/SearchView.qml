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
	id: searchView
	implicitWidth: config.appAreaWidth
	// Behavior on implicitWidth {
	// 	NumberAnimation { duration: 400 }
	// }

	visible: opacity > 0
	opacity: config.showSearch ? 1 : 0
	// Behavior on opacity {
	// 	NumberAnimation { duration: 400 }
	// }

	Connections {
		target: search
		onIsSearchingChanged: {
			if (search.isSearching) {
				searchView.showSearchView()
			}
		}
	}
	clip: true

	// width: config.leftSectionWidth
	height: config.popupHeight
	property alias searchResultsView: searchResultsView
	property alias appsView: appsView
	property alias searchField: searchField
	property alias jumpToLetterView: jumpToLetterView

	readonly property bool showingAppList: stackView.currentItem == appsView || stackView.currentItem == jumpToLetterView

	property bool searchOnTop: false

	function showDefaultView() {
		appsView.show()
	}

	function showSearchView() {
		config.showSearch = true
	}

	states: [
		State {
			name: "searchOnTop"
			when: searchOnTop
			PropertyChanges {
				target: stackViewContainer
				anchors.topMargin: searchField.height
			}
			PropertyChanges {
				target: searchField
				anchors.top: searchField.parent.top
			}
		},
		State {
			name: "searchOnBottom"
			when: !searchOnTop
			PropertyChanges {
				target: stackViewContainer
				anchors.bottomMargin: searchField.height
			}
			PropertyChanges {
				target: searchField
				anchors.bottom: searchField.parent.bottom
			}
		}
	]


	Item {
		id: stackViewContainer
		anchors.fill: parent

		SearchResultsView {
			id: searchResultsView
			visible: false

			Connections {
				target: search
				onQueryChanged: {
					if (search.query.length > 0 && stackView.currentItem != searchResultsView) {
						stackView.push(searchResultsView, true)
					} else if (search.query.length == 0 && stackView.currentItem == searchResultsView) {
						appsView.show()
					}
				}
			}

			onVisibleChanged: {
				if (!visible) { // !stackView.currentItem
					search.query = ""
				}
			}

			function showDefaultSearch() {
				if (stackView.currentItem != searchResultsView) {
					stackView.push(searchResultsView, true)
				}
			}
		}
		
		AppsView {
			id: appsView
			visible: false

			function show(animation) {
				config.showSearch = true
				if (stackView.currentItem != appsView) {
					stackView.delegate = animation || stackView.noTransition
					stackView.push({
						item: appsView,
						replace: true,
					})
				}
				appsView.scrollToTop()
			}
		}

		JumpToLetterView {
			id: jumpToLetterView
			visible: false

			function show() {
				config.showSearch = true
				if (stackView.currentItem != jumpToLetterView) {
					stackView.delegate = stackView.zoomOut
					stackView.push({
						item: jumpToLetterView,
						replace: true,
					})
				}
			}
		}

		// TM3.Main {
		// 	id: appsView
		// 	// width: parent.width
		// 	// height: parent.height

		// 	function show() {
		// 		if (stackView.currentItem != appsView) {
		// 			stackView.push(appsView, true)
		// 		}
		// 		appsView.scrollToTop()
		// 	}
		// }

		// Item {
		// 	id: appsView
		// }

		SearchStackView {
			id: stackView
			width: config.appAreaWidth
			anchors.top: parent.top
			anchors.right: parent.right
			anchors.bottom: parent.bottom
			initialItem: appsView
		}
	}


	SearchField {
		id: searchField
		// width: 430
		height: config.searchFieldHeight
		anchors.left: parent.left
		anchors.right: parent.right

		listView: stackView.currentItem && stackView.currentItem.listView ? stackView.currentItem.listView : []
	}
}
