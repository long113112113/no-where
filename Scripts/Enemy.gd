extends CharacterBody3D

@export var move_speed : float

@onready var navigation_agent := $NavigationAgent3D as NavigationAgent3D

var player : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("Player")
	if player == null:
		print("Enemy không tìm thấy node nào trong group 'Player'!")



func _physics_process(delta):
	if player == null:
		return
	navigation_agent.set_target_position(player.global_position)

	if navigation_agent.is_navigation_finished():
		velocity = Vector3.ZERO
		move_and_slide()
		return

	var next_path_pos = navigation_agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_pos)

	if direction:
		look_at(global_position + direction, Vector3.UP)

	velocity = direction * move_speed
	move_and_slide()
