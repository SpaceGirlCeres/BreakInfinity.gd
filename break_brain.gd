#
# Thanks To My Best Friend Shrek For All The Help
#

#
# Heavily inspired off of break_eternity.gd by Minemaker0430*
# https://github.com/Minemaker0430/break_eternity.gd
# *significantly less error handling beacause this is intended for my personal use
#

class_name Large
# Large has support for numbers up to ee308

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
		power = (power == INF) and INF
	elif (abs(man) < 1 or abs(man) >= 10):
		var norm = floor(Math.loger(abs(man))+0.0000000000001)
		power += norm
		man /= 10**norm
	return self
		
func _round(dec: int) -> Large:
	return large(Math.rounded(man, dec), Math.rounded(power, 1))
		
		
# simple math functions
func _add(num2: Large) -> Large:
	var num1 = self
	if num1.power < num2.power:
		var temp = num2
		num2 = num1
		num1 = temp
	num1.man += num2.man / 10**(num1.power-num2.power)
	return num1.normalize()
	
func _sub(num2: Large) -> Large:
	return _add(num2.neg())
	
func _mult(num2 : Large) -> Large:
	man *= num2.man
	power += num2.power
	return normalize()

func _div(num2 : Large) -> Large:
	if !num2.man:
		if man:
			return large(NAN, sign(man)*INF)
		return large(NAN, NAN)
		
	man /= num2.man
	power -= num2.power
	return normalize()
	
	
# complex math
func _log(base: Large) -> Large:
	return large((Math.loger(man)+power)/(Math.loger(base.man)+base.power), 0).normalize()
	
func _pow(exponent: Large) -> Large:
	var e = exponent.large_float()
	return large(man**e*10**(fmod(power*e, 1)),floor(power*e)).normalize()
	
	
# comparisons
func is_equ(num2: Large) -> bool:
	var num1 = self
	return (num1.man == num2.man) and (num1.power == num2.power)
	
func not_equ(num2: Large) -> bool:
	var num1 = self
	return ! num1.is_equ(num2)

func is_greater(num2: Large) -> bool:
	var num1 = self
	return (num1.power > num2.power) or ((num1.man > num2.man) and (num1.power == num2.power))

func is_less(num2: Large) -> bool:
	var num1 = self
	return (num1.power < num2.power) or ((num1.man < num2.man) and (num1.power == num2.power))

func greater_equ(num2: Large) -> bool:
	var num1 = self
	return ! num1.is_less(num2)
	
func less_equ(num2: Large) -> bool:
	var num1 = self
	return ! num1.is_greater(num2)


# large to other type
func large_str() -> String:
	if abs(power) >= 1e3:
		return str(man, "e", large(power, 0).man, "e", large(power, 0).power)
	elif power >= 3:
		return str(man, "e", power)
	else:
		return str(man*10**power)
	
func large_float() -> float:
	if power < 308:
		return float(man*10**power)
	else:
		return INF
