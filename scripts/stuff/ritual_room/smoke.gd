extends Sprite2D

class_name RitualSmoke

var coords = Vector2(0,0)
var rel_coords = Vector2(0,0)
var spawn_time = 0.3

func _ready():
	self.z_index = 2
	self.position = coords * G.tile_size
	self.texture = load("res://sprites/effects/smoke_effect.png")
	self.modulate[3] = 0
	init()

func init():
	await T.tween(self, "modulate", Color(1,1,1,1), spawn_time)
	self.modulate[3] = 1
		
func destroy():
	await T.tween(self, "modulate", Color(1,1,1,0), spawn_time)
	self.modulate[3] = 0
	queue_free()

func hide_smoke():
	await T.tween(self, "modulate", Color(1,1,1,0), spawn_time)
	self.modulate[3] = 0

func show_smoke():
	await T.tween(self, "modulate", Color(1,1,1,1), spawn_time)
	self.modulate[3] = 1
