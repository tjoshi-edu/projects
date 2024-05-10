---
title: "Maximizing Company Profits Dashboard"
Author: "Tejasi"
output: 
  flexdashboard::flex_dashboard:
    orientation: columns
    vertical_layout: fill
    social: menu
    source: embed
---

```{r setup, include=FALSE, message=FALSE}
library(flexdashboard)
library(quantmod)
library(dygraphs)
library(lubridate)

```

Column {data-width=480}
-----------------------------------------------------------------------

### Closing stock prices - Graph

```{r, echo=FALSE, message = FALSE}

companies <- c("AAPL", "MSFT", "TWTR")
getSymbols(companies, from="2017-07-01", to="2018-06-30")
ClosingStockPrices <- do.call(merge, lapply(companies, function(x) Cl(get(x))))

dateperiod<-c("2017-07-01", "2018-06-30")
dygraph(ClosingStockPrices, main="Closing Stock Price in USD", group="Stock") %>%
    dyAxis("y", label="Closing Price($)") %>%
  dyOptions(axisLineWidth = 2.0,  colors = RColorBrewer::brewer.pal(5, "Set1")) %>%
  dyHighlight(highlightSeriesBackgroundAlpha = 1.0,
              highlightSeriesOpts = list(strokeWidth = 3)) %>%
  dyRangeSelector(height = 65)

```


### Stock Prices - Table format

```{r}
what_metrics <- yahooQF(c("Price/Sales", 
                          "P/E Ratio",
                          "Previous Close","52-week Low", "52-week High",
                          "Market Capitalization"))

metrics <- getQuote(paste(companies, sep="", collapse=";"), what=what_metrics)

#Add tickers as the first column and remove the first column which had date stamps
metrics <- data.frame(Symbol=companies,metrics[,2:length(metrics)]) 

#Change colnames
colnames(metrics) <- c("Company", "Earnings Multiple","Previous Close","52-week Low", "52-week High","Market Cap")

DT::datatable(metrics, options = list(
  bPaginate = FALSE
))

```

Column {.tabset data-width=520}
------------------------------------------------------------------------------

### Apple 

```{r}

invisible(getSymbols("AAPL", src = "yahoo", from='2017-07-01', to='2018-06-30'))
APPLE <- AAPL
dygraph(APPLE[, -5], main = "Apple") %>%
  dyCandlestick() %>%
  dyAxis("y", label="Closing Stock Price") %>%
  dyOptions(colors= RColorBrewer::brewer.pal(5, "Set1")) %>%
  dyHighlight(highlightCircleSize = 4,
              highlightSeriesOpts = list(strokeWidth = 3),
              highlightSeriesBackgroundAlpha = 1) %>%
  dyRangeSelector(height = 65)


```

### Microsoft

```{r}

invisible(getSymbols("MSFT", src = "yahoo", from='2017-07-01', to='2018-06-30'))
MICROSOFT <- MSFT
dygraph(MICROSOFT[, -5], main = "Microsoft") %>%
  dyCandlestick() %>%
  dyAxis("y", label="Closing Stock Price") %>%
  dyOptions(colors= RColorBrewer::brewer.pal(5, "Set1")) %>%
  dyHighlight(highlightCircleSize = 4,
              highlightSeriesOpts = list(strokeWidth = 3),
              highlightSeriesBackgroundAlpha = 1) %>%
  dyRangeSelector(height = 65)

```

### Twitter

```{r}

invisible(getSymbols("TWTR", src = "yahoo", from='2017-07-01', to= '2018-06-30'))
TWITTER <- TWTR
dygraph(TWITTER[, -5], main = "Twitter") %>%
  dyCandlestick() %>%
  dyAxis("y", label="Closing Stock Price") %>%
  dyOptions(colors= RColorBrewer::brewer.pal(5, "Set1")) %>%
  dyHighlight(highlightCircleSize = 4,
              highlightSeriesOpts = list(strokeWidth = 3),
              highlightSeriesBackgroundAlpha = 1) %>%
  dyRangeSelector(height = 65)

```
