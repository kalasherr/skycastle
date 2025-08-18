extends Card

class_name CandleCard

func apply():
	G.GS.camera.add_child(CandleTile.new())

#translate
func get_text():
	return ["Candle", "Shows you one more next tile"]