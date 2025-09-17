extends SinCard

class_name WrathCard

func apply():
	add_stones()
	for i in [-1,0,1]:
		for j in [-1,0,1]:
			if i != 0 or j != 0:
				var tile = G.GS.get_tile(G.player.player_coords + Vector2(i,j)) 
				if tile:
					if !(tile is CrownTile):
						await tile.add_effect("spikes", true)
						if tile.tile_moves != [] and tile.tile_in_deck :
							tile.tile_in_deck.add_effect("spikes")
	G.GS.next_turn()
	return

#translate
func get_text():
	return ["Wrath", "Add spikes on 8 tiles around player"]
