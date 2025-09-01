extends Camera2D

var default_screen_rect = Vector2(1920,1080)

func _process(delta):
	var max_scale = min(get_viewport().get_visible_rect().size.x / default_screen_rect.x * 2, get_viewport().get_visible_rect().size.y / default_screen_rect.y * 2)
	zoom.x = max_scale
	zoom.y = max_scale
	
