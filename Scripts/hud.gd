extends CanvasLayer

var x
var y
var z
var real_hp
var real_sp
var real_tp

func _ready():
	x = 0
	y = 0
	z = 0
	real_hp = 100
	real_sp = 100
	real_tp = 100

func _process(delta):
	$hp.set_region_rect(Rect2(0,0,x *51 / 100,4))
	if(x<real_hp):
		x = x + 1
	elif(x==real_hp):
		pass
	else:
		x= x - 1
	$sp.set_region_rect(Rect2(0,0,y *51 / 100,4))
	if(y<real_sp):
		y = y + 0.5
	elif(y==real_sp):
		pass
	else:
		y= y - 0.5
	$tp.set_region_rect(Rect2(0,0,z *51 / 100,4))
	if(z<real_tp):
		z = z + 0.5
	elif(z==real_tp):
		pass
	else:
		z= z - 0.5


func _on_Player_health_changed(healt):
	print("healt-->"+healt)
	real_hp = healt
