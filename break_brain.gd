class_name Large

var man := 0.0
var power = 0

func _init(_man: float, _power) -> void:
	man = _man
	power = _power
	self.normalize()
	
func large(mantissa, exponent) -> Large:
	return Large.new(mantissa, exponent)

func normalize() -> Large:
	if (! man) or (man != man): 
		if power != INF:
			power = 0
	elif ! (1 <= abs(man) and abs(man) < 10):
		var norm = floor(Math.loger(abs(man)))
		power += norm
		man /= 10**norm
	return self
		
func add(num2: Large) -> Large:
	var num1 = self
	if num1.power < num2.power:
		var temp = num2
		num2 = num1
		num1 = temp
	
	num1.man += num2.man / 10**(num1.power-num2.power)
	return num1.normalize()
	
func sub(num2: Large) -> Large:
	return add(num2.neg())
	
func mult(num2 : Large) -> Large:
	var num1 = self
	num1.man *= num2.man
	num1.power += num2.power
	return num1.normalize()

func div(num2 : Large) -> Large:
	var num1 = self
	if !num2.man:
		if num1.man:
			return large(NAN, sign(num1.man)+INF)
		return large(NAN, NAN)
		
	num1.man /= num2.man
	num1.power -= num2.power
	return num1.normalize()
	
func is_equ(num2: Large) -> bool:
	var num1 = self
	return (num1.man == num2.man) and (num1.power == num2.power)
	
func not_equ(num2: Large) -> bool:
	var num1 = self
	return ! num1.is_equ(num2)

func is_greater(num2: Large) -> bool:
	var num1 = self
	if num1.power > num2.power:
		return true
	elif (num1.man > num2.man) and (num1.power == num2.power):
		return true
	else:
		return false

func is_less(num2: Large) -> bool:
	var num1 = self
	if num1.power < num2.power:
		return true
	elif (num1.man < num2.man) and (num1.power == num2.power):
		return true
	else:
		return false

func greater_equ(num2: Large) -> bool:
	var num1 = self
	return num1.is_equ(num2) or num1.is_greater(num2)
	
func less_equ(num2: Large) -> bool:
	var num1 = self
	return num1.is_equ(num2) or num1.is_less(num2)

func large_str() -> String:
	return str(man, "e", power)
	
