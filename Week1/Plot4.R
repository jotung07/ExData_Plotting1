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
png("Plot4.png", width = 480, height = 480)
# Create a 2 x 2 plot space
par(mfrow = c(2,2))

# Create the top left graph. Make sure to remove the '(kikowatts)' from the ylabel
with(df, plot(fulltime, Global_active_power, type = "l", xlab = '', ylab = 'Global Active Power'))

# Create top right graph
with(df, plot(fulltime, Voltage, xlab ='datetime', ylab = 'Voltage', type = 'l'))

# Create bottom left graph
# Plot the first line of the lilne graph
plot(df$fulltime, df$Sub_metering_1, col = 'black', xlab = '', ylab = 'Energy sub metering', type = 'l')
# Plot the second line
lines(df$fulltime, df$Sub_metering_2, col = 'red', type = 'l')
# Plot the third line
lines(df$fulltime, df$Sub_metering_3, col = 'blue', type = 'l')
# Add a legend to the plot. Make sure to remove the outer boundary lines from the legend box.
legend('topright', legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), col = c('black', 'red', 'blue'), lty = 1, bty = 'n')

# Create bottom righth graph
with(df, plot(fulltime, Global_reactive_power, xlab = 'datetime', ylab = 'Global_reactive_power', type = 'l'))

# Close the graphics device manager
dev.off()