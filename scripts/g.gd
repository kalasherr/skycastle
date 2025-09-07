extends Node

var GS
var player
var CM
var SCM
var ASC
var AC
var CONSOLE

var tile_size = Vector2(64,64)
var animation_time_scale = 1
var tile_destroy_time = 0.3
var tile_shake_time = 0.3
var card_apply_time = 0.8
var player_jump_time = 0.5

signal player_spawned

func _ready():
	get_parent().add_child.call_deferred(DevConsole.new())

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
	

