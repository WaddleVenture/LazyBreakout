extends StaticBody2D
@onready var color_rect: ColorRect = $ColorRect
@export var player_data : MainResource 

var window_width : float 
var paddle_width : float
var paddle_height : float

func _ready() -> void:
	window_width = get_viewport_rect().size.x
	paddle_width = color_rect.size.x

	paddle_height = color_rect.size.y

func _process(delta: float) -> void:
	
	# Paddle movements
	if Input.is_action_pressed("ui_left"):
		position.x -= player_data.paddle_speed * delta
	elif Input.is_action_pressed("ui_right"):
		position.x += player_data.paddle_speed * delta
	
	# Limit paddle movement to window, StaticBodies can't interract with each other
	position.x = clamp(position.x, paddle_width / 2, window_width - paddle_width / 2)
