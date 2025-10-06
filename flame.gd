extends Area2D  # El obstáculo extiende Area2D para detectar colisiones con el jugador.

@export var speed = 600              # Velocidad horizontal a la que la llama se mueve hacia la izquierda (px/seg).
@export var bounce_amplitude = 60.0  # Altura del bote en píxeles (cuánto sube y baja).
@export var bounce_speed = 5.0       # Velocidad del bote (qué tan rápido sube y baja).

@onready var animated_sprite = $flame  # Referencia al sprite animado de la llama.

var base_y = 5.0      # Guarda la posición vertical inicial del nodo (para mantenerla como referencia).
var bounce_time = 0.0 # Acumulador de tiempo para controlar la oscilación vertical con sin().

func _ready():
	# Inicia la animación "burn" de la llama (debe estar creada en el AnimatedSprite2D).
	animated_sprite.play("burn")
	
	# Conecta la señal 'body_entered' a la función local que la maneja.
	connect("body_entered", Callable(self, "_on_body_entered"))

	# Guarda la posición Y inicial de la llama (donde aparece en pantalla).
	base_y = position.y

func _physics_process(delta):
	# Movimiento horizontal constante hacia la izquierda (como si la pantalla avanzara).
	position.x -= speed * delta

	# Aumenta el contador de tiempo con el paso del frame.
	bounce_time += delta

	# Calcula la nueva posición Y con una función seno para simular el bote.
	# Se suma a la base_y para que el movimiento sea relativo a su posición original.
	position.y = base_y + sin(bounce_time * bounce_speed) * bounce_amplitude

	# Detecta si el obstáculo ya salió completamente de la pantalla hacia la izquierda.
	var sprite_width = animated_sprite.sprite_frames.get_frame_texture("burn", 0).get_width()
	if position.x < -sprite_width - 250:
		# Si ya no se ve, se elimina para no gastar memoria.
		queue_free()

func _on_body_entered(body):
	# Esta función se llama cuando otro cuerpo (como el jugador) entra en contacto con el área de colisión.
	if body.name == "Player":
		# Muestra en la consola que hubo colisión (útil para pruebas).
		print("Jugador colisionó con obstáculo")

		# Llama al menú de Game Over que está en el nodo principal.
		get_node("/root/Main").show_game_over_menu()

		# Pausa todo el juego.
		get_tree().paused = true
