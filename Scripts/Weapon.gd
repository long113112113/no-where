extends Node3D
@export var bullet_prefab : PackedScene
@export var root_node : Node3D
@export var shoot_position : Node3D
@export var shoot_rate : float
@export var shoot_timer : float
func _ready():
	pass 
func _process(delta):
	if shoot_timer < shoot_rate:
		shoot_timer += delta
	if Input.is_action_pressed("shoot") and shoot_timer >= shoot_rate:
		shoot_timer = 0.0
		var bullet = bullet_prefab.instantiate()
		root_node.add_child(bullet)
		bullet.global_position	 = shoot_position.global_position
		bullet.bullet_direction = -get_global_transform().basis.z
	pass
