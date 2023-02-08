library(lubridate) #work with times

# parse date ----
my_date <- "1982-03-09"
ymd(my_date)

# time difference ----
today <- "2023-02-07"
ymd(today) <-  ymd(my_date)

# date to timestamp (or so-called POSIXct) ----
as.numeric(today)

# datetime to timestamp
today <- "2023-02-07 00:00:01"
as.numeric(ymd_hms(today))

# get day, hour, ... from string ----
# method 1
first_day <- today
first_day <- substr(first_date, start=9, stop=10)
first_hour <- substr(first_date, start=15, stop=16)
first_day
first_hour
# method 2
first_day = day(first_date)
first_hour = hour(first_date) #year, month, day, hour, minute, second
first_day
first_hour
