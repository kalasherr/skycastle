extends Node

var GS
var player
var tile_size = Vector2(64,64)
var animation_time_scale = 1

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

func get_card_pool():
	var dir = DirAccess.open("res://scenes/cards")
	var arr = []
	for a in dir.get_files():
		if a != "card.tscn":
			arr.append(a)
	return arr

func get_sin_card_pool():
	var dir = DirAccess.open("res://scenes/sin_cards")
	var arr = []
	for a in dir.get_files():
		if a != "sin_card.tscn":
			arr.append(a)
	return arr
	
signal player_spawned
