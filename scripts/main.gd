extends Node2D

var NUM_BOIDS = 1000
@export_category("Boid Settings")
@export_range(0, 50) var friend_radius = 10.0
@export_range(0, 50) var avoid_radius = 5.0
@export_range(0,100) var min_vel = 50.0
@export_range(0,100) var max_vel = 75.0
@export_range(0,100) var alignment_factor = 10.0
@export_range(0,100) var cohesion_factor = 1.0
@export_range(0,100) var separation_factor = 20.0


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
	get_window().title = "Boids: " + str(NUM_BOIDS) + " / FPS: " + str(Engine.get_frames_per_second())
	_update_boids_cpu(delta)
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

func _update_boids_cpu(delta):
	for i in NUM_BOIDS:
		var my_pos: Vector2 = boid_pos[i]
		var my_vel: Vector2 = boid_vel[i]
		var avg_vel: Vector2 = Vector2.ZERO
		var midpoint: Vector2 = Vector2.ZERO
		var seperation_vec: Vector2 = Vector2.ZERO
		var num_friends: int = 0
		var num_avoids: int = 0
		for j in NUM_BOIDS:
			if i != j:
				var other_pos = boid_pos[j]
				var other_vel = boid_vel[j]
				var dist = my_pos.distance_to(other_pos)
				if dist < friend_radius:
					num_friends += 1
					avg_vel += other_vel
					midpoint += other_pos
					if dist< avoid_radius:
						num_avoids += 1
						seperation_vec += my_pos -other_pos
		if num_friends > 0:
			avg_vel /= num_friends
			my_vel += avg_vel.normalized() * alignment_factor
			midpoint /= num_friends
			my_vel += (midpoint - my_pos).normalized() * cohesion_factor
			if num_avoids > 0:
				my_vel += seperation_vec.normalized() * separation_factor
		var vel_mag = my_vel.length()
		vel_mag = clamp(vel_mag, min_vel, max_vel)
		my_vel = my_vel.normalized() * vel_mag
		my_pos += my_vel * delta
		my_pos = Vector2(wrapf(my_pos.x, 0,  get_viewport_rect().size.x),
						 wrapf(my_pos.y, 0,  get_viewport_rect().size.y))
		boid_pos[i] = my_pos
		boid_vel[i] = my_vel
