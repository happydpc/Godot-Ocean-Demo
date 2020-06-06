#tool
extends MeshInstance

onready var ocean : Ocean = $"../Ocean"

func _process(delta) -> void:
	var tTL : Vector3 = ocean.get_displace(Vector2(-2, -2))
	var tTR : Vector3 = ocean.get_displace(Vector2(+2, -2))
	var tBL : Vector3 = ocean.get_displace(Vector2(-2, +2))
	# var tBR : Vector3 = ocean.get_displace(Vector2(+2, +2))
	var p := Plane(tTL, tTR, tBL)
	
	var ba := (tTR-tTL)
	var n := ba.cross(tBL-tTL)
	var w := n.normalized()
	var u := ba.normalized()
	var v := w.cross(u)
	self.transform.basis.x = u
	self.transform.basis.y = w
	self.transform.basis.z = v
	var tr := (tTR +  tBL) / 2
	translation = tr # ocean.get_displace(Vector2())
