## ~/CodeNameTwister $
@tool
extends LineEdit
@export var label : Label

var original : String = ""

func _ready() -> void:
	add_to_group(&"GUI_SETTING")
	original = text

	text_changed.connect(_on_change)

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

func _on_change(s : String) -> void:
	has_change()
