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

signal player_spawned
