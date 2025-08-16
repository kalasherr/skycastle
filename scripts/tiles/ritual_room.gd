extends Tile

class_name RitualRoomTile

var smokes = []

func get_sprite():
	var sprite
	var rot = 0
	sprite = load("res://sprites/tiles/ritual_room.png")
	return [sprite,rot]

func get_spawn_priority():
	return 1
