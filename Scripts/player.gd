extends CharacterBody3D

var SPEED = 5.0
var JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var lookat
var lastLookAtDirection : Vector3
func _ready():
	lookat = get_tree().get_nodes_in_group("CameraController")[0].get_node("LookAt")
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_pressed("sprint"):
		SPEED = 7.0
	elif !Input.is_action_pressed("sprint"):
		SPEED = 5.0
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if !Input.is_action_pressed("moveoff"):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			var lerpDirection = lerp(lastLookAtDirection, Vector3(lookat.global_position.x, global_position.y, lookat.global_position.z), 0.05)
			look_at(lerpDirection)
			lastLookAtDirection = lerpDirection
		elif Input.is_action_pressed("moveoff"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()