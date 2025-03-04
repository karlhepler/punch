class_name Player
extends CharacterBody2D

@export var enemy: Player

func _ready() -> void:
	assert(enemy, 'enemy player missing')
	assert(enemy != self, 'player cannot be its own enemy')
	
func _process(_delta: float) -> void:
	look_at(enemy.global_position)
