# --- Introduction -------------------------------------------------------------

### FIGURE 1
# Screenshot from http://www.seasonal.website


# --- Installation -------------------------------------------------------------

# Installation from CRAN:
# install.packages("seasonal")

# Alternatively, installation from GitHub:
# install.packages("remotes")
# remotes::install_github("christophsax/seasonal") 

# This will also install x13binary. To get the latest:
# install.packages("x13binary")

# seasonalview needs to be installed separately:
# install.packages("seasonalview")

# --- An introductory example --------------------------------------------------

library("seasonal")
m <- seas(unemp)
     
### FIGURE 2
plot(m, main = "")
grid()
legend("bottomright", lty = 1, col = 1:2, legend = c("Unadjusted", "Seasonally adjusted"), bty = "n")

### SUMMARY OUTPUT
summary(m)

seas(unemp, x11 = "")

seas(x = unemp, 
     arima.model = "(1 1 1)(0 1 1)", 
     regression.aictest = NULL, 
     outlier = NULL, 
     transform.function = "none"
     )

static(m)

if (interactive()) {
    view(m)
}

# --- Input --------------------------------------------------------------------

seas(unemp, 
     regression.variables = c("td", "ls2009.11"),
     regression.aictest = NULL
     )

seas(AirPassengers,
     x11 = "",
     regression.variables = c("td", "seasonal"),
     regression.aictest = NULL
     )
 
lshift <- ts(-1, start = c(1990, 1), end = c(2019, 11), freq = 12)
window(lshift, start = c(2009, 11)) <- 0
seas(unemp, xreg = lshift, outlier = NULL)

seas(unemp, regression.variables = "ls2009.11", outlier = NULL)

seas(list = list(x = unemp, x11 = ""))

update(m, regression.variables = "td", x11 = "")
update(m, x = unemp)

predict(m, newdata = unemp)


# --- Output -------------------------------------------------------------------

m <- seas(unemp)
series(m, "forecast.forecasts")
series(m, c("forecast.forecasts", "s12"))
 
m.save <- seas(unemp, forecast.save = "forecasts")
series(m.save, "forecast.forecasts")

m <- seas(unemp)
series(m, "history.saestimates")
series(m, "slidingspans.sfspans")
  
out(m)

udg(m)


# --- Graphs -------------------------------------------------------------------

### FIGURE 3
monthplot(m, main = "")
grid(nx = NA, ny = NULL)
legend("topright", lty = 1, col = c("red", "blue"), legend = c("Seasonal component", "SI component"), bty = "n")

pacf(resid(m))
spectrum(diff(resid(m)))
plot(density(resid(m)))
qqnorm(resid(m))
    
if (interactive()) {
    identify(m)
}


# --- Graphical user interface -------------------------------------------------

### FIGURE 3
if (interactive()) {
    view(m)  # Screenshot
}


# --- Customized holidays ------------------------------------------------------

seas(iip, 
     x11 = "",
     xreg = genhol(diwali, start = 0, end = 0, center = "calendar"), 
     regression.usertype = "holiday"
     )


# --- Large-scale production use -----------------------------------------------

unemp.oct16 <- window(unemp, end = c(2016, 10))
m.oct16 <- seas(unemp.oct16)

m.oct16.static <- static(m.oct16, evaluate = TRUE) 

update(m.oct16, x = unemp)
update(m.oct16.static, x = unemp)

dta <- list(fdeaths = fdeaths, mdeaths = mdeaths)
ll <- lapply(dta, function(e) try(seas(e, x11 = "")))

is.err <- sapply(ll, class) == "try-error"
ll[is.err]

do.call(cbind, lapply(ll[!is.err], final))

ll.static <- lapply(ll, static, evaluate = TRUE)
Map(predict, ll.static, newdata = dta)


# --- Import X-13 models and series --------------------------------------------

import.spc(system.file("tests", "Testairline.spc", package = "seasonal"))


# --- Deployment via x13binary -------------------------------------------------

# install.packages("seasonal")

