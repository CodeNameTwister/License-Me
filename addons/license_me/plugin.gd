## ~/CodeNameTwister $
@tool
extends EditorPlugin
const RES : Resource = preload("licence_me.gd")
const DOCK : Resource = preload("dock/main.tscn")

const DELETE_SETTINGS_ON_EXIT : bool = true

var singleton : bool = false
var license_me : RefCounted = null
var dock : Control = null

func _get_licenses(base_path : String = "res://addons/license_me/") -> PackedStringArray:
	var out : PackedStringArray = []
	var path : String = base_path.path_join("licenses/")
	var dir := DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name := dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				if file_name.get_extension() == "uc":
					out.append(file_name.trim_suffix(".uc").to_upper())
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return out

func _on_change() -> void:
	enable_print_in_console(ProjectSettings.get_setting("application/license/print_engine_license_in_console", false))

func _enter_tree() -> void:
	var licenses_files : PackedStringArray = _get_licenses((get_script() as Script).resource_path.get_base_dir())
	var save : bool = false
	var license : RefCounted = null
	if not ProjectSettings.has_setting("application/license/project_name"):
		var pj : String = ProjectSettings.get_setting("application/config/name")
		ProjectSettings.set_setting("application/license/project_name", pj)
		ProjectSettings.set_order("application/license/project_name", 0)
		ProjectSettings.set_initial_value("application/license/project_name", "My Awsome Project")
		var property_info : Dictionary = {
			"name": "application/license/project_name",
			"type": TYPE_STRING
		}
		ProjectSettings.set_as_basic("application/license/project_name", true)
		ProjectSettings.add_property_info(property_info)
		save = true

	if not ProjectSettings.has_setting("application/license/author"):
		var user : String = ProjectSettings.get_setting("application/config/name")
		if OS.has_environment("USERNAME"):
			user = OS.get_environment("USERNAME")
		ProjectSettings.set_setting("application/license/author", user)
		ProjectSettings.set_initial_value("application/license/author", user)
		ProjectSettings.set_order("application/license/author", 1)
		var property_info : Dictionary = {
			"name": "application/license/author",
			"type": TYPE_STRING,
		}
		ProjectSettings.set_as_basic("application/license/author", true)
		ProjectSettings.add_property_info(property_info)
		save = true

	if not ProjectSettings.has_setting("application/license/year"):
		var year : Variant = Time.get_datetime_dict_from_system()["year"]
		ProjectSettings.set_setting("application/license/year", year)
		ProjectSettings.set_initial_value("application/license/year", year)
		ProjectSettings.set_order("application/license/year", 2)
		var property_info : Dictionary = {
			"name": "application/license/year",
			"type": TYPE_INT,
		}
		ProjectSettings.set_as_basic("application/license/year", true)
		ProjectSettings.add_property_info(property_info)
		save = true

	if not ProjectSettings.has_setting("application/license/type"):
		ProjectSettings.set_setting("application/license/type", "COPYRIGHT")
		ProjectSettings.set_initial_value("application/license/type", "COPYRIGHT")
		ProjectSettings.set_order("application/license/type", 3)
		var property_info : Dictionary = {
			"name": "application/license/type",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": ",".join(licenses_files)
		}
		ProjectSettings.set_as_basic("application/license/type", true)
		ProjectSettings.add_property_info(property_info)
		save = true

	if not ProjectSettings.has_setting("application/license/print_engine_license_in_console"):
		ProjectSettings.set_setting("application/license/print_engine_license_in_console", false)
		ProjectSettings.set_initial_value("application/license/print_engine_license_in_console", false)
		ProjectSettings.set_order("application/license/print_engine_license_in_console", 4)
		var property_info : Dictionary = {
			"name": "application/license/print_engine_license_in_console",
			"type": TYPE_BOOL
		}
		ProjectSettings.set_as_basic("application/license/print_engine_license_in_console", true)
		ProjectSettings.add_property_info(property_info)
		save = true

	if FileAccess.file_exists("user://editor_license.cfg"):
		var cfg : ConfigFile = ConfigFile.new()
		if cfg.load("user://license_me.cfg") == OK:
			for stg : String in ["application/license/author", "application/license/year", "application/license/type", "application/license/print_engine_license_in_console"]:
				if cfg.has_section_key("", stg):
					var value : Variant = cfg.get_value("", stg, null)
					if null != value:
						ProjectSettings.set_setting(stg, value)
						save = true
		cfg = null

	if save:
		ProjectSettings.save()
	ProjectSettings.settings_changed.connect(_on_change)

	dock = DOCK.instantiate()
	license_me = RES.new()
	license = license_me.get_export()
	dock.name = "License Me"
	dock.plugin = self
	dock.set_licenses(licenses_files)
	license.settings = dock
	add_export_plugin(license)
	add_control_to_dock(EditorPlugin. DOCK_SLOT_LEFT_BR , dock)

	enable_print_in_console(ProjectSettings.get_setting("application/license/print_engine_license_in_console"))

func enable_print_in_console(e : bool) -> void:
	if e != singleton:
		if e:
			add_autoload_singleton("LicenseMe", (get_script() as Script).resource_path.get_base_dir().path_join("singleton.gd"))
		else:
			remove_autoload_singleton("LicenseMe")
	singleton = e


func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		var cfg : ConfigFile = null
		for stg : String in ["application/license/author", "application/license/project_name", "application/license/year", "application/license/type", "application/license/print_engine_license_in_console"]:
			if ProjectSettings.has_setting(stg):
				if cfg == null:
					cfg = ConfigFile.new()
				cfg.set_value("", stg, ProjectSettings.get_setting(stg))
		if null != cfg:
			if cfg.save("user://license_me.cfg") != OK:
				push_warning("Error on save license me config!")
			cfg = null

func _exit_tree() -> void:
	ProjectSettings.settings_changed.disconnect(_on_change)
	enable_print_in_console(false)
	if is_instance_valid(license_me):
		remove_export_plugin(license_me.get_export())
	if is_instance_valid(dock):dock.free()
	if !DELETE_SETTINGS_ON_EXIT:return
	for stg : String in ["application/license/author", "application/license/project_name", "application/license/year", "application/license/type", "application/license/print_engine_license_in_console"]:
		if ProjectSettings.has_setting(stg):
			ProjectSettings.set_setting(stg, null)
