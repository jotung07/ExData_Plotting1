# I use the 'read.csv.sql' function to filter the input on date. This requires the sqldf library.
library(sqldf)

# The code below assumes that the data are stored in the same location as this R file.
# Read in the file, only pulling in records that occur on the two desired dates. The 'Date' field is stored in 'd/m/Y' format. Use a semicolon separator.
df <- read.csv.sql("household_power_consumption.txt", 
                   "select * from file where Date = '1/2/2007' or Date = '2/2/2007'",sep = ";")
# Convert the date and time fields into date and time field, respectively
df$Date <- as.Date(df$Date, format = '%d/%m/%Y')
# strptime accounts for the day and time --> only return the time
df$Time <- format(strptime(df$Time, "%H:%M:%S"), "%H:%M:%S")
# Create a new column that captures full datetime
df$fulltime <- with (df, as.POSIXct(paste(Date, Time)))

# Create Plot 1

# Set the PNG parameters to width and height of 480 as directed
png("Plot1.png", width = 480, height = 480)
# Plot the historgram. Set the color to red, and use the required x-y labels and main title.
hist(df$Global_active_power, col = 'red', xlab = "Global Active Power (kilowatts)", main = "Global Active Power")
dev.off()