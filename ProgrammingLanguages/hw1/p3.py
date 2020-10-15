def question3():
    str1 = input("Input 1: ")
    str2 = input("Input 2: ")
    str3 = str1.strip() + str2.rstrip()

    if (str1 and str1.strip()) and not (str2 and str2.strip()):
        if (str1.startswith('"') and str1.endswith('"')) is False and (
                str1.startswith("'") and str1.endswith("'")) is False:
            return pFalse()
        return pTrue()

    if not (str1 and str1.strip()) and (str2 and str2.strip()):
        if (str2.startswith('"') and str2.endswith('"')) is False and (
                str2.startswith("'") and str2.endswith("'")) is False:
            return pFalse()
        return pFalse()

    if (str3.startswith('"') and str3.endswith('"'))is False and (str3.startswith("'") and str3.endswith("'")) is False:
        return pFalse()

    if str3.startswith("'") and str3.count("'") > 2 and str3.count("\\'") == 0:
        return pFalse()

    if str3.startswith('"') and str3.count('"') > 2 and str3.count('\\"') == 0:
        return pFalse()

    if str1.endswith("\\") is False:
        return pFalse()

    if str1.count("\\") % 2 == 0:
        return pFalse()

    return pTrue()


def pTrue():
    print("True")
    return


def pFalse():
    print("False")
    return


question3()
