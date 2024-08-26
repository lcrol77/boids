extends Node2D

@export var NUM_BOIDS = 100
@export var max_vel = 50.0
var boid_pos = []
var boid_vel = []

var IMAGE_SIZE = int(ceil(sqrt(NUM_BOIDS)))
var boid_data : Image
var boid_data_texture : ImageTexture

func _ready() -> void:
	_generate_boids()
	for i in boid_pos.size():
		print("Boid: ", i, " pos: ", boid_pos[i], " vel: ", boid_vel[i])
	boid_data = Image.create(IMAGE_SIZE, IMAGE_SIZE, false, Image.FORMAT_RGBAH)
	boid_data_texture = ImageTexture.create_from_image(boid_data)
	$BoidParticles.amount = NUM_BOIDS
	$BoidParticles.process_material.set_shader_parameter("boid_data", boid_data_texture)
func _process(delta: float) -> void:
	_update_data_texture()

func _generate_boids() -> void:
	for i in NUM_BOIDS:
		boid_pos.append(Vector2(randf() * get_viewport_rect().size.x, randf() * get_viewport_rect().size.y))
		boid_vel.append(Vector2(randf_range(-1.0,1.0) * max_vel, randf_range(-1.0,1.0) * max_vel))

func _update_data_texture() -> void:
	for i in NUM_BOIDS:
		var pixel_pos = Vector2(int(i % IMAGE_SIZE), int(i / float(IMAGE_SIZE)))
		boid_data.set_pixel(pixel_pos.x, pixel_pos.y, Color(boid_pos[i].x,boid_pos[i].y,boid_vel[i].angle(),0))
	
	boid_data_texture.update(boid_data)
