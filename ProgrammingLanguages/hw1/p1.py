import keyword
import re


def question1():
    string = input("Identifier: ")
    if not string:
        return pFalse()

    if keyword.iskeyword(string.strip()) is True:
        return pFalse()

    special = re.search(r"[ !@#$%^&*()<>?/\\|{}~:]+", string)

    if special:
        return pFalse()

    num = re.search("^[\d]", string)

    if num:
        return pFalse()

    if not string.strip().startswith("_") and not string.strip().startswith("__"):
        if string.strip().endswith("_"):
            return pFalse()

    return pTrue()


def pTrue():
    print("True")
    return


def pFalse():
    print("False")
    return


question1()


