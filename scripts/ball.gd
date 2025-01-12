extends CharacterBody2D

# Exported variables
@export var player_data : MainResource
@onready var player: StaticBody2D = $"../Player"

# Constants
const START_SPEED : int = 500
const ACCELERATION : int = 15
const HORIZONTAL_ANGLE_LIMIT  : float = 0.6

# Variables
var window_size : Vector2
var speed : int 
var direction : Vector2
var is_new_ball : bool

# Initial setup
func _ready() -> void:
	window_size = get_viewport_rect().size

# Resets the ball
func new_ball() -> void:
	speed = 0
	position.y = player.position.y - (player.paddle_height / 2)
	direction =  Vector2(0,-1)
	is_new_ball = true


# Physics update - Ball movement and collision handling
func _physics_process(delta: float) -> void:
	# Starting behavior
	if is_new_ball: 
		position.x = player.position.x 
		if Input.is_action_pressed("ui_accept"):
			is_new_ball = false
			speed = START_SPEED

	# Collisions 
	var collision = move_and_collide(direction * speed * delta)
	if collision : 
		var collider = collision.get_collider()
		# Handle paddle collision
		if collider == player:
			direction = calculate_new_direction(collider)
		# Handle brick collision
		elif collider.is_in_group("Bricks"):
			direction = direction.bounce(collision.get_normal())
			speed += ACCELERATION
			collider.queue_free()
		# Handle wall collision (bounce off the wall)
		else:
			direction = direction.bounce(collision.get_normal())


# Calculate the new direction based on the paddle collision
func calculate_new_direction(collider: Node2D) -> Vector2:
	# Get the horizontal distance between the ball and the paddle
	var distance = position.x - collider.position.x
	
	# Flip the vertical direction
	var y = -sign(direction.y)
	
	# Adjust horizontal direction based on the distance
	var x = (distance / (collider.paddle_width / 2 )) * HORIZONTAL_ANGLE_LIMIT 

	return Vector2(x, y).normalized()
