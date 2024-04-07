extends Panel

const THEME_KEY_PAUSED = "paused"
const THEME_KEY_PLAYING = "playing"

var _was_paused: bool = true;

@onready var playing_color = get_theme_color(THEME_KEY_PLAYING)
@onready var paused_color = get_theme_color(THEME_KEY_PAUSED)

func _process(_delta):
    var paused = get_tree().paused
    if paused != _was_paused:
        _was_paused = paused
        modulate = paused_color if paused else playing_color