class_name ImageWidget
extends Widget

@export var entity: ImageEntity
@onready var image: TextureRect = $Image

func _ready():
	init()

func init() -> void:
	# TODO: add size handling
	image.texture = ImageTexture.create_from_image(Image.load_from_file(entity.image_path))

func play(_duration: float) -> void:
	image.show()


func reset():
	image.hide()