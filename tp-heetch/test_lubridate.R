library(lubridate) #work with times

# parse date
my_date <- "1982-03-09"
ymd(my_date)

# time difference ----
today <- "2023-02-07"
ymd(today) <-  ymd(my_date)

# date to timestamp (or so-called POSIXct)
as.numeric(today)

# datetime to timestamp
today <- "2023-02-07 00:00:01"
as.numeric(ymd_hms(today))

