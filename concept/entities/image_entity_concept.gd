extends Node2D

@export var resource: ImageEntity

# Called when the node enters the scene tree for the first time.
func _ready():
	_play()

func _play():
	var sprite: Sprite2D = Sprite2D.new()
	sprite.texture = ImageTexture.create_from_image(Image.load_from_file(resource.image_path))
	sprite.centered = false
	add_child(sprite)