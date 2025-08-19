extends Card

class_name GuardianAngelCard

var shield_amount = 1

func init():
	G.GS.connect("next_stage_started", get_shield)
	default_init()

func apply():
	return

func get_shield():
	G.player.get_shield(shield_amount)

#translate
func get_text():
	return ["Guardian angel", "Start every stage with {0} shield bonus".format([shield_amount])]
