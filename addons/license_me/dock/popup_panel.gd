## ~/CodeNameTwister $
@tool
extends PopupPanel

func _process_file() -> void:
	var dialog : FileDialog = $MC/VB/FileDialog
	dialog.popup_centered()

func close() -> void:
	hide()

func text() -> void:
	_process_file()

func github() -> void:
	push_warning("NOT SUPPORTED!")

func _generate(path : String) -> bool:
	if owner.has_method("generate"):
		return owner.call("generate", path, $MC/VB/HB/build_all.button_pressed, $MC/VB/HB/godot_licenses.button_pressed)
	return false

func _on_file_dialog_dir_selected(dir: String) -> void:
	$MC/VB/FileDialog.hide()
	if DirAccess.dir_exists_absolute(dir):
		var file : String = $"../MC/VC/SC/VB/SC/GC/FILE_NAME".text
		var ext : String = $"../MC/VC/SC/VB/SC/GC/FILE_EXTENSION".text
		if file.length() == 0:
			file = "_license_"
		if ext.length() == 0:
			ext = "uc"

		dir = dir.path_join(str(file, ".", ext))
		if _generate(dir):
			$MC/VB/SC/Selected.text = str("EXPORTED AT: ", dir)
		else:
			$MC/VB/SC/Selected.text = "Error on create file!"


func _on_file_dialog_file_selected(path: String) -> void:
	$MC/VB/FileDialog.hide()
	if DirAccess.dir_exists_absolute(path):
		if _generate(path):
			$MC/VB/SC/Selected.text = str("EXPORTED AT: ", path)
		else:
			$MC/VB/SC/Selected.text = "Error on create file!"
