def question2():
	num = input("Number: ")

	if num.count(".") > 1:
		return pNone()

	if num.count("E") + num.count("e") > 1:
		return pNone()

	if num.count("+") + num.count("-") > 1:
		return pNone()

	if num.count(".") == 1:
		for n in num:
			if n.isdigit() is False and n != "." and n != "E" and n != "e" and n != "+" and n != "-":
				return pNone()
		return pFloat()

	if (num.count("e") + num.count("E")) == 1:
		for n in num:
			if n.isdigit()is False and n != "E" and n != "e" and n != "+" and n != "-":
				return pNone()
		return pFloat()

	if num.count("0B") + num.count("0b") == 1:
		try:
			int(num, 2)
			return pInt()
		except:
			return pNone()

	if num.count("0O") + num.count("0o") == 1:
		try:
			int(num, 8)
			return pInt()
		except:
			return pNone()

	if num.count("0X") + num.count("0x") == 1:
		try:
			int(num, 16)
			return pInt()
		except:
			return pNone()

	if num.startswith("0"):
		return pNone()

	for n in num:
		if n.isdigit() is False and n != "+" and n != "-":
			return pNone()
	return pInt()


def pInt():
	print("Int")
	return


def pFloat():
	print("Float")
	return


def pNone():
	print("None")
	return


question2()
