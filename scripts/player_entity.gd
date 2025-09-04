extends Node2D

class_name Player

var player_coords
var max_hp = 3
var hp = 3
var curr_position = position
var money = 0
var current_shield = 0

signal player_moved

func _ready():
	G.player = self
	G.GS.player = self
	G.GS.update_hp(hp)
	G.emit_signal("player_spawned")

func lose_hp(amount = 1):
	hp -= amount
	G.GS.update_hp(hp)

func heal(amount = 1):
	if hp < max_hp:
		hp = min(amount + hp, max_hp)
		G.GS.update_hp(hp)
		return true
	return false
	
func replace(coords):
	curr_position = coords
	position = coords

func init(coords):
	G.player = self
	G.GS.player = self
	G.GS.update_money(money)
	G.GS.update_hp(hp)
	player_coords = coords
	replace(coords * G.tile_size + G.GS.get_tile(coords).get_player_offset())

func move(tile):
	G.GS.disable_buttons()
	self.player_coords = tile.tile_coords
	var start_pos = position
	var end_pos = player_coords * G.tile_size + tile.get_player_offset()
	var init_time = 0.7
	var curr_time = 0.0
	while curr_time < init_time:
		curr_time += get_process_delta_time() * G.animation_time_scale
		var pos = curr_time / init_time * end_pos + (1 - curr_time / init_time) * start_pos - Vector2(0,sin(curr_time / init_time * PI) * 50)
		replace(pos)
		await get_tree().process_frame
	replace(player_coords * G.tile_size + tile.get_player_offset())
	await tile.on_enter()
	emit_signal("player_moved")
	return

func take_damage(amount = 1):
	if current_shield > 0:
		current_shield -= amount
		G.GS.update_shield(current_shield)
	else:
		hp -= amount
		G.GS.update_hp(hp)
		if hp == 0:
			G.GS.restart_game()
		else:
			for i in range(0,10):
				if self.modulate[3] != 0:
					self.modulate[3] = 0
				else:
					self.modulate[3] = 1
				await get_tree().create_timer(0.1 / G.animation_time_scale).timeout
	
func update_money(amount):
	if money < -amount:
		money = 0
		G.GS.update_money(money)
		return true
	else:
		money += amount
		G.GS.update_money(money)
		return true

func get_shield(amount = 1):
	if current_shield >= -amount:
		current_shield += amount
	else:
		current_shield = 0
	G.GS.update_shield(current_shield)	

func reset():
	money = 0
	current_shield = 0
	hp = max_hp
	G.GS.update_money(money)
	G.GS.update_shield(current_shield)
	G.GS.update_hp(hp)
