extends Node

@onready var class_scene: ConceptClassScene = $ParseAndPlay
@onready var window: ConceptClassWindow = $ClassWindow

func _ready():
    _setup_scene()

func _setup_scene():
    print("Setting up scene")
    window.set_class_node(class_scene)
    class_scene.play()