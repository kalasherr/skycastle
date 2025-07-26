extends Node2D

var player_current_health = 3
var player_coords
var hp = 3

func _ready():
	G.player = self
	G.GS.player = self
	G.GS.change_hp(hp)

func lose_hp():
	player_current_health -= 1
	print(player_current_health)

func init(coords):
	player_coords = coords
	position = coords * G.tile_size + Vector2(0,1)

func move(tile):
	self.player_coords = tile.tile_coords
	self.position = player_coords * G.tile_size + Vector2(0,1)
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