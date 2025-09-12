extends Card

class_name HourglassCard

var counter = 0
func apply():
	for i in range(0,values["value1"]):
		var tile = MirrorChamberTile.new()
		var moves = G.GS.get_tile_moves(tile)
		G.GS.add_tile_to_deck(tile, moves)	
	G.GS.connect("previous_stage_ended", delete_chambers)

#translate
func get_text():
	values["value1"] = 3
	values["value2"] = 2
	return ["Hourglass", "[color={add}]Add[/color] {value1} mirror chambers to your deck. After {value2} stages deletes {value1} mirror chambers from your deck".format(values)]

func delete_chambers():
	if counter == values["value2"]:
		var deleted = 0
		var threshold = values["value1"]
		for tile in G.GS.tile_deck:
			if tile is MirrorChamberTile and deleted < threshold:
				deleted += 1
				G.GS.delete_tile(tile)
		print("deleted")
	else:
		counter += 1
		print(counter)
	return