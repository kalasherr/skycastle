extends Node2D

var player_current_health = 3
var player_coords

func _ready():
	G.player = self

func lose_hp():
	player_current_health -= 1
	print(player_current_health)

func init(coords):
	player_coords = coords
	position = coords * G.tile_size + Vector2(0,1)
