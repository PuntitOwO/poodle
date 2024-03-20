@tool
# 1. class name: uncomment and fill the class name
class_name Date
extends Resource

# 2. docs: use docstring (##) to generate docs for this file
## A date resource
##
## It stores a date as an integer and wraps the [Time] methods for using it

# 3. signals: define signals here

# 4. enums: define enums here

# 5. constants: define constants here

# 6. export variables: define all export variables in groups here
## The string of date value, in DD-MM-YYYY format
@export var date: String :
	get:
		var yyyymmdd := Time.get_date_string_from_unix_time(_date)
		return _reverse_date_format(yyyymmdd)
	set(value):
		var yyyymmdd := _reverse_date_format(value)
		_date = Time.get_unix_time_from_datetime_string(yyyymmdd)

# 7. public variables: define all public variables here

# 8. private variables: define all private variables here, use _ as preffix
var _date: int

# 9. onready variables: define all onready variables here

# 10. init virtual methods: define _init, _enter_tree and _ready mothods here
func _init():
	_date = Time.get_unix_time_from_system()

# 11. virtual methods: define other virtual methos here

# 12. public methods: define all public methods here

func serialize() -> int:
	return _date

# 13. private methods: define all private methods here, use _ as preffix
func _reverse_date_format(input:String) -> String:
	var elements := input.split("-")
	elements.reverse()
	return "{0}-{1}-{2}".format(elements)

# 14. subclasses: define all subclasses here

