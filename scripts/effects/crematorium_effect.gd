extends TileEffect

class_name CrematoriumEffect

func on_enter():
	G.GS.disable_buttons()
	var choice = CrematoriumChoice.new()
	G.GS.camera.add_child(choice)
	await choice.event_ended
	return
