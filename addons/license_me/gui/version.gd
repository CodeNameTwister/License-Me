## ~/CodeNameTwister $
extends Label
func _ready() -> void:
	var sc : String = (get_script() as Script).resource_path.get_base_dir()
	sc = sc.path_join("../plugin.cfg")
	if FileAccess.file_exists(sc):
		var cfg : ConfigFile = ConfigFile.new()
		cfg.load(sc)
		text = "License Me V{0}".format([str(cfg.get_value("plugin","version", "1.0"))])
