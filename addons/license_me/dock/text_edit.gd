## ~/CodeNameTwister $
@tool
extends TextEdit
@export var label : Label

var original : String = ""

func _ready() -> void:
	add_to_group(&"GUI_SETTING")
	original = text

func has_change() -> bool:
	if text != original:
		if label:
			label.text = str('*',label.text.trim_prefix('*'))
			label.modulate = Color.YELLOW
		return true
	if label:
		label.text = label.text.trim_prefix('*')
		label.modulate = Color.WHITE
	return false

func update() -> void:
	original = text
	has_change()

func _on_pressed() -> void:
	has_change()
