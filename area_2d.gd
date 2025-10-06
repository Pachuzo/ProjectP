extends Area2D  # Esta clase extiende Area2D, lo que significa que este nodo puede detectar colisiones y está posicionado en 2D.

@export var speed = 600  # Velocidad a la que el obstáculo se mueve horizontalmente hacia la izquierda (pixeles por segundo).

# Guardamos la referencia al nodo AnimatedSprite2D llamado 'Thunder' para controlar su animación.
@onready var animated_sprite = $Thunder

func _ready():
	# Al iniciar la escena, reproducimos la animación llamada "move" del sprite animado.
	# Esto hace que el obstáculo tenga movimiento visual, po r ejemplo, animación de fuego, relámpago, etc.
	animated_sprite.play("move")

func _physics_process(delta):
	# Esta función se llama cada frame con el tiempo transcurrido desde el último frame (delta).
	# Movemos el obstáculo hacia la izquierda multiplicando la velocidad por delta para que sea consistente con el tiempo.
	position.x -= speed * delta

	# Obtenemos el ancho (en píxeles) del primer frame de la animación "move".
	# Esto nos ayuda a saber cuándo el obstáculo ha salido completamente de la pantalla (para eliminarlo).
	var sprite_width = animated_sprite.sprite_frames.get_frame_texture("move", 0).get_width()

	# Si la posición horizontal del obstáculo es menor que (negativo ancho del sprite + 250),
	# significa que el obstáculo ya salió completamente de la pantalla y un poco más para evitar que se vea.
	if position.x < -sprite_width - 250:
		# Eliminamos el nodo de la escena para liberar memoria y recursos.
		queue_free()

func _on_body_entered(body):
	# Esta función se dispara cuando otro cuerpo (PhysicsBody2D) entra en contacto con el área de colisión de este nodo.

	# Verificamos si el objeto que colisiona tiene el nombre "Player".
	if body.name == "Player":
		# Imprimimos un mensaje en la consola para depuración.
		print("Jugador colisionó con obstáculo")

		# Llamamos a la función show_game_over_menu() en el nodo principal llamado "Main".
		# Esto muestra el menú de Game Over cuando el jugador pierde.
		get_node("/root/Main").show_game_over_menu()

		# Pausamos el juego para detener toda la acción mientras se muestra el menú.
		get_tree().paused = true
