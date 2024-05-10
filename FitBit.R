---
title: "FitBit - Project"
Author: "Tejasi"
output: 
  flexdashboard::flex_dashboard:
    storyboard: true
    orientation: columns
    vertical_layout: fill
    social: menu
    source: embed

---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = FALSE)
library(dygraphs)
library(zoo)
library(xts)
library(lubridate)
library(flexdashboard)
library(knitr)
library(ggplot2)
library(tidyverse)
library(readxl)
library(dplyr)
library(plotly)
library(ggthemes)
library(scales)

fitbitdata <- read_excel("Tejasi_FitbitData.xlsx")

```

-----------------------------------------------------------------------
###Project Overview

![FitBit](fitbit.jpg)

***
This visualization dashboard is created with the help of data from my fitbit watch. The data consists of my daily activities like number of steps, floors, distance moved, calories burned etc.

- Flex Dashboard package was used to create a storyboard inorder to show visulaizaitons of my fitbit data. The data was almost perfect that a very little preprocessing was required such as removing nulls.

- We are trying to analyze the following points with the help of this dashboard.

1. The trend of my highest step counts based on Weekday and Month
2. The distance travelled vary by Weekday
3. The distribution of Calories burned over this time
4. The time in minutes I am Sedentary, lightly active, fairly active and very active every month
5. The distribution of Calories burned over the number of steps


###DataCollection and Preprocessing

Data Collection and Storage:

  The fitbit watch I wear tracks every thing from number of steps I take every day to how many calories I burn. It also measures number of active hours in a day.   Fitbit app allows the user to export the data into csv or excel files.

Data  Pre-processing:

  This excel file was converted used to dataframes using read excel package. Rows with nulls were removed/ignored.The dataset from fitbit has my data from 1st May   2018 to 8th August 2018. 

Methodology:

  Different packages/tools were used like tools like ggplot2, dplyr and plotly to create charts.
  
***
![FitBit Data](fitbit_data.jpg)

### Question 1: Analyze the trend of my highest step counts based on Weekday and Month

```{r}

Month <- format(fitbitdata$ActivityDate,"%m")
Weekdays <- wday(fitbitdata$ActivityDate, label=TRUE, abbr=FALSE)
p2 <- ggplot(data = fitbitdata, aes(x = Month, y = Steps, fill = Weekdays)) +
  geom_bar(position = "dodge",stat = "identity")+
  labs(title = "Steps Count per Month per Weekday", x = "Month", y = "Number of Steps")
ggplotly(p2)


```

***
Objective:
Analyze the trend of my highest step counts based on Weekday and Month

Visualization Method: 
Grouped Bar-Chart 

Summary:
This graph demonstrates in form of bars, the steps I took on each Weekday of each Month and the trend of these step counts across months. It also shows the overall trajectory of increase or decrease of steps from Month to Month.


### Question 2: Analyze the distance travelled vary by Weekday

```{r}

fill <- "orange"
line <- "black"
day_of_week <- fitbitdata %>% mutate(Weekday = weekdays(ActivityDate))
ggplot(day_of_week) +
aes(Weekday, Distance) +
  geom_boxplot(fill = fill, colour = line) 

```

***
Objective:
Analyze the distance travelled vary by Weekday 

Visualization Method: 
Box Plot

Summary:
The graphs show the average distance covered categorized by weekday. It shows how the mean distance covered trend changes between each weekday.


### Question 3: Analyze the distribution of Calories burned over this time

```{r}

Month <- format(fitbitdata$ActivityDate,"%m")
Weekdays <- wday(fitbitdata$ActivityDate, label=TRUE, abbr=FALSE)
ggplot(fitbitdata) + 
  aes(x = Month, y = Weekdays) +
  geom_tile(aes(fill = CaloriesBurned)) +
  labs(title = "Calories Burned per month by Weekday", x = "Month", y = "Weekdays")


```

***
Objective:
Analyze the distribution of Calories burned over this time

Visualization Method: 
Heat-Map

Summary:
This graph shows on the level of calories burned on different Weekday of different Month. This helps to visually map which Month I burned the most calories and which Weekday the highest number of calories were burned. 


### Question 4: Analyze the time in minutes I am Sedentary, lightly active, fairly active and very active every month

```{r}

fitbitdata$ActivityDate <- as.Date(fitbitdata$ActivityDate)
asf <- fitbitdata %>%
  select(ActivityDate, MinutesSedentary , MinutesLightlyActive, MinutesFairlyActive, MinutesVeryActive) %>%
  gather(key = "StateOfActivity", value = "Minutes", -ActivityDate)

asf$month <- format(asf$ActivityDate,"%m")

plot_ly(data = asf, x = ~asf$month, y = ~asf$Minutes, type="bar",color = ~asf$StateOfActivity, colors = "Set1")%>%
  layout(yaxis = list(title = 'Minutes of Activity'), xaxis = list(title = 'Month'), barmode = 'stack', title="Minutes of Activity by Activity State")

  
```

***
Objective:
Analyze the time in minutes I am Sedentary, lightly active, fairly active and very active every month

Visualization Method: 
Histogram

Summary:
From the graph we can see that I was very active in May and fairly active in July in last 3 months


### Question 5: Analyze the distribution of Calories burned over the number of steps

```{r}

  ggplot(fitbitdata, aes(x = Steps, y = fitbitdata$CaloriesBurned)) + 
    geom_point() +
    stat_smooth(method = "lm", col = "red") +
    ylab("Calories burned")
  
```

***
Objective:
Analyze the distribution of Calories burned over the number of steps

Visualization Method: 
Scatter Plot

Summary:
From the graph we can see that energy burned increase as steps increase. There are few points above the linear regression line. 
