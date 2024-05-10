@tool
class_name SwitcherContainer
extends TabContainer

## SwitcherContainer is a Container that can be used to switch between two different views.
## It shows one of the two views at a time, and provides a way to switch between them.

@export var show_second: bool = false:
    set(value):
        show_second = value
        current_tab = 1 if value else 0

func _ready():
    current_tab = 1 if show_second else 0
    tabs_visible = false
    add_theme_stylebox_override("panel", StyleBoxEmpty.new())