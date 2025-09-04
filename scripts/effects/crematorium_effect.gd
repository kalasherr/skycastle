extends TileEffect

class_name CrematoriumEffect

func on_enter():
	G.GS.disable_buttons()
	var choice = CrematoriumChoice.new()
	G.GS.camera.add_child(choice)
	await choice.event_ended
	bound_tile.main_sprite.texture = load("res://sprites/tiles/crematorium_unfired.png")
	self.queue_free()
	return
