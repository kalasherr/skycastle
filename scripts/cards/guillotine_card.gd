extends Card

class_name GuillotineCard

func apply():
	var tile = RitualRoomTile.new()
	var moves = G.GS.get_tile_moves(tile)
	G.GS.add_tile_to_deck(tile, moves)	
	tile = TortureChamberTile.new()
	moves = G.GS.get_tile_moves(tile)
	G.GS.add_tile_to_deck(tile, moves)	
	tile = DungeonTile.new()
	moves = G.GS.get_tile_moves(tile)
	G.GS.add_tile_to_deck(tile, moves)	

func get_key():
	return "guillotine"