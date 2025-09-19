extends Card

class_name CandleCard

func apply():
	G.GS.camera.hud_next_tile.get_parent().add_child(CandleTile.new())

func get_key():
	return "candle"