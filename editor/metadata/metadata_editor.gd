class_name MetadataEditor
extends Control

signal metadata_changed(metadata: ClassMetadata)

@export var metadata: ClassMetadata:
    set(value):
        metadata = value
        update()

func _ready():
    if is_instance_valid(metadata):
        update()
    %SaveButton.pressed.connect(save)

func on_class_index_changed(index: ClassIndex):
    metadata = index.metadata
    update.call_deferred()

## Update the editor to reflect the current metadata.
func update():
    # Class Info
    %Name.text = metadata.name
    %Description.text = metadata.description
    %Course.text = metadata.course
    # Author info
    %AuthorName.text = metadata.author_name
    %AuthorDescription.text = metadata.author_description
    # File info
    %Version.text = metadata.file_version
    %Date.text = metadata.date.date
    %License.text = metadata.license
    %Editor.text = metadata.editor_version

## Save the metadata to the resource.
func save():
    var new_metadata = ClassMetadata.new()
    # Class Info
    new_metadata.name = %Name.text
    new_metadata.description = %Description.text
    new_metadata.course = %Course.text
    # Author info
    new_metadata.author_name = %AuthorName.text
    new_metadata.author_description = %AuthorDescription.text
    # File info
    new_metadata.file_version = %Version.text
    var date = Date.new()
    date.date = %Date.text
    new_metadata.date = date
    new_metadata.license = %License.text
    new_metadata.editor_version = %Editor.text
    # Save
    metadata = new_metadata
    metadata_changed.emit(metadata)