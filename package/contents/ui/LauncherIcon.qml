import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.draganddrop 2.0 as DragAndDrop

MouseArea {
	id: launcherIcon

	Layout.minimumWidth: {
		switch (plasmoid.formFactor) {
		case PlasmaCore.Types.Vertical:
			return 0;
		case PlasmaCore.Types.Horizontal:
			return height * (plasmoid.configuration.widePanelButton ? 1.2 : 1);
		default:
			return units.gridUnit * 3;
		}
	}

	Layout.minimumHeight: {
		switch (plasmoid.formFactor) {
		case PlasmaCore.Types.Vertical:
			return width * (plasmoid.configuration.widePanelButton ? 1.2 : 1);
		case PlasmaCore.Types.Horizontal:
			return 0;
		default:
			return units.gridUnit * 3;
		}
	}

	property int iconSize: plasmoid.configuration.fixedPanelIcon ? units.iconSizeHints.panel : Math.min(width, height)
	property alias iconSource: icon.source

	PlasmaCore.IconItem {
		id: icon
		anchors.centerIn: parent
		source: "start-here-kde"
		width: launcherIcon.iconSize
		height: launcherIcon.iconSize
		active: launcherIcon.containsMouse
		smooth: true
	}
	
	// Debugging
	// Rectangle { anchors.fill: parent; border.color: "#ff0"; color: "transparent"; border.width: 1; }
	// Rectangle { anchors.fill: icon; border.color: "#f00"; color: "transparent"; border.width: 1; }


	hoverEnabled: true
	// cursorShape: Qt.PointingHandCursor

	onClicked: {
		plasmoid.expanded = !plasmoid.expanded
	}

	property alias activateOnDrag: dropArea.enabled
	DragAndDrop.DropArea {
		id: dropArea
		anchors.fill: parent

		onDragEnter: {
			dragHoverTimer.restart()
		}
	}

	onContainsMouseChanged: {
		if (!containsMouse) {
			dragHoverTimer.stop()
		}
	}

	Timer {
		id: dragHoverTimer
		interval: 250 // Same as taskmanager's activationTimer in MouseHandler.qml
		onTriggered: plasmoid.expanded = true
	}
}
