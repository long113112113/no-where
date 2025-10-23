extends CharacterBody3D

@export var SPEED = 7.0
@export var camera : Camera3D
@export var ROTATION_SPEED: float = 5.0
const JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

	var	mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_direction = ray_origin + camera.project_ray_normal(mouse_pos) * 500
	var ray_query = PhysicsRayQueryParameters3D.create(ray_origin, ray_direction)
	
	ray_query.exclude = [self]
	ray_query.collide_with_bodies = true
	var space_state = get_world_3d().direct_space_state
	var ray_result = space_state.intersect_ray(ray_query)
	
	if ray_result:
		var target_position = ray_result.position
		var target_transform = transform.looking_at(target_position, Vector3.UP)
		
		transform.basis = transform.basis.slerp(target_transform.basis, delta * ROTATION_SPEED)
