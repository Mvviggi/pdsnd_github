
#upload the csv files into the environment 
ny <- read.csv('new_york_city.csv')
wash <- read.csv('washington.csv')
chi <- read.csv('chicago.csv')
#add column called city to each table
ny['CITY']='New york'
wash['CITY']='Washington'
chi ['CITY']= 'Chicago'
#combine only same columns of all tables, to ignore the additional two columns from New York table
common_cols <- intersect(intersect(colnames(ny), colnames(wash)),colnames(chi))




#merge all three tables into one single data frame
cities <- rbind(subset(ny, select = common_cols),
                 subset(wash, select = common_cols),
                 subset(chi, select =common_cols))


#create an additional column to include the day of the week trip start time

cities$Weekday <- format(as.Date(cities$Start.Time), "%A")


library(ggplot2)

#get the count for each day by city
by(cities$Weekday, cities$CITY, summary)


#visualization to get the distribution of day of the week by City
ggplot(data = subset(cities, !is.na(Weekday))) +
  geom_bar(mapping = aes(x=Weekday, fill = CITY),
           position = "dodge") +
  ggtitle("Day of the week trip start date by city")

#get the summary info for each user type by city
library("dplyr")
by(cities$User.Type, cities$CITY, summary)



#remove the blank user type shown in previous code
cities1 = cities %>% mutate_if(is.factor,trimws) %>% filter(User.Type!='')
unique(cities1$User.Type)

#create visualiztion of user type by city
library(ggplot2)
ggplot(data = subset(cities1)) +
  geom_bar(mapping = aes(x=CITY, fill = User.Type),
           position = "dodge" ) +           
  ggtitle("User Types by city")

#get trip duration by city summary
 by(cities$Trip.Duration, cities$CITY, summary)


#visualization as box plot to get the average of trip duration per city. 
library(ggplot2)
qplot(x = CITY, y = Trip.Duration , 
      data = cities, geom ='boxplot') +
  ggtitle("Trip Duration By city")


#omiting outliers: limiting the y axis to 1500
library(ggplot2)
qplot(x = CITY, y = Trip.Duration , 
      data = cities, geom ='boxplot') +
  ggtitle("Trip Duration By city") +
  coord_cartesian(ylim = c(50.0, 1500))


system('python -m nbconvert Explore_bikeshare_data.ipynb')
