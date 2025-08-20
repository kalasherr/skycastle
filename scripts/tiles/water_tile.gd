extends Tile

class_name WaterTile

func get_sprite():
	var sprite = load("res://sprites/tiles/water.png")
	var rot = 0
	return [sprite,rot]
