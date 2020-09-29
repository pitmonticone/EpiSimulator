#######################
###### LOAD DATA ######
#######################
# Overall 
load("~/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Overall/contact_all.rdata")
load("~/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Overall/contact_home.rdata")
load("~/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Overall/contact_work.rdata")
load("~/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Overall/contact_school.rdata")
load("~/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Overall/contact_others.rdata")
# Rural
load("~/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Rural/contact_all_rural.rdata")
load("~/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Rural/contact_home_rural.rdata")
load("~/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Rural/contact_work_rural.rdata")
load("~/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Rural/contact_school_rural.rdata")
load("~/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Rural/contact_others_rural.rdata")
# Urban
load("~/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Urban/contact_all_urban.rdata")
load("~/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Urban/contact_home_urban.rdata")
load("~/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Urban/contact_work_urban.rdata")
load("~/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Urban/contact_school_urban.rdata")
load("~/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Urban/contact_others_urban.rdata")
#######################
###### SAVE DATA ######
#######################
# Overall
write.csv(contact_all[["ITA"]], "/Users/pietromonticone/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Overall/All.csv")
write.csv(contact_home[["ITA"]], "/Users/pietromonticone/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Overall/Home.csv")
write.csv(contact_work[["ITA"]], "/Users/pietromonticone/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Overall/Work.csv")
write.csv(contact_school[["ITA"]], "/Users/pietromonticone/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Overall/School.csv")
write.csv(contact_others[["ITA"]], "/Users/pietromonticone/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Overall/Others.csv")
# Rural 
write.csv(contact_all[["ITA"]], "/Users/pietromonticone/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Rural/All.csv")
write.csv(contact_home[["ITA"]], "/Users/pietromonticone/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Rural/Home.csv")
write.csv(contact_work[["ITA"]], "/Users/pietromonticone/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Rural/Work.csv")
write.csv(contact_school[["ITA"]], "/Users/pietromonticone/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Rural/School.csv")
write.csv(contact_others[["ITA"]], "/Users/pietromonticone/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Rural/Others.csv")
# Urban
write.csv(contact_all[["ITA"]], "/Users/pietromonticone/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Urban/All.csv")
write.csv(contact_home[["ITA"]], "/Users/pietromonticone/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Urban/Home.csv")
write.csv(contact_work[["ITA"]], "/Users/pietromonticone/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Urban/Work.csv")
write.csv(contact_school[["ITA"]], "/Users/pietromonticone/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Urban/School.csv")
write.csv(contact_others[["ITA"]], "/Users/pietromonticone/GitHub/DigitalEpidemiologyProject/Data/CSV/2020/Contact/Urban/Others.csv")