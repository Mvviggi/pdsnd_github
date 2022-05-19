## README for documentation branch
### Explore Bike Share Data
## The goal for this data is for the team to modify here any data analysis
For this project, your goal is to ask and answer three questions about the available bikeshare data from Washington, Chicago, and New York.  This notebook can be submitted directly through the workspace when you are confident in your results.

You will be graded against the project [Rubric](https://review.udacity.com/#!/rubrics/2508/view) by a mentor after you have submitted.  To get you started, you can use the template below, but feel free to be creative in your solutions!


```R
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



```


```R
#merge all three tables into one single data frame
cities <- rbind(subset(ny, select = common_cols),
                 subset(wash, select = common_cols),
                 subset(chi, select =common_cols))

```


```R
#create an additional column to include the day of the week trip start time

cities$Weekday <- format(as.Date(cities$Start.Time), "%A")

```


```R
library(ggplot2)
```

### Question 1



**What is the most common day? .**


```R
#get the count for each day by city
by(cities$Weekday, cities$CITY, summary)

```


    cities$CITY: Chicago
       Friday    Monday  Saturday    Sunday  Thursday   Tuesday Wednesday
         1285      1302      1150      1111      1254      1292      1236
    ------------------------------------------------------------
    cities$CITY: New york
       Friday    Monday  Saturday    Sunday  Thursday   Tuesday Wednesday
         8168      7570      6176      6597      8729      7898      9632
    ------------------------------------------------------------
    cities$CITY: Washington
       Friday    Monday  Saturday    Sunday  Thursday   Tuesday Wednesday      NA's
        12926     11721     12133     11566     13204     13288     14212         1



```R
#visualization to get the distribution of day of the week by City
ggplot(data = subset(cities, !is.na(Weekday))) +
  geom_bar(mapping = aes(x=Weekday, fill = CITY),
           position = "dodge") +
  ggtitle("Day of the week trip start date by city")
```


![png](output_7_0.png)


Chicago drivers start most of their trips on Mondays but all days of the week have similar amount of bikers starting their trips, while Washington and New York start most of their trips on Wednesday. The weekends, Saturday and Sundays, are the least amount of bikers starting a trip at all cities as can be assumed during this time the travel had already started.

### Question 2

 what are the counts of each user type?


```R
#get the summary info for each user type by city
library("dplyr")
by(cities$User.Type, cities$CITY, summary)


```


    cities$CITY: Chicago
                 Customer Subscriber
             1       1746       6883
    ------------------------------------------------------------
    cities$CITY: New york
                 Customer Subscriber
           119       5558      49093
    ------------------------------------------------------------
    cities$CITY: Washington
                 Customer Subscriber
             1      23450      65600



```R
#remove the blank user type shown in previous code
cities1 = cities %>% mutate_if(is.factor,trimws) %>% filter(User.Type!='')
unique(cities1$User.Type)
```


<ol class=list-inline>
	<li>'Subscriber'</li>
	<li>'Customer'</li>
</ol>




```R
#create visualiztion of user type by city
library(ggplot2)
ggplot(data = subset(cities1)) +
  geom_bar(mapping = aes(x=CITY, fill = User.Type),
           position = "dodge" ) +           
  ggtitle("User Types by city")
```


![png](output_12_0.png)


The dataframe contained mostly Subscribers and Customers. I removed the blank user type in order to get a more significant visualization. Results show that all cities have more Subscribers than customers. Washington has more customers all other cities. The difference of Subscribers bewteen Chicago and Washington is 58,717.

### Question 3
What is the average travel time for users in different cities?


```R
#get trip duration by city summary
 by(cities$Trip.Duration, cities$CITY, summary)

```


    cities$CITY: Chicago
       Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
       60.0   394.2   670.0   937.2  1119.0 85408.0
    ------------------------------------------------------------
    cities$CITY: New york
         Min.   1st Qu.    Median      Mean   3rd Qu.      Max.      NA's
         61.0     368.0     610.0     903.6    1051.0 1088634.0         1
    ------------------------------------------------------------
    cities$CITY: Washington
        Min.  1st Qu.   Median     Mean  3rd Qu.     Max.     NA's
        60.3    410.9    707.0   1234.0   1233.2 904591.4        1



```R
#visualization as box plot to get the average of trip duration per city.
library(ggplot2)
qplot(x = CITY, y = Trip.Duration ,
      data = cities, geom ='boxplot') +
  ggtitle("Trip Duration By city")

```

    Warning message:
    “Removed 2 rows containing non-finite values (stat_boxplot).”


![png](output_16_1.png)



```R
#omiting outliers: limiting the y axis to 1500
library(ggplot2)
qplot(x = CITY, y = Trip.Duration ,
      data = cities, geom ='boxplot') +
  ggtitle("Trip Duration By city") +
  coord_cartesian(ylim = c(50.0, 1500))

```

    Warning message:
    “Removed 2 rows containing non-finite values (stat_boxplot).”


![png](output_17_1.png)


The first graph shows all the values by city. Given that the trip durations ranges from 60 seconds to 1088634 seconds there are outliers that exceed the 75% quartile. In the second graph the y axis was limited to 1500 seconds to have a more concise visualization. The trip durations in Washington have the highest average with 1234 seconds, while New York have the shortest average.


## Finishing Up

> Congratulations!  You have reached the end of the Explore Bikeshare Data Project. You should be very proud of all you have accomplished!

> **Tip**: Once you are satisfied with your work here, check over your report to make sure that it is satisfies all the areas of the [rubric](https://review.udacity.com/#!/rubrics/2508/view).


## Directions to Submit

> Before you submit your project, you need to create a .html or .pdf version of this notebook in the workspace here. To do that, run the code cell below. If it worked correctly, you should get a return code of 0, and you should see the generated .html file in the workspace directory (click on the orange Jupyter icon in the upper left).

> Alternatively, you can download this report as .html via the **File** > **Download as** submenu, and then manually upload it into the workspace directory by clicking on the orange Jupyter icon in the upper left, then using the Upload button.

> Once you've done this, you can submit your project by clicking on the "Submit Project" button in the lower right here. This will create and submit a zip file with this .ipynb doc and the .html or .pdf version you created. Congratulations!


```R
system('python -m nbconvert Explore_bikeshare_data.ipynb')
```
>**Note**: Please **fork** the current Udacity repository so that you will have a **remote** repository in **your** Github account. Clone the remote repository to your local machine. Later, as a part of the project "Post your Work on Github", you will push your proposed changes to the remote repository in your Github account.

### Date created
04-20-2022

### Project title
Explore Bike Share Data

### Files Used
chicago.csv
washington.csv
new-york-city.csv

### Credits
Udacity and many Youtube videos
