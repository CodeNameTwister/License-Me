## ~/CodeNameTwister $
@tool
extends Button
var t : Tween = null
func _ready() -> void:
	text = tr(text).capitalize()

func _pressed() -> void:
	if owner.has_method(name):
		modulate = Color.GREEN
		if t and t.is_running():
			t.kill()
		t = get_tree().create_tween()
		t.tween_property(self, ^"modulate", Color.WHITE, 1.5)
		owner.call(name)
