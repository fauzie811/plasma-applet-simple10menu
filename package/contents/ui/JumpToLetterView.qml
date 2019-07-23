import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import org.kde.plasma.components 2.0 as PlasmaComponents

JumpToSectionView {
	id: jumpToLetterView

	onUpdate: {
		var sections = []
		for (var i = 0; i < appsModel.allAppsModel.count; i++) {
			var app = appsModel.allAppsModel.get(i)
			var section = app.sectionKey
			if (sections.indexOf(section) == -1) {
				sections.push(section)
			}
		}
		availableSections = sections

		sections = presetSections.slice() // shallow copy
		for (var i = 0; i < availableSections.length; i++) {
			var section = availableSections[i]
			if (sections.indexOf(section) == -1) {
				sections.push(section)
			}
		}
		allSections = sections
		// console.log('jumpToLetterView.update.allSections', allSections)
	}

	presetSections: [
		appsModel.recentAppsSectionKey,
		'&',
		'0-9',
		'A', 'B', 'C', 'D', 'E', 'F',
		'G', 'H', 'I', 'J', 'K', 'L',
		'M', 'N', 'O', 'P', 'Q', 'R',
		'S', 'T', 'U', 'V', 'W', 'X',
		'Y', 'Z',
	]
}
