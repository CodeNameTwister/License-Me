## ~/CodeNameTwister $
@tool
extends CheckBox
@export var label : Label

var original : bool = false

func _ready() -> void:
	add_to_group(&"GUI_SETTING")
	original = button_pressed

func has_change() -> bool:
	if button_pressed != original:
		if label:
			label.text = str('*',label.text.trim_prefix('*'))
			label.modulate = Color.YELLOW
		return true
	if label:
		label.text = label.text.trim_prefix('*')
		label.modulate = Color.WHITE
	return false

func update() -> void:
	original = button_pressed
	has_change()


func _on_pressed() -> void:
	has_change()
