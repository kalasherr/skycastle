extends Card

class_name CandleCard

func apply():
	G.GS.camera.hud_next_tile.get_parent().add_child(CandleTile.new())

#translate
func get_text():
	return ["Candle", "Shows you one more next tile".format(values)]
