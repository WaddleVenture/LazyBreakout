extends Node2D

@onready var ball: CharacterBody2D = $Ball
@onready var life: Label = $HUD/Life
@onready var game_over: Label = $HUD/GameOver
@onready var death_timer: Timer = $DeathTimer

const BRICK = preload("res://scenes/brick.tscn")

func _ready() -> void:
	ball.new_ball()
	
	var start_x = 80
	var start_y = 100
	var spacing_x = 165
	var spacing_y = 50

	for i in range(7):
		for j in range(4):
			var brick_instance = BRICK.instantiate()
			brick_instance.position = Vector2(start_x + i * spacing_x, start_y + j * spacing_y)
			add_child(brick_instance)
			brick_instance.add_to_group("Bricks")

func _process(_delta: float) -> void:
	if get_tree().get_nodes_in_group("Bricks").size() == 0:
		get_tree().reload_current_scene()


func _on_killzone_body_entered(_body: Node2D) -> void:
	life.text = str(int(life.text) - 1)
	if int(life.text) > 0 :
		ball.new_ball()
	else:
		death_timer.start()
		game_over.visible = true
		


func _on_death_timer_timeout() -> void:
	get_tree().reload_current_scene()
