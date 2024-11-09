## ~/CodeNameTwister $
@icon("../icon.svg") #https://www.shareicon.net
extends PanelContainer
signal close_triggered()

@export var tree : Tree
@export var text : TextEdit

const LICENSE_ME : Resource = preload("res://addons/license_me/licence_me.gd")
var plugin : LICENSE_ME = null

var info : Dictionary = {}

func close() -> void:
	if OS.is_debug_build():
		print(name, " > signal: close_triggered be called! ")
	close_triggered.emit()

func _ready() -> void:
	assert(tree != null and text != null)
	tree.item_selected.connect(on_selected)
	update()

func _built_in_license(c : Dictionary) -> Array:
	var licenses : PackedStringArray = []
	var subout : String = str("Name: ", c["name"])
	for p in c["parts"]:
		subout += '\n'
		if p.has("files"):
			var files : String = ""
			for f in p["files"]:
				files += "\n" + f
			if files.length() > 0:
				subout += str("\nFiles: ", files.strip_edges() ,"\n")
		if p.has("comments"):
			subout += str("\nComments: ", p["comments"] ,"\n")
		if p.has("copyright"):
			var cp : String = ""
			for cc in p["copyright"]:
				cp += str("\n", cc)
			if cp.length() > 0:
				cp = "Copyright: " + cp.strip_edges()
				subout += cp
		var license : String = p["license"]
		if license.length() > 0:
			subout += str("\nLicense: ", license.strip_edges())
		else:
			subout += str("\nLicense: Unlicense")
		licenses.append(license)
	return [subout, licenses]

func on_selected() -> void:
	var meta : String = (tree.get_selected().get_metadata(0))
	if info["LICENSES"].has(meta):
		text.text = str(info["LICENSES"][meta])
	elif meta.begins_with("IN_BUILT_LICENSES/"):
		meta = meta.trim_prefix("IN_BUILT_LICENSES/")
		if meta == "DISCLAIMER":
			text.text = info["IN_BUILT_LICENSES"][meta]
			return
		var in_built : Dictionary = info["IN_BUILT_LICENSES"]
		meta = str(meta).replace("__","/")
		if in_built.has(meta):
			var data : Array = _built_in_license(in_built[meta])
			text.text = data[0]
			for d in data[1]:
				var s : String = str(d)
				for license in s.split(" "):
					if info["IN_BUILT_LICENSES_INFO"].has(license):
						text.text += "\n\n--------------------------------------------\nLICENSE: {0}\n\n{1}".format([license.to_upper(),info["IN_BUILT_LICENSES_INFO"][license]])

func _create(trees : Dictionary, root : TreeItem, k : String) -> void:
	var last_key : String = ""
	var last_tree : TreeItem = root
	var split : PackedStringArray = k.split("/")
	for s in split:
		last_key = last_key.path_join(s)
		if !trees.has(last_key):
			var new_tree : TreeItem = tree.create_item(last_tree)
			trees[last_key] = new_tree
			new_tree.set_text(0, str(s).capitalize())
			new_tree.set_selectable(0, false)
		last_tree = trees[last_key]
	last_tree.set_metadata(0, k)
	last_tree.set_selectable(0, true)
	last_tree.set_custom_color(0, Color.WHITE)

func update() -> void:
	if plugin == null:
		plugin = LICENSE_ME.new()
	info.clear()
	info = plugin.run_as_dict()

	#var project : String = str(ProjectSettings.get_setting("application/license/project_name", ProjectSettings.get_setting("application/config/name"))).to_camel_case().to_upper()

	var trees : Dictionary = {}
	var root : TreeItem = tree.create_item()
	root.set_text(0, "LICENSES LIST")
	root.set_selectable(0, false)
	root.set_custom_color(0, Color.DARK_GRAY)

	if info.has("LICENSES"):
		var keys : Array = info["LICENSES"].keys()

		for k in ["BASE_LICENSES", "THIRDPARTY_LICENSES"]:
			var di : int = keys.find(str(k,"/DISCLAIMER"))
			if di > -1:
				keys.remove_at(di)
		for k in keys:
			_create(trees, root, k)
#
		if trees.has("BASE_LICENSES"):
			var Libs : TreeItem = trees["BASE_LICENSES"]
			Libs.set_selectable(0, true)
			Libs.set_custom_color(0, Color.LIGHT_GRAY)
			Libs.set_metadata(0,"BASE_LICENSES/DISCLAIMER")
	#
		if trees.has("THIRDPARTY_LICENSES"):
			var Libs : TreeItem = trees["THIRDPARTY_LICENSES"]
			Libs.set_selectable(0, true)
			Libs.set_custom_color(0, Color.LIGHT_GRAY)
			Libs.set_metadata(0,"THIRDPARTY_LICENSES/DISCLAIMER")

	if info.has("IN_BUILT_LICENSES"):
		var in_built : Dictionary = info["IN_BUILT_LICENSES"]

		var keys : Array = in_built.keys()
		var di : int = keys.find("DISCLAIMER")
		if di > -1:
			keys.remove_at(di)

		for k in keys:
			k = str(k).replace("/", "__")
			_create(trees, root, str("IN_BUILT_LICENSES/",k))

		if trees.has("IN_BUILT_LICENSES"):
			var thirdparty_Libs : TreeItem = trees["IN_BUILT_LICENSES"]
			thirdparty_Libs.set_selectable(0, true)
			thirdparty_Libs.set_custom_color(0, Color.LIGHT_GRAY)
			thirdparty_Libs.set_metadata(0,"IN_BUILT_LICENSES/DISCLAIMER")



func __tree(tree : Tree, root : TreeItem, data : Dictionary, token : Variant) -> void:
	for k in data.keys():
		var key : String = str(k)
		var variant : Variant = data[k]
		var new_root : TreeItem = tree.create_item(root)
		new_root.set_text(0, key)
		if variant is Dictionary:
			new_root.set_selectable(0, false)
			__tree(tree, new_root, variant, k)
		elif variant is String:
			new_root.set_metadata(0, str(token).path_join(key))
