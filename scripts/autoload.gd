extends Node

var max_jumps = 1

var death_count = 0
var talked = false

var levels_discovered: int = 1
var player_speed: int = 230
var player_health: int = 100
var player_position

signal player_pos_reset
