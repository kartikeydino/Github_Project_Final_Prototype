extends Area2D

# NEW: Define how much damage the killzone deals
@export var damage_amount: int = 5

func _on_body_entered(body):
	# Check if the body has the 'player' function, and now, the 'take_damage' function
	if body.has_method("player"):
		# Check if the player has the new damage handling function
		if body.has_method("take_damage"):
			# Deal damage to the player
			body.take_damage(damage_amount)
		else:
			# Fallback: If player doesn't have the take_damage function (old version),
			# reload the scene (original logic).
			get_tree().reload_current_scene()
			variables.death_count += 1
			variables.levels_discovered = 1
