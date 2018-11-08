extends ParallaxBackground

var _offset = 0

func _ready():
	set_process(true)
	
func _process(delta):
	_offset -=100 * delta
	set_scroll_offset(Vector2(_offset,0))