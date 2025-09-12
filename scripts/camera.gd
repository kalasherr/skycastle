extends Camera2D

var default_screen_rect = Vector2(1920,1080)
var game_time = 0.0
func _process(delta):
	game_time += get_process_delta_time()
	var max_scale = max(get_viewport().get_visible_rect().size.x / default_screen_rect.x * 2, get_viewport().get_visible_rect().size.y / default_screen_rect.y * 2)
	zoom.x = max_scale
	zoom.y = max_scale
	if G.GS.current_deck.size() < 3:
		get_node("DeckLeft").modulate[1] = sin(game_time * 2)
		get_node("DeckLeft").modulate[2] = sin(game_time * 2)
	else:
		get_node("DeckLeft").modulate[1] = 1
		get_node("DeckLeft").modulate[2] = 1
