extends Node2D

class_name Player

var player_current_health = 3
var player_coords
var max_hp = 3
var hp = 3
var curr_position = position

func _ready():
	G.player = self
	G.GS.player = self
	G.GS.change_hp(hp)

func lose_hp():
	hp -= 1

func heal(amount = 1):
	if hp + amount <= max_hp:
		hp += amount
		G.GS.change_hp(hp)
		return true
	return false
	
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
	hp -= 1
	G.GS.change_hp(hp)
	if hp == 0:
		G.GS.restart_game()
	else:
		for i in range(0,10):
			if self.modulate[3] != 0:
				self.modulate[3] = 0
			else:
				self.modulate[3] = 1
			await get_tree().create_timer(0.1).timeout
	
