import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import ".."
import "../lib"

ColumnLayout {
	id: page

	ConfigBase64JsonString {
		id: exportData
		Layout.fillHeight: true

		property var ignoredKeys: [
			'searchResultsReversed',
			'searchResultsCustomSort',
		]
		
		defaultValue: {
			var data = {}
			var configKeyList = plasmoid.configuration.keys()
			for (var i = 0; i < configKeyList.length; i++) {
				var configKey = configKeyList[i]
				var configValue = plasmoid.configuration[configKey]
				if (typeof configValue === "undefined") {
					continue
				}
				if (ignoredKeys.indexOf(configKey) >= 0) {
					continue
				}
				data[configKey] = configValue
			}
			return data
		}

		function serialize() {
			var newValue = parseText(textArea.text)
			var configKeyList = plasmoid.configuration.keys()
			for (var i = 0; i < configKeyList.length; i++) {
				var configKey = configKeyList[i]
				var propValue = newValue[configKey]
				if (typeof propValue === "undefined") {
					continue
				}
				if (ignoredKeys.indexOf(configKey) >= 0) {
					continue
				}
				if (plasmoid.configuration[configKey] != propValue) {
					plasmoid.configuration[configKey] = propValue
				}
			}
		}
	}

}
