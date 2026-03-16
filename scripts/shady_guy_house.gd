extends Node2D

var player
@onready var col_ladder_GB1_t: CollisionShape2D = $"ladders/ladder_G-B1/top/CollisionShape2D"
@onready var col_ladder_GB1_b: CollisionShape2D = $"ladders/ladder_G-B1/bottom/CollisionShape2D"

func _on_area_b_1_body_entered(body: Node2D) -> void:
	player = body
	if player.has_method("player"):	
		player.camera.limit_bottom = 113
		


func _on_area_b_2_body_entered(body: Node2D) -> void:
	player = body
	if player.has_method("player"):
		player.camera.limit_bottom = 208


func _on_area_b_3_body_entered(body: Node2D) -> void:
	player = body
	if player.has_method("player"):	
		player.camera.limit_bottom = 400





func _on_top1_body_entered(body: Node2D) -> void:
	player = body
	if player.has_method("player"):
		col_ladder_GB1_b.disabled = true
		player.global_position = Vector2(1680,86)
		col_ladder_GB1_t.disabled=true
		col_ladder_GB1_b.disabled= false


func _on_bottom1_body_entered(body: Node2D) -> void:
	player = body
	if player.has_method("player"):
		col_ladder_GB1_t.disabled=true
		player.global_position = Vector2(1680, 0)
		col_ladder_GB1_b.disabled= true
		col_ladder_GB1_t.disabled = false
