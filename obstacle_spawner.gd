extends Node2D

# Cargamos dos escenas diferentes de obstáculos:
# - obstacle_scene: la escena del "rayo" (Thunder)
# - flame_obstacle: la escena de la "llama" (Flame)
@export var obstacle_scene : PackedScene     # Obstacle.tscn (rayo)
@export var flame_obstacle : PackedScene     # FlameObstacle.tscn (llama)

# Tiempo entre la aparición de cada obstáculo (en segundos)
@export var spawn_interval = 1.0

# Temporizador interno para contar el tiempo entre spawns
var timer = 2.0

func _process(delta):
	# Reducimos el temporizador cada frame
	timer -= delta



	# Si se acabó el tiempo, generamos un nuevo obstáculo
	if timer <= 0:
		spawn_obstacle()
		timer = spawn_interval  # Reiniciamos el temporizador

func spawn_obstacle():
	var screen_size = get_viewport_rect().size  # Tamaño de la pantalla actual

	# Decidimos aleatoriamente si vamos a crear una llama o un rayo
	var is_flame = randi() % 2 == 0  # 50% de probabilidad

	var obstacle  # Aquí guardaremos el obstáculo instanciado

	if is_flame:
		# Si se elige llama, instanciamos la escena correspondiente
		obstacle = flame_obstacle.instantiate()

		# 🔥 Posicionamos la llama fija en el "suelo"
		# Se puede ajustar el valor 'y' si el sprite queda muy arriba o muy abajo
		obstacle.position = Vector2(screen_size.x + 150, screen_size.y - 50)
		# Rebote aleatorio entre 10 y 100 píxeles de altura
		obstacle.bounce_amplitude = randf_range(10.0, 100.0)
	else:
		# Si se elige rayo, instanciamos la escena de rayos
		obstacle = obstacle_scene.instantiate()

		# ⚡ Posicionamos el rayo en una altura aleatoria dentro del rango visible (menos 50 píxeles de margen)
		obstacle.position = Vector2(
			screen_size.x + 150,
			randf_range(50, screen_size.y - 200)
		)

	# Finalmente, agregamos el obstáculo a la escena principal (el padre del spawner)
	get_parent().add_child(obstacle)
