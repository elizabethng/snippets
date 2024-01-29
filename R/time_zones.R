# Time zones in R
# https://stackoverflow.com/questions/15575713/modifying-timezone-of-a-posixct-object-without-changing-the-display

# see also 
# https://www.neonscience.org/resources/learning-hub/tutorials/dc-convert-date-time-posix-r
# https://stackoverflow.com/questions/37688509/determine-and-set-timezone-in-posixct-posixlt-strptime-etc-in-r?rq=3
# https://stackoverflow.com/questions/31477750/trouble-dealing-with-posixct-timezones-and-truncating-the-time-out-of-posixct-ob?rq=3

# can't use "PDT/PST" directly, I guess because it gets it from the date
force_tz(gen_raw$date_time[200], tzone = "America/Los_Angeles")
strptime(paste(date_time), '%Y-%m-%d %H:%M:%OS', tz = "America/Los_Angeles")
strptime(paste(date_time, "00:00:00"),'%Y-%m-%d %H:%M:%OS', tz = "America/Los_Angeles")

###
theme_set(theme_bw())
# 5 min data
select(gen_raw, date_time, PH2 = ri_discharge_flow_ph2, PH1 = ri_discharge_flow_ph1) %>%
  pivot_longer(c(PH2, PH1), names_to = "loc", values_to = "flow") %>%
  mutate(year = year(date_time)) %>%
  ggplot(aes(x = date_time, y = flow, color = loc)) +
  geom_line() +
  facet_wrap(year ~., scales = "free_x")

# hourly averages
jj <- select(gen_raw, date_time, PH2 = ri_discharge_flow_ph2, PH1 = ri_discharge_flow_ph1) %>%
  pivot_longer(c(PH2, PH1), names_to = "loc", values_to = "flow") %>%
  mutate(year = year(date_time)) %>%
  mutate(date = date(date_time)) %>%
  mutate(hour = hour(date_time)) %>%
  group_by(loc, year, date, hour) %>%
  summarize(mean_hr_flow = mean(flow, na.rm = TRUE)) %>%
  mutate(date_time = ymd_hm(paste(date, hour, ":00")))

ggplot(jj, aes(x = date_time, y = mean_hr_flow, color = loc)) +
  geom_line() +
  facet_wrap(year ~., scales = "free_x")
