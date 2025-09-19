extends Card

class_name GuardianAngelCard

var shield_amount = 1

func init():
	G.GS.connect("next_stage_started", get_shield)
	default_init()

func get_shield():
	G.player.get_shield(shield_amount)

func get_key():
	return "guardian_angel"

func set_values():
	values.value1 = shield_amount