---
title: "Extreme Temp LAB 2"
author: "Tejasi"
output: 
  flexdashboard::flex_dashboard:
    storyboard: true
    social: menu
    source: embed
    orientation: columns
    vertical_layout: fill
---

```{r setup, include=FALSE}

knitr::opts_chunk$set(echo = FALSE)

library(flexdashboard)
library(knitr)
library(ggplot2)
library(rnoaa)
library(tidyverse)
library(readxl)
library(dplyr)
library(xts)
library(zoo)
library(plotly)
library(tidyverse)
library(urbnmapr)
library(fiftystater)
library(urbnmapr)
library(openintro)
library(gtools)
library(lubridate)
library(quantmod)
library(dygraphs)

```

###Climate Change

![ClimateChange](climatechange.jpg)

***
Climate change is an increasingly growing concern in today's world. Global warming without doubt is a topic of discussion. We are able to see the several impacts of Climate change happening across the United States- and across the globe.  Things that we value the most like Water, Agriculture, Transportation, and human health a re all being impacted.  Ecosystems are affected, and Changes are also occurring in the ocean.

 

In this project, we are interesting in studying the effect of extreme temperatures and their effects that is happening Globally and predominantly in the United States.

 

Source : http://www.noaa.gov/resource-collections/climate-change-impacts.



```{r,echo = FALSE, message = FALSE}

climatedata <- read.csv("records.csv")


```



### Maximum Temperature



```{r,echo = FALSE, message = FALSE}

#Statewise highest temperatures

MaxTemp <- subset(climatedata, climatedata$Element == "All-Time Maximum Temperature")


MaxTempFinal <- MaxTemp [!duplicated(MaxTemp[c(1,4)]),]


Max_temp_g = ggplot(MaxTempFinal, aes(x = State, y = Value)) + 
  geom_bar(aes(fill=State),stat="identity",width = 0.9, 
           position = position_dodge()) + theme_minimal() + 
  xlab("State") + ylab("Temperature (degrees F)") +
  theme(axis.text.x=element_blank(),
      axis.ticks.x=element_blank(),
      plot.background = element_blank()) + 
  ggtitle("Statewise Maximum Temperatures recorded")
ggplotly(Max_temp_g)

```

***
The dataset is extracted from  Extreme Temperature Records by state on NOAA website.
Source : https://www.climate.gov/maps-data/dataset/extreme-weather-records-state-data-table

As it can be seen in the bar chart, among the states of USA, California is seen to be having the maximum temperature records and the next closest is Arizona.

The highest temperature over time is seen to be 134 degrees F in California and around 128 degrees F in Arizona.  



### Minimum Temperature


```{r, echo = FALSE, message = FALSE}

#Statewise lowest temperatures

MinTemp <- subset(climatedata, climatedata$Element == "All-Time Minimum Temperature")


MinTempFinal <- MinTemp [!duplicated(MinTemp[c(1,4)]),]


Min_temp_g = ggplot(MinTempFinal, aes(x = State, y = Value)) + 
  geom_bar(aes(fill=State),stat="identity",width = 0.9, 
           position = position_dodge()) + theme_minimal() + 
  xlab("State") + ylab("Temperature (degrees F)") +
  theme(axis.text.x=element_blank(),
      axis.ticks.x=element_blank(),
      plot.background = element_blank()) + 
  ggtitle("Statewise Minimum Temperatures recorded")
ggplotly(Min_temp_g)


```


***

 We observed the Extreme Minimum temperatures of all states within USA. It can be seen that coldest temperature of -80 Degree F at Alaska , whereas Montana is seen to have a lowest temperature record of -70 degree F.  





###Global Temperature Anomalies 

```{r}
globaldata<-read.csv("globalanomalies.csv")

#graph

library(plotly)
library(ggplot2)

global = ggplot(globaldata, aes(x = Year, y = Value)) + 
  geom_line(color='steelblue') + 
  xlab("Year") + ylab("Value") +
  theme(axis.text.x=element_blank(),
      axis.ticks.x=element_blank(),
      plot.background = element_blank()) + 
  ggtitle("Global Temperature Anomalies")
ggplotly(global)

```


***
One of the most obvious indications of climate change is increase of global increase in temperature for the past several year over several decades. 
 
We also chose to study the Global Temperature Anomalies data obtained from Climate.gov website which created this dataset by blending the land and ocean data. We utilized this data to understand the trend of temperature anomalies over time. 

Source : https://www.climate.gov/maps-data/dataset/global-temperature-anomalies-graphing-tool 

As it can be clearly seen, the graph shows a progression of increasing temperature anomalies especially in the 20th century which also acts as a proof that Climate change is Real. 