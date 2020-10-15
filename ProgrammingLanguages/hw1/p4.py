import datetime


def question4():

    date = input("Date(MM/DD/YYYY): ")

    month = int(date[0:2])
    day = int(date[3:5])
    year = int(date[6:10])

    printdate = datetime.datetime(year, month, day)
    print(printdate.strftime("%A")+", "+printdate.strftime("%B")+" "+str(day)+", "+printdate.strftime("%Y"))


question4()