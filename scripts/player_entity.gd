extends Node2D

var player_current_health = 3
var player_coords
var hp = 3
var curr_position = position

func _ready():
	G.player = self
	G.GS.player = self
	G.GS.change_hp(hp)

func lose_hp():
	player_current_health -= 1

func replace(coords):
	curr_position = coords
	position = coords

func init(coords):
	G.player = self
	G.GS.player = self
	G.GS.change_hp(hp)
	player_coords = coords
	replace(coords * G.tile_size + G.GS.get_tile(coords).get_player_offset())

func move(tile):
	self.player_coords = tile.tile_coords
	replace(player_coords * G.tile_size + tile.get_player_offset())
	tile.on_enter()

func take_damage(amount):
	for i in range(0,10):
		if self.modulate[3] != 0:
			self.modulate[3] = 0
		else:
			self.modulate[3] = 1
		await get_tree().create_timer(0.1).timeout
	hp -= 1
	G.GS.change_hp(hp)
