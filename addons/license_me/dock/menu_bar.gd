## ~/CodeNameTwister $
@tool
extends MenuButton
@export var label : Label
var original : String = ""

func _ready() -> void:
	text = text.capitalize()
	var popup_menu : PopupMenu = get_popup()
	popup_menu.id_pressed.connect(pressed)

	add_to_group(&"GUI_SETTING")
	original = text

func on_set_licenses(licenses : PackedStringArray) -> void:
	var popup_menu : PopupMenu = get_popup()

	popup_menu.clear()
	var setting : String = str(ProjectSettings.get_setting("application/license/type", "COPYRIGHT"))
	for id : int in range(0, licenses.size(), 1):
		var txt : String = licenses[id]
		popup_menu.add_item(txt.to_upper(), id)
		if txt == setting:
			#popup_menu.set_item_checked(id, true)
			pressed(id)


func pressed_by_name(id : String) -> void:
	var popup_menu : PopupMenu = get_popup()
	for x : int in range(0, popup_menu.item_count, 1):
		if id == popup_menu.get_item_text(x):
			pressed(x)
			return


func pressed(id : int) -> void:
	var popup_menu : PopupMenu = get_popup()
	for x : int in range(popup_menu.item_count):
		popup_menu.set_item_checked(x, false)
	popup_menu.set_item_checked(id, true)
	var new_text : String = popup_menu.get_item_text(id).capitalize().to_upper()
	var _disabled : bool = true
	if new_text == "COPYRIGHT":
		_disabled = false
	#_disable_control(get_parent(), get_index() + 1, _disabled)
	_disable_control($"../../../SC2/GC", 0, _disabled)
	text = new_text
	has_change()

func _disable_control(root : Node, start : int, _disabled : bool) -> void:
	var childs : Array[Node] = root.get_children()
	for z : int in range(start, childs.size(), 1):
		var x : Control = childs[z]
		if x == null:continue
		if x is CheckBox:
			x.disabled = _disabled
		elif x is TextEdit:
			x.editable = !_disabled
		else:
			if _disabled:
				x.self_modulate = Color.GRAY
			else:
				x.self_modulate = Color.WHITE


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
