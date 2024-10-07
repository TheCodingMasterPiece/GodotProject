extends Node3D

@export var sensitivity := 5
var player
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = player.global_position
	$SpringArm3D/Camera3D.look_at(player.get_node("LookAt").global_position)
	pass


func _input(event):
	if event is InputEventMouseMotion and !Input.is_action_pressed("moveoff"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		var tempRot = rotation.x - event.relative.y / 1000  * sensitivity
		rotation.y -= event.relative.x / 1000  * sensitivity
		tempRot = clamp(tempRot, -1, 0.625)
		rotation.x = tempRot
	elif Input.is_action_pressed("moveoff"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
