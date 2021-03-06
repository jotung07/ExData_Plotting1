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

# Create Plot 2

# Set the PNG parameters to width and height of 480 as directed
png("Plot3.png", width = 480, height = 480)
# Plot the first line of the lilne graph
plot(df$fulltime, df$Sub_metering_1, col = 'black', xlab = '', ylab = 'Energy sub metering', type = 'l')
# Plot the second line
lines(df$fulltime, df$Sub_metering_2, col = 'red', type = 'l')
# Plot the third line
lines(df$fulltime, df$Sub_metering_3, col = 'blue', type = 'l')
# Add a legend to the plot
legend('topright', legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), col = c('black', 'red', 'blue'), lty = 1)
# Close the device graphics manager
dev.off()