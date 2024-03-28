extends Node2D

@export var resource: ImageEntity

var widget: Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	init()

func init():
	widget = Sprite2D.new()
	var image: Image = Image.load_from_file(resource.image_path)
	image.resize(300, 300)
	widget.texture = ImageTexture.create_from_image(image)
	widget.centered = false
	widget.hide()
	add_child(widget)

func play():
	widget.show()

func reset():
	widget.hide()