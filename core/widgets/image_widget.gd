class_name ImageWidget
extends Widget

const scene = preload("res://core/widgets/image_widget.tscn")

@export var entity: ImageEntity
var image: TextureRect

func init(properties: Dictionary) -> void:
	image = scene.instantiate()
	add_child(image)
	if properties.has("position"):
		position = properties["position"]
	if properties.has("size"):
		image.size = properties["size"]
	image.texture = ImageTexture.create_from_image(Image.load_from_file(entity.image_path))

func play(_duration: float) -> void:
	image.show()


func reset():
	image.hide()