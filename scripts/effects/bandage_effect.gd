extends TileEffect

class_name BandageEffect

func on_enter():
	if G.player.heal(1):
		for effect in bound_tile.tile_in_deck.effects_to_add:
			if effect == "bandage":
				bound_tile.tile_in_deck.effects_to_add.pop_at(bound_tile.tile_in_deck.effects_to_add.find(effect))
		queue_free()