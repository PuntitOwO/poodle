class_name ClassScriptCodeEdit
extends CodeEdit

## A [CodeEdit] that is used to edit the script of a class.

func _ready():
    var highlighter = syntax_highlighter as CodeHighlighter
    highlighter.add_color_region("=", "", Color(0.0, 0.55, 0.0, 1.0))
    highlighter.add_color_region("==", "", Color(0.0, 0.75, 0.0, 1.0))
    highlighter.add_color_region("#", "", Color(0.0, 0.0, 0.55, 1.0))
    highlighter.add_color_region("##", "", Color(0.0, 0.0, 0.75, 1.0))