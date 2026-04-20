extends Node3D

enum {IDLE, ALERT}

var state = IDLE
var player: Node3D
var fire_timer: float = 0.0

@export var bullet_scene: PackedScene
@export var fire_rate: float = 2.0
@export var bullet_speed: float = 40.0

@onready var raycast = $RayCast3D
@onready var muzzle = $Muzzle

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
				fire_timer = 0.0
				print("Sniper: ALERT!")
		ALERT:
			if not can_see_player():
				state = IDLE
				print("Sniper: Player lost, go back to IDLE")
				return
			fire_timer -= _delta
			if fire_timer <= 0.0:
				shoot()
				fire_timer = fire_rate

func can_see_player() -> bool:
	if not raycast.is_colliding():
		return false
	return raycast.get_collider() == player

func shoot() -> void:
	if not bullet_scene:
		push_warning("Sniper: No bullet_scene assigned!")
		return
	
	var head = player.get_node_or_null("Head")
	if not head:
		return
	
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = muzzle.global_position
	
	var velocity = calculate_ballistic_velocity(muzzle.global_position, head.global_position, bullet_speed)
	bullet.linear_velocity = velocity
	print("Sniper: Fired!")

func calculate_ballistic_velocity(from: Vector3, to: Vector3, speed: float) -> Vector3:
	var gravity = abs(ProjectSettings.get_setting("physics/3d/default_gravity"))
	var diff = to - from
	var horizontal = Vector3(diff.x, 0, diff.z)
	var h_dist = horizontal.length()
	var v_dist = diff.y
	
	var speed_sq = speed * speed
	var discriminant = speed_sq * speed_sq - gravity * (gravity * h_dist * h_dist + 2 * v_dist * speed_sq)
	
	if discriminant < 0:
		# Out of range — fall back to a straight shot
		return (to - from).normalized() * speed
	
	var angle = atan2(speed_sq - sqrt(discriminant), gravity * h_dist)
	var h_dir = horizontal.normalized()
	return h_dir * speed * cos(angle) + Vector3.UP * speed * sin(angle)
