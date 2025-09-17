extends Node2D

class_name Player

var player_coords
var max_hp = 3
var hp = 3
var curr_position = position
var money = 0
var current_shield = 0
var eye1_position = Vector2(-4,-5)
var eye2_position = Vector2(4,-5)

@onready var main_sprite = get_node("SpriteTree")

signal player_moved

func _process(delta):
	main_sprite.get_node("Eye1").position = eye1_position - Vector2(sign((global_position + eye1_position - get_global_mouse_position()).x),sign((global_position + eye1_position - get_global_mouse_position()).y)) / 2
	main_sprite.get_node("Eye2").position = eye2_position - Vector2(sign((global_position + eye2_position - get_global_mouse_position())).x,sign((global_position + eye2_position - get_global_mouse_position()).y)) / 2

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
	G.ASC.disable_cards()
	G.AC.disable_cards()
	G.GS.disable_buttons()
	
	self.player_coords = tile.tile_coords
	
	var start_pos = position
	var shadow_position = main_sprite.get_node("Shadow").position
	var end_pos = player_coords * G.tile_size + tile.get_player_offset()
	var f = func(x):
		return Vector2(0,sin(x * PI) * 50)
	var f_minus = func(x):
		return -Vector2(0,sin(x * PI) * 50) + start_pos * (1 - x) + end_pos * x
	var fm = func(x):
		return Vector2(1,1) * (1 - sin(x * PI))

	T.animate(main_sprite.get_node("Shadow"), "position", null, G.player_jump_time, f)
	T.animate(main_sprite.get_node("Shadow"), "scale", null, G.player_jump_time, fm)
	await T.animate(self, "position", null, G.player_jump_time, f_minus)

	main_sprite.get_node("Shadow").position = shadow_position
	main_sprite.get_node("Shadow").scale = Vector2(1,1)
	replace(player_coords * G.tile_size + tile.get_player_offset())
	await tile.on_enter()
	
	G.ASC.enable_cards()
	G.AC.enable_cards()

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
