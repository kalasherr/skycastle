extends SinCard

class_name GluttonyCard

func apply():
	add_stones()
	for tile in G.GS.tile_deck:
		if tile.effects_to_add.find("bandage") != -1:
			tile.effects_to_add.pop_at(tile.effects_to_add.find("bandage"))
			tile.add_effect("spikes", true)
	for tile in G.GS.current_deck:
		if tile.effects_to_add.find("bandage") != -1:
			tile.effects_to_add.pop_at(tile.effects_to_add.find("bandage"))
			tile.add_effect("spikes", true)
	for i in range(0, G.GS.board_size.x):
		for j in range(0,G.GS.board_size.y):
			if G.GS.get_tile(Vector2(i,j)):
				for effect in G.GS.get_tile(Vector2(i,j)).effects.get_children():
					if effect is BandageEffect:
						effect.destroy()
						G.GS.get_tile(Vector2(i,j)).add_effect("spikes", true)
	G.GS.next_turn()
	return
	
#translate
func get_text():
	return ["Gluttony", "Replace all bandages in your deck with spikes"]
