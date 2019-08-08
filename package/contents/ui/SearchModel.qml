import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.plasma.private.kicker 0.1 as Kicker

Item {
	id: search
	property alias results: resultModel
	property alias runnerModel: runnerModel

	property string query: ""
	property bool isSearching: query.length > 0
	onQueryChanged: {
		runnerModel.query = search.query
	}

	Kicker.RunnerModel {
		id: runnerModel

		appletInterface: plasmoid

		runners: [] // Empty = All runners.

		// deleteWhenEmpty: isDash
		// deleteWhenEmpty: false

		onRunnersChanged: debouncedRefresh.restart()
		onDataChanged: debouncedRefresh.restart()
		onCountChanged: debouncedRefresh.restart()
	}

	Timer {
		id: debouncedRefresh
		interval: 100
		onTriggered: resultModel.refresh()

		function logAndRestart() {
			// console.log('debouncedRefresh')
			restart()
		}
	}

	SearchResultsModel {
		id: resultModel
		onItemTriggered: {
			plasmoid.expanded = false
		}
	}

	function setQueryPrefix(prefix) {
		// First check to see if there's already a prefix we need to replace.
		var firstSpaceIndex = query.indexOf(' ')
		if (firstSpaceIndex > 0) {
			var firstToken = query.substring(0, firstSpaceIndex)

			if (/^type:\w+$/.exec(firstToken) // baloosearch
				|| /^define$/.exec(firstToken) // Dictionary
			) {
				// replace existing prefix
				query = prefix + query.substring(firstSpaceIndex + 1, query.length)
				return
			}
		}
		
		// If not, just prepend the prefix
		var newQuery = prefix + query
		if (newQuery != query) {
			query = prefix + query
		}
	}

	function clearQueryPrefix() {
		setQueryPrefix('')
	}
}
