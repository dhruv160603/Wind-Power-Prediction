library(VedicDateTime)

solete_data <- read.csv("df_forecast.csv")

# Julian day
solete_data$julian_day <- mapply(
  gregorian_to_jd, 
  solete_data$Year, 
  solete_data$Month, 
  solete_data$Day
)

# Flagging time zone (2 = Summer time (CEST, UTC+2), 1 = Winter time (CET, UTC+1))
solete_data$season_flag <- ifelse(solete_data$Month %in% 4:10, 2, 1)
print(solete_data)

# Location: lat, lon, timezone (1 or 2)
location <- c(55.7478, 12.0800, 1)

# get_vedic_date function
get_vedic_date <- function(julian_day, place) {
  masa_num <- VedicDateTime::masa(julian_day, place)
  vikram_samvatsara <- VedicDateTime::elapsed_year(julian_day, masa_num)[5]
  tithi_ <- tithi(julian_day, place)[1]
  masa_ <- masa(julian_day, place)[1]
  vedic_dates <- paste(as.character(vikram_samvatsara), "-", as.character(masa_), "-", as.character(tithi_), sep = "")
  return(vedic_dates)
}

# Vedic_date
solete_data$vedic_date <- mapply(function(jd, tz) {
  location <- c(55.7478, 12.0800, tz)  # Same location as sunrise
  get_vedic_date(jd, location)
}, solete_data$julian_day, solete_data$season_flag)

# Tithi
solete_data$tithi <- mapply(function(jd, tz) {
  location <- c(55.7478, 12.0800, tz)  # Same location as sunrise
  tithi_value <- tithi(jd, location)
  return(tithi_value)
}, solete_data$julian_day, solete_data$season_flag)

print(solete_data)

# Convert lists to comma-separated strings if needed
solete_data[] <- lapply(solete_data, function(col) {
  if (is.list(col)) return(sapply(col, toString))  # Convert lists to comma-separated strings
  else return(col)
})

# Sunrise Time 
solete_data$sunrise <- mapply(function(jd, tz) {
  location <- c(55.7478, 12.0800, tz)
  result <- sunrise(jd, location)
  sprintf("%02d:%02d:%02d", result[2], result[3], result[4])
}, solete_data$julian_day, solete_data$season_flag)

print(solete_data$sunrise)

# Save to CSV
write.csv(solete_data, "df_forecast_wtih_tithi.csv", row.names = FALSE)
