extends Area2D


func _on_body_entered(body):
	if body.has_method("player"):
		get_tree().reload_current_scene()
