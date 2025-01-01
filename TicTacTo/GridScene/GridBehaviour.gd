extends Node

@export var grid_sprite : Sprite2D

signal grid_set(grid_position)

enum GRID_STATE
{
	NEUTRAL = 0,
	PLAYER_X,
	PLAYER_O
}

var current_state : GRID_STATE = GRID_STATE.NEUTRAL
var set_position : Vector2i = Vector2i()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass # Replace with function body.
	current_state = GRID_STATE.NEUTRAL

func set_grid_state(isPlayerOne:bool):
	if(isPlayerOne):
		current_state = GRID_STATE.PLAYER_O
	else:
		current_state = GRID_STATE.PLAYER_X	
	
	$Sprite2D.frame = current_state
	$Button.hide()

func _on_pressed() -> void:
	if(current_state == GRID_STATE.NEUTRAL):
		#play sound, (depend on new state?)
		
		set_grid_state(BoardGlobals._player_one_turn)
		print("Change grid state at ", set_position, " to ", "X" if current_state==GRID_STATE.PLAYER_X else "O")
		grid_set.emit(set_position)
	else:
		print("Tried to change grid at ", self.position, " but it's already set")

func disable_button():
	$Button.hide()

func reset_grid():
	$Button.show()
	current_state = GRID_STATE.NEUTRAL
	$Sprite2D.frame = current_state
