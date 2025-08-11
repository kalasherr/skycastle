extends Node

var GS
var player
var tile_size = Vector2(64,64)

func _ready():
	pass

func rotate_array(array, rot):
	var arr = []
	for i in array:
		arr.append(i.rotated(deg_to_rad(rot)))
		arr[arr.size() - 1].x = sign(int(arr[arr.size() - 1].x))
		arr[arr.size() - 1].y = sign(int(arr[arr.size() - 1].y))
	return arr

func get_tile_pool():
	var dir = DirAccess.open("res://scenes/tiles")
	var arr = []
	for a in dir.get_files():
		arr.append(a)
	return arr
	
signal player_spawned
