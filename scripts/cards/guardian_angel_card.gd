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
	colors["value1"] = shield_amount
	return ["Guardian angel", "Start every stage with [color={defense}]{value1}[/color] shield bonus".format(colors)]
