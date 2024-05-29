class_name ModProperties
extends Resource

## This class is used to store properties of a mod.
## 
## It is used to store the mod's name, version, and what scenes it adds to the player and the editor.

## The unique name of the mod.
@export var unique_name: String = ""

## The displayed name of the mod.
@export var display_name: String = ""

## The version of the mod.
@export var version: String = ""

@export_multiline var description: String = ""

## The types of content the mod adds. It is primarily used as display content.
## This is a bitmask of the following values:
## * Core [1]: Adds core content, like new Entities, Widgets or Groups.
## * Player [2]: Adds content to the player scene in the form of new tabs in the mod panel.
## * Editor [4]: Adds content to the editor scene in the form of new tabs.
## * Custom [8]: Adds custom content, everything that doesn't fit in the other categories.
@export_flags("Core", "Player", "Editor", "Custom") var types := 0

## The scenes the mod adds to the player.
## The root node of each scene should be a Control node.
@export var player_scenes: Array[PackedScene] = []

## The scenes the mod adds to the editor.
## The root node of each scene should be a Control node.
@export var editor_scenes: Array[PackedScene] = []
