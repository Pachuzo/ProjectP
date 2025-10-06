extends TextureRect

var scroll_speed = 0.1
var offset = 0.0

func _process(delta):
	offset += scroll_speed * delta
	if offset > 1.0:
		offset -= 1.0

	var shader_material = material as ShaderMaterial
	if shader_material:
		shader_material.set_shader_parameter("offset", offset)
