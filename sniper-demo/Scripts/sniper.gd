extends Node3D

enum {IDLE, ALERT}

var state = IDLE
var player: Node3D

@onready var raycast = $RayCast3D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	if player:
		print("Sniper: Successfully found 'Player' node")
	else:
		print("Sniper: No node found in 'Player' group")

func _process(_delta: float) -> void:
	if not player:
		return
	
	var head = player.get_node_or_null("Head")
	if head:
		raycast.look_at(head.global_position)
		raycast.force_raycast_update()
		
	match state:
		IDLE:
			if can_see_player():
				state = ALERT
				print("Sniper: ALERT!")
		ALERT:
			if not can_see_player():
				state = IDLE
				print("Sniper: Player lost, go back to IDLE")

func can_see_player() -> bool:
	if not raycast.is_colliding():
		return false
	return raycast.get_collider() == player
