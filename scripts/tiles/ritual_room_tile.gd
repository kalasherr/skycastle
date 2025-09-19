extends Tile

class_name RitualRoomTile

var smokes = []

func get_sprite():
	var sprite
	var rot = 0
	sprite = load("res://sprites/tiles/ritual_room.png")
	return [sprite,rot, offset]

func get_spawn_priority():
	return 1

func destroy(flag = ""):
	if !is_destroying:
		await default_destroy()
		self.tile_coords = Vector2(10000,10000)
		queue_free()
		G.GS.get_node("Stuff/SmokeManager").refresh_smokes()

func get_key():
	return "ritual_room"