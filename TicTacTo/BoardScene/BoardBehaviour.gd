extends Node

#@export var grid_size_x : int = 32
#@export var grid_size_y : int = 32 
#@export var grid_scale : int = 2
@export var board_pos_offset_x : int = 0
@export var board_pos_offset_y : int = 0
@export var grid_pos_offset_x : int = 0
@export var grid_pos_offset_y : int = 0

var game_board_grids = []
var grid_scene = preload("res://TicTacTo/GridScene/GridSquare.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_create_board()
	reset_board()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func switch_player(grid_position):
	#check if current player has won
	if(_check_if_won(grid_position)):
		#if so, show end game box
		#Play victory sound
		$WinSound.play()
		var new_label = String( "O has won!" if BoardGlobals._player_one_turn else "X has won!")
		print(new_label)
		$ProgressLabel.text = new_label
		_stop_game()
		$Button.show()
	else:
		#if no one has won, check for free grids
		if(_still_has_free_grids()):
			#if so, switch turns
			BoardGlobals._player_one_turn = !BoardGlobals._player_one_turn
			$ProgressLabel.text = "O" if BoardGlobals._player_one_turn else "X"
			$ClickSound.play()
		else:
			#otherwise, end game with no winner
			#play draw sound
			$DrawSound.play()
			var new_label = String( "It's a draw!")
			print(new_label)
			$ProgressLabel.text = new_label
			_stop_game()
			$Button.show()

func _create_board():
	#create the tiktok board
	for y in range(3):
		game_board_grids.append([])
		for x in range(3):
			var new_grid = grid_scene.instantiate()
			$CanvasGroup.add_child(new_grid)
			var new_pos_x = 0 + (x * grid_pos_offset_x ) + board_pos_offset_x #(grid_scale * grid_size_x - 1)) )
			var new_pos_y = 0 + (y * grid_pos_offset_y ) + board_pos_offset_y #(grid_scale * grid_size_y - 1)) )
			new_grid.position = Vector2(new_pos_x,new_pos_y)
			new_grid.grid_set.connect(switch_player)
			new_grid.set_position = Vector2i(x,y)
			game_board_grids[y].append(new_grid)

func reset_board():
	for grid_row in game_board_grids:
		for grid in grid_row:
			grid.reset_grid()
	
	BoardGlobals._player_one_turn = true
	$ProgressLabel.text = "O"
	$Button.hide()

func _check_if_won(grid_position):
	var grid_state = game_board_grids[grid_position.y][grid_position.x].current_state
	
	#check if state is invalid
	if(grid_state == 0):
		print("Grid at ",grid_position, " has invalild state of ", grid_state)
		return false
	
	#check verticals
	if(	game_board_grids[grid_position.y][0].current_state == grid_state and 
		game_board_grids[grid_position.y][1].current_state == grid_state and
		game_board_grids[grid_position.y][2].current_state == grid_state):
			return true
	#check horizontals
	elif(	game_board_grids[0][grid_position.x].current_state == grid_state and 
			game_board_grids[1][grid_position.x].current_state == grid_state and
			game_board_grids[2][grid_position.x].current_state == grid_state):
				return true
	#check diagonals if the grid is in valid positions
	elif(	grid_position.x == grid_position.y or 
			grid_position.x + grid_position.y == 2 ):
				if(	 game_board_grids[1][1].current_state == grid_state and
					(game_board_grids[0][0].current_state == grid_state and game_board_grids[2][2].current_state == grid_state) or 
					(game_board_grids[2][0].current_state == grid_state and game_board_grids[0][2].current_state == grid_state)):
						return true
	else:
		return false

func _still_has_free_grids() -> bool:
	for row in game_board_grids:
		for grid in row:
			if(grid.current_state == 0):
				return true
	
	return false

func _stop_game():
	for grid_row in game_board_grids:
		for grid in grid_row:
			grid.disable_button()

func _on_button_pressed() -> void:
	reset_board()
