extends AnimatedSprite2D

class_name EffectSpawn

func _ready():
	connect("frame_changed", change)

func change():
	if frame == 5:
		get_parent().get_node("Sprite").visible = true
	if frame == 9:
		queue_free()
