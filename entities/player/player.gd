class_name Player extends CharacterBody2D

const MOVE_LEFT = "move_left"
const MOVE_RIGHT = "move_right"
const MOVE_UP = "move_up"
const MOVE_DOWN = "move_down"

const SPEED = 1000.0

# Configuration ----------------------------------------------------------------
@export var enemy: Player

@export_group("Input Map", "input_")
@export var input_move_left: Array[InputEvent]:
	set(val): _map_input_action(MOVE_LEFT, val)
@export var input_move_right: Array[InputEvent]:
	set(val): _map_input_action(MOVE_RIGHT, val)
@export var input_move_up: Array[InputEvent]:
	set(val): _map_input_action(MOVE_UP, val)
@export var input_move_down: Array[InputEvent]:
	set(val): _map_input_action(MOVE_DOWN, val)
	
# Dependencies -----------------------------------------------------------------
@onready var slap_area: Area2D = $SlapArea

# Built-In Methods -------------------------------------------------------------
func _ready() -> void:
	assert(enemy, 'enemy player missing')
	assert(enemy != self, 'player cannot be its own enemy')
	
func _physics_process(_delta: float) -> void:
	look_at(enemy.global_position)
	
	var direction = _get_input_vector(MOVE_LEFT, MOVE_RIGHT, MOVE_UP, MOVE_DOWN)
	velocity = direction * SPEED
	
	var overlapping_bodies = slap_area.get_overlapping_bodies()
	print(overlapping_bodies) # TODO: use collision layers/masks for this
	
	move_and_slide()

# Private Methods --------------------------------------------------------------

## Maps the given action to a set of input events such that
## it is specific to this instance id.
func _map_input_action(input_action: String, input_events: Array[InputEvent]) -> void:
	var action = _get_input_action(input_action)
	if InputMap.has_action(action):
		InputMap.action_erase_events(action)
	else:
		InputMap.add_action(action)
	for event in input_events:
		InputMap.action_add_event(action, event)

## Converts the given action into an action
## that is specific to this instance id.
func _get_input_action(action: String) -> String:
	return "%d_%s" % [get_instance_id(), action]

## Wraps Input.get_vector with calls to _get_input_action.
func _get_input_vector(negative_x: String, positive_x: String, negative_y: String, positive_y: String, deadzone: float = -1.0) -> Vector2:
	return Input.get_vector(
		_get_input_action(negative_x),
		_get_input_action(positive_x),
		_get_input_action(negative_y),
		_get_input_action(positive_y),
		deadzone
	)
