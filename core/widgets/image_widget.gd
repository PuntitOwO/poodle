class_name ImageWidget
extends Widget

@export var entity: ImageEntity
@onready var image: TextureRect = $Image

func init(properties: Dictionary) -> void:
	if properties.has("position"):
		position = properties["position"]
	if properties.has("size"):
		image.size = properties["size"]
	image.texture = ImageTexture.create_from_image(Image.load_from_file(entity.image_path))

func play(_duration: float) -> void:
	image.show()


func reset():
	image.hide()