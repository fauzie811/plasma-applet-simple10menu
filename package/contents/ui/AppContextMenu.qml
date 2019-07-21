// Based off kicker's ActionMenu
import QtQuick 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: root

    property QtObject menu
    property Item visualParent
    property bool opened: menu ? (menu.status != PlasmaComponents.DialogStatus.Closed) : false

    signal closed
    signal populateMenu(var menu)

    onOpenedChanged: {
        if (!opened) {
            closed()
        }
    }

    onClosed: destroyMenu()

    function open(x, y) {
        refreshMenu()

        if (menu.content.length === 0) {
            return;
        }

        if (x && y) {
            menu.open(x, y);
        } else {
            menu.open();
        }
    }

    function destroyMenu() {
        if (menu) {
            menu.destroy()
            // menu = null // Don't null here. Binding loop: onOpended=false => closed() => destroyMenu() => menu=null => opened=false
            logger.debug('AppContextMenu.destroyMenu', menu)
        }
    }

    function refreshMenu() {
        destroyMenu()
        menu = contextMenuComponent.createObject(root);
        populateMenu(menu)
    }

    Component {
        id: contextMenuComponent

        PlasmaComponents.ContextMenu {
            id: contextMenu
            visualParent: root.visualParent

            function newSeperator() {
                return Qt.createQmlObject("import org.kde.plasma.components 2.0 as PlasmaComponents; PlasmaComponents.MenuItem { separator: true }", contextMenu);
            }
            function newMenuItem() {
                return Qt.createQmlObject("import org.kde.plasma.components 2.0 as PlasmaComponents; PlasmaComponents.MenuItem {}", contextMenu);
            }
    
            // // https://github.com/KDE/plasma-desktop/blob/master/applets/taskmanager/package/contents/ui/ContextMenu.qml#L75
            function addActionList(actionList, listModel, index) {
                // .desktop file Exec actions
                // ------
                // Pin to Taskbar / Desktop / Panel
                // ------
                // Recent Documents
                // ------
                // ...
                // ------
                // Edit Application
                actionList.forEach(function(actionItem) {
                    // console.log(index, actionItem.actionId, actionItem.actionArgument, actionItem.text)
                    var menuItem = menu.newMenuItem()
                    menuItem.text = actionItem.text ? actionItem.text : ""
                    menuItem.enabled = actionItem.type != "title" && ("enabled" in actionItem ? actionItem.enabled : true)
                    menuItem.separator = actionItem.type == "separator"
                    menuItem.section = actionItem.type == "title"
                    menuItem.icon = actionItem.icon ? actionItem.icon : null
                    menuItem.clicked.connect(function() {
                        listModel.triggerIndexAction(index, actionItem.actionId, actionItem.actionArgument)
                    });

                });
            }
        }
    }

    Component {
        id: contextMenuItemComponent

        PlasmaComponents.MenuItem {
            property variant actionItem

            text: actionItem.text ? actionItem.text : ""
            enabled: actionItem.type != "title" && ("enabled" in actionItem ? actionItem.enabled : true)
            separator: actionItem.type == "separator"
            section: actionItem.type == "title"
            icon: actionItem.icon ? actionItem.icon : null

            onClicked: {
                actionClicked(actionItem.actionId, actionItem.actionArgument);
            }
        }
    }
}
