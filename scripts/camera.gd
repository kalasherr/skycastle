extends Camera2D

var default_screen_rect = Vector2(1920,1080)
var game_time = 0.0
var default_next_position = G.tile_size / 2
@onready var hud_root = get_node("HUD")
@onready var hud_hp = hud_root.get_node("PlayerHP")
@onready var hud_money = hud_root.get_node("PlayerMoney")
@onready var hud_shield = hud_root.get_node("PlayerShield")
@onready var hud_deck_left = hud_root.get_node("DeckLeft")
@onready var hud_next_tile = hud_root.get_node("NextTileContainer/NextTile")

func _process(delta):
	game_time += get_process_delta_time()
	var max_scale = max(get_viewport().get_visible_rect().size.x / default_screen_rect.x * 2, get_viewport().get_visible_rect().size.y / default_screen_rect.y * 2)
	zoom.x = max_scale
	zoom.y = max_scale
	if G.GS.current_deck.size() < 3:
		hud_deck_left.modulate[1] = sin(game_time * 2)
		hud_deck_left.modulate[2] = sin(game_time * 2)
	else:
		hud_deck_left.modulate[1] = 1
		hud_deck_left.modulate[2] = 1

func set_hp(amount):
	hud_hp.text = str(amount)

func set_money(amount):
	hud_money.text = str(amount)

func set_shield(amount):
	hud_shield.text = str(amount)

func set_deck_left(amount):
	hud_deck_left.text = str(amount)

func set_next_tile(array, effects):
	if G.GS.game_phase == "player":
		var candle_tile = hud_next_tile.get_parent().get_node("CandleTile")
		if candle_tile:
			var f = func(x):
				return sin(x * PI / 2)
			hud_next_tile.texture = null
			T.tween(candle_tile, "global_position", default_next_position + candle_tile.get_parent().global_position, 0.2, f)
			await T.tween(candle_tile, "scale", Vector2(1,1), 0.2)
			candle_tile.position = Vector2(candle_tile.get_parent().get_node("NextTile").position.x + candle_tile.x_offset, 0)
			candle_tile.scale = candle_tile.default_scale
			var texture = array[0]
			var texture_rotation = array[1]
			var next = hud_next_tile
			
			next.texture = texture
			next.rotation = texture_rotation
			if array.size() == 3:
				next.position = default_next_position + array[2]
			else:
				next.position = default_next_position
			for child in next.get_node("Effects").get_children():
				child.queue_free()
			for effect in effects:
				next.get_node("Effects").add_child(Sprite2D.new())
				next.get_node("Effects").get_child(next.get_node("Effects").get_children().size() - 1).rotation = - next.rotation
				next.get_node("Effects").get_child(next.get_node("Effects").get_children().size() - 1).texture = effect
			hud_deck_left.text = "x" + str(G.GS.current_deck.size())
		else:
			var texture = array[0]
			var texture_rotation = array[1]
			var next = hud_next_tile
			next.texture = texture
			next.rotation = texture_rotation
			if array.size() == 3:
				next.position = default_next_position + array[2]
			else:
				next.position = default_next_position
			for child in next.get_node("Effects").get_children():
				child.queue_free()
			for effect in effects:
				next.get_node("Effects").add_child(Sprite2D.new())
				next.get_node("Effects").get_child(next.get_node("Effects").get_children().size() - 1).rotation = - next.rotation
				next.get_node("Effects").get_child(next.get_node("Effects").get_children().size() - 1).texture = effect
			hud_deck_left.text = "x" + str(G.GS.current_deck.size())
	

func play_tile_deploy(end_pos):
	var f = func(x):
		return sin(x * PI / 2)

	await T.tween(hud_next_tile, "global_position", end_pos, 0.5, f)
	
	hud_next_tile.global_position = end_pos
	hud_next_tile.texture = null
	hud_next_tile.position = default_next_position
	return
