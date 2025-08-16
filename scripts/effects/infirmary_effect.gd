extends TileEffect

func on_enter():
	var to_pick = []
	for tile in get_parent().get_parent().get_parent().get_children():
		if tile.get_node("Effects").get_children() == [] and tile != self and tile.tile_in_deck and tile.tile_moves.size() > 0:
			to_pick.append(tile)
	for i in range(0, min(2, to_pick.size() - 1)):
		var tile = to_pick.pick_random()
		to_pick.pop_at(to_pick.find(tile))
		tile.add_effect("bandage", true)
		tile.tile_in_deck.add_effect("bandage")
	queue_free()
