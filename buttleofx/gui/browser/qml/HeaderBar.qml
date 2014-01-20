import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

import ButtleFileModel 1.0


Rectangle {
    id: headerBar
    color : "#141414"

    property string folder
    signal changeFolder(string folder)
    property string parentFolder

    Keys.onPressed: {
         if ((event.key == Qt.Key_L) && (event.modifiers & Qt.ControlModifier)) {
            texteditPath.focus = true
        }
    }

    FileModelBrowser {
        id: suggestion

        folder: headerBar.folder
    }

    RowLayout {
        spacing: 10
        anchors.fill: parent

        Image {
			id: previous;
            source: "../../img/buttons/browser/previous.png"
            sourceSize.height: 40

            MouseArea {
				anchors.fill: parent
                onClicked: {
                    console.debug("Undo")
                }
			}
		}
        Image {
			id: next
            source: "../../img/buttons/browser/next.png"
            sourceSize.height: 40

            MouseArea {
				anchors.fill: parent
                onClicked: console.log("Redo")
			}
		}
        Image {
			id: folder
            source: "../../img/buttons/browser/Folder-icon.png"
            sourceSize.height: 40

            MouseArea {
				anchors.fill: parent
                onClicked: {
                    changeFolder(parentFolder)
                }
			}
		}

        Rectangle {
            id: textEditContainer

            Layout.fillHeight: true
            Layout.fillWidth: true

            color: "black"
            border.color: "grey"
            radius: 5

            TextInput {
                id : texteditPath
                y: 10
                x: 5
                height: parent.height
                width: parent.width

                text: headerBar.folder

                color: suggestion.exists ? "white" : "red"
                selectByMouse: true

                selectionColor: "blue"

                onAccepted: {
                    changeFolder(text)
                    textEditContainer.forceActiveFocus()
                }
                onFocusChanged:{
                    texteditPath.focus ? selectAll() : deselect()
                }
                onTextChanged: {
                    suggestion.folder = texteditPath.getText(0, texteditPath.cursorPosition + 1)
                }
                onCursorPositionChanged: {
                    suggestion.folder = texteditPath.getText(0, texteditPath.cursorPosition + 1)
                }

                Keys.onTabPressed: {
                    suggestionsMenu.show()
                    texteditPath.forceActiveFocus()
                }
            }

            Menu {
                id: suggestionsMenu
                // __minimumWidth: textEditContainer.width
                // __xOffset: -13  // don't know how to remove icon space on menuItems
                // __yOffset: 0
                __visualItem: textEditContainer
                // style: __style.__popupStyle  //__style.__dropDownStyle

                // property ExclusiveGroup eg: ExclusiveGroup { id: eg }

                Instantiator {
                    model: suggestion.getFilteredFileItems(suggestion.folder)

                    MenuItem {
                        id: textComponent
                        text: model.object.fileName
                        onTriggered: changeFolder(model.object.filepath)
                        // checkable: true
                        // exclusiveGroup: eg
                    }
                    onObjectAdded: suggestionsMenu.insertItem(index, object)
                    onObjectRemoved: suggestionsMenu.removeItem(object)
                }
                function show() {
                    // Retrieve position of last "/" instead of cursorRectangle.x
                    var index = suggestion.folder.lastIndexOf("/")
                    var x = 0
                    if( index != -1 )
                    {
                        var rect = texteditPath.positionToRectangle(index)
                        x = rect.x
                    }
                    var y = texteditPath.height
                    suggestionsMenu.__popup(x, y)
                }
            }
        }

	}

}
