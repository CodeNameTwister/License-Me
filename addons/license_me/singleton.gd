## ~/CodeNameTwister $
@icon("icon.svg") #https://www.shareicon.net
extends Node
func _ready() -> void:
	#region credits
	##CREDITS LINKS
	#	Godot		https://godotengine.org/license/
	#	Authors		https://github.com/godotengine/godot/blob/master/AUTHORS.md
	#	Thirdparty	https://github.com/godotengine/godot/blob/master/COPYRIGHT.txt
	#endregion

	#COPYRIGHT_NOTICE
	var author_project : String = ProjectSettings.get_setting("application/license/author", "DevGame")
	var main_project : String = ProjectSettings.get_setting("application/license/project_name", "Game Project")
	var type : String = ProjectSettings.get_setting("application/license/type", "COPYRIGHT")
	var year : String = str(ProjectSettings.get_setting("application/license/year", "2024"))
	if type == "COPYRIGHT":
		author_project = ("Copyright (c) {0} {1}, {2}. All rights reserved.").format([year, author_project, main_project, type.to_upper()])
	elif type == "UNLICENSE":
		author_project = "Copyright (c) {0} {1}. {2} is unlicensed.".format([year, author_project, main_project, type.to_upper()])
	else:
		author_project = "Copyright (c) {0} {1}. {2} is under {3} license.".format([year, author_project, main_project, type.to_upper()])
	#ENGINE_NOTICE
	author_project = str(author_project, '\n\n===== ENGINE LICENSE =====\n(Disclaimer: This project uses an engine with its own independent license)\n\n{0}'.format([Engine.get_license_text()]))

	print(author_project)
	call_deferred(&"queue_free")
