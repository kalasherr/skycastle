extends TileEffect

class_name MonasticCellEffect

func on_enter():
	G.GS.disable_buttons()
	var choice = MonasticCellChoice.new()
	G.GS.camera.add_child(choice)
	await choice.event_ended
	queue_free()
	return
	
