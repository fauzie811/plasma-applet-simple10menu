import QtQuick 2.0
import org.kde.plasma.private.kicker 0.1 as Kicker

Kicker.FavoritesModel {
	// Kicker.FavoritesModel must be a child object of RootModel.
	// appEntry.actions() looks at the parent object for parent.appletInterface and will crash plasma if it can't find it.
	// https://github.com/KDE/plasma-desktop/blob/master/applets/kicker/plugin/appentry.cpp#L151
	id: kickerAppModel

	signal triggerIndex(int index)
	onTriggerIndex: {
		kickerAppModel.trigger(index, "", null)
		plasmoid.expanded = false
	}

	signal triggerIndexAction(int index, string actionId, string actionArgument)
	onTriggerIndexAction: {
		kickerAppModel.trigger(index, actionId, actionArgument)
		plasmoid.expanded = false
	}

	function indexHasActionList(i) {
		var modelIndex = kickerAppModel.index(i, 0)
		var hasActionList = kickerAppModel.data(modelIndex, Qt.UserRole + 8)
		return hasActionList
	}

	function getActionListAtIndex(i) {
		var modelIndex = kickerAppModel.index(i, 0)
		var actionList = kickerAppModel.data(modelIndex, Qt.UserRole + 9)
		return actionList
	}
}
