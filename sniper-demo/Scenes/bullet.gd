extends RigidBody3D

@export var damage: int = 25
@export var lifetime: float = 5.0

func _ready() -> void:
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(_delta: float) -> void:
	# Point the bullet along its current velocity
	if linear_velocity.length() > 0.1:
		look_at(global_position + linear_velocity)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		print("Hit")
	queue_free()
