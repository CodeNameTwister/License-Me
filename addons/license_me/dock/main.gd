## ~/CodeNameTwister $
#@icon("../icon.svg") #https://www.shareicon.net
@tool
extends PanelContainer
const PLUGIN := preload("../plugin.gd")
const user : String = "user://dev_license.cfg"

var plugin : PLUGIN = null

func manual_bake() -> void:
	var p : Popup = ($PopupPanel as Popup)
	p.popup_centered()

func get_data_settings(build_all_licenses : bool = true, build_internal_licenses : bool = true) -> Dictionary:
	var data_in : Dictionary = {
		"BUILD_ALL" : build_all_licenses,
		"GODOT_LICENSES" : build_internal_licenses
	}
	var cfg : ConfigFile = save(false)
	for x in cfg.get_section_keys(""):
		data_in[x] = cfg.get_value("", x, null)
	return data_in

func generate(path : String, build_all_licenses : bool = true, build_internal_licenses : bool = true) -> bool:
	if plugin == null:
		push_error("Error!, not plugin defined!")
		return false
	path = ProjectSettings.globalize_path(path)
	var file : FileAccess = FileAccess.open(path, FileAccess.WRITE)
	if null==file:
		push_error("Can not open file path selected!")
		return false
	var data_in : Dictionary = get_data_settings(build_all_licenses, build_internal_licenses)

	var license_me : RefCounted = plugin.license_me
	var data : String = license_me.run(data_in)
	if data.length() == 0 :
		file.close()
		push_error("Error on get data licenses!")
		return false
	file.store_string(data)
	file.close()
	return true

func _ready() -> void:
	$MC/VC/SC/VB/SC/GC/TYPE.text = ProjectSettings.get_setting("application/license/type", "COPYRIGHT")
	$MC/VC/SC/VB/SC/GC/PROJECT.text = ProjectSettings.get_setting("application/license/project_name", "My Project")
	$MC/VC/SC/VB/SC/GC/YEAR.text = str(ProjectSettings.get_setting("application/license/year", "2024"))
	$MC/VC/SC/VB/SC/GC/AUTHOR.text = ProjectSettings.get_setting("application/license/author", "Author")

	if FileAccess.file_exists(user):
		var cfg : ConfigFile = ConfigFile.new()
		if cfg.load(user) == OK:
			load_cfg(cfg)
	else:
		save()

func _t(o : Control, c : Color) -> void:
	o.modulate = c
	get_tree().create_tween().tween_property(o, "modulate", Color.WHITE, 0.5)

func set_licenses(l : PackedStringArray) -> void:
	$MC/VC/SC/VB/SC/GC/TYPE.on_set_licenses(l)

func load_cfg(cfg : ConfigFile) -> void:
	var setting : String = ""
	for z in [$MC/VC/SC/VB/SC/GC, $MC/VC/SC/VB/SC2/GC]:
		for x in z.get_children():
			if cfg.has_section_key(setting, x.name):
				if x is CheckBox:
					_t(x, Color.YELLOW)
					var boolean : bool = cfg.get_value(setting, x.name, true)
					x.button_pressed = boolean
				elif x is TextEdit or x is LineEdit:
					_t(x, Color.YELLOW)
					var data : String = str(cfg.get_value(setting, x.name, ""))
					x.text = data
				elif x is MenuButton:
					_t(x, Color.YELLOW)
					var type : String = cfg.get_value(setting, x.name, "Copyright")
					x.pressed_by_name(type)
	ProjectSettings.set_setting("application/license/type", $MC/VC/SC/VB/SC/GC/TYPE.text)
	ProjectSettings.set_setting("application/license/project_name", $MC/VC/SC/VB/SC/GC/PROJECT.text)
	ProjectSettings.set_setting("application/license/year", str($MC/VC/SC/VB/SC/GC/YEAR.text).to_int())
	ProjectSettings.set_setting("application/license/author", $MC/VC/SC/VB/SC/GC/AUTHOR.text)
	for gs in get_tree().get_nodes_in_group(&"GUI_SETTING"):
		gs.update()

func reset() -> void:
	if FileAccess.file_exists(user):
		var cfg : ConfigFile = ConfigFile.new()
		if cfg.load(user) == OK:
			load_cfg(cfg)
		else:
			push_error("Can not load License Me config!")
	else:
		push_warning("Not exist prevous saved License me config!")

func save(save_in_file : bool = true) -> ConfigFile:
	var cfg : ConfigFile = ConfigFile.new()
	for y in [$MC/VC/SC/VB/SC/GC, $MC/VC/SC/VB/SC2/GC]:
		for x in y.get_children():
			if x is CheckBox:
				_t(x, Color.CYAN)
				cfg.set_value("", x.name, x.button_pressed)
			elif x is TextEdit or x is LineEdit:
				_t(x, Color.CYAN)
				cfg.set_value("", x.name, x.text)
			elif x is MenuButton:
				_t(x, Color.CYAN)
				var index : int = -1
				var menu : PopupMenu = x.get_popup()
				for z : int in range(0,menu.item_count,1):
					if menu.is_item_checked(z):
						index = z
						break
				if index > -1:
					cfg.set_value("", x.name, menu.get_item_text(index))
	if save_in_file:
		ProjectSettings.set_setting("application/license/type", $MC/VC/SC/VB/SC/GC/TYPE.text)
		ProjectSettings.set_setting("application/license/project_name", $MC/VC/SC/VB/SC/GC/PROJECT.text)
		ProjectSettings.set_setting("application/license/year", $MC/VC/SC/VB/SC/GC/YEAR.text)
		ProjectSettings.set_setting("application/license/author", $MC/VC/SC/VB/SC/GC/AUTHOR.text)
		if !cfg.save(user) == OK:
			push_error("Can not save License Me config!")
	for gs in get_tree().get_nodes_in_group(&"GUI_SETTING"):
		gs.update()
	return cfg
