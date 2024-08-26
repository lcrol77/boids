extends Node2D


@export var NUM_BOIDS = 100
@export var max_vel = 50.0
var boid_pos = []
var boid_vel = []

func _ready() -> void:
	_generate_boids()
	for i in boid_pos.size():
		print("Boid: ", i, " pos: ", boid_pos[i], " vel: ", boid_vel[i])

func _process(delta: float) -> void:
	pass

func _generate_boids():
	for i in NUM_BOIDS:
		boid_pos.append(Vector2(randf() * get_viewport_rect().size.x, randf() * get_viewport_rect().size.y))
		boid_vel.append(Vector2(randf_range(-1.0,1.0) * max_vel, randf_range(-1.0,1.0) * max_vel))
