extends Node2D

func _ready():
    play()

func play():
    await get_tree().create_timer(3.0).timeout
    var duration: float = $AudioWidget.get_duration()
    $AudioWidget.play(duration)
    $ImageWidget.play(duration)
    $LineWidget.play(duration)