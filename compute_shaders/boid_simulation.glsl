#[compute]
#version 450

layout(local_size_x = 1024, local_size_y = 1, local_size_z=1) in;

layout(set = 0, binding = 0, std430) restrict buffer Position{
    vec2 data[]
} boid_pos;

layout(set = 0, binding = 1, std430) restrict buffer Velocity{
    vec2 data[]
} boid_vel;


layout(set = 0, binding = 2, std430) restrict buffer Params{
    float num_boids;
    float image_size;
    float friend_radius;
    float avoid_radius;
    float min_vel;
    float max_vel;
    float alignment_factor;
    float cohesion_factor;
    float separation_factor;
    float viewport_x;
    float viewport_y;
    float delta_time;
} params;