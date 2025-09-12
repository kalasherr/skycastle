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

#translate
func get_text():
	return ["Guillotine", "[color={add}]Add[/color] torture chamber, dungeon and ritual room to your deck".format(values)]

func get_illustration():
	return "res://sprites/cards/guillotine_card.png"