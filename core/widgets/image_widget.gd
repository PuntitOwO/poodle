class_name ImageWidget
extends Widget

const scene = preload("res://core/widgets/image_widget.tscn")

@export var entity: ImageEntity
var image: TextureRect

func init(properties: Dictionary) -> void:
	if !zip_file.file_exists(entity.image_path):
		push_error("Image file not found: " + entity.image_path)
		return
	var data := zip_file.read_file(entity.image_path)
	var texture := _create_texture(data)
	image = scene.instantiate()
	add_child(image)
	if properties.has("position"):
		position = properties["position"]
	if properties.has("size"):
		image.size = properties["size"]
	image.texture = texture

func play(_duration: float) -> void:
	image.show()
	_emit_animation_finished()

func reset():
	image.hide()

func skip_to_end():
	image.show()

func _create_texture(data: PackedByteArray) -> Texture2D:
	var _image := Image.new()
	match entity.image_path.split(".")[-1]:
		"png": _image.load_png_from_buffer(data)
		"jpg": _image.load_jpg_from_buffer(data)
		"svg": _image.load_svg_from_buffer(data)
		"bmp": _image.load_bmp_from_buffer(data)
		_: push_error("Unsupported image format: " + entity.image_path.split(".")[-1])
	return ImageTexture.create_from_image(_image)
