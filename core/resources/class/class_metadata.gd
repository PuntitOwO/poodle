class_name ClassMetadata
extends Resource

## Metadata of a class
##
## It contains data of the class, like name, description and course.
## It also contains the name and description of the author.
## Lastly, it contains data of the class file, like version, date and license.

## Class name
@export var name: String
## A brief description of the class
@export_multiline var description: String
## Course name and code
@export var course: String

@export_group("Author", "author_")
## Author(s) name(s)
@export var author_name: String
## Author(s) description, here you can put a contact link and a profile page
@export_multiline var author_description: String

@export_group("File")
## The file version, it should increase with every new release
@export var file_version: String
## Date of the last file modification
@export var date: Date
## Relative path to license file
@export var license: String
## Version of the editor used to create or modify the file
@export var editor_version: String
