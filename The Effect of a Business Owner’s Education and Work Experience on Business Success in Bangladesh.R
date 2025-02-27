
# Load dataset
setwd("/Users/joshuah/Desktop/Bangladesh")
data <- read.csv("informality_data_NEW.csv")

# Load libraries
library(stargazer)
library(AER)

## OLS REGRESSIONS

# Create a subset that only includes where business was founded in 2009 or before and sales is non-zero
data_2009=subset(data, q1_11y <= 2009 & q4_8 != 0)

# Define variable for log total sales 2009
log_sales_09=log(data_2009$q4_7)

# Define variables for work experience in 2008 and 2009, which is age of 
# principal owner (q1_13) minus age started working full time
age=data_2009$q1_13
start_work=data_2009$q2_3
exper_2009=age-start_work

# Define control variables 'sector' and 'total workers'
sector_2009=data_2009$nob
total_workers_09=data_2009$q1_12a5a

# Define number of years of education of the principal owner
years_educ_2009=data_2009$q2_2

# create a subset for 2008 that only includes where business was founded in 2008 and sales is non-zero or before and then repeat the prior steps
data_2008=subset(data, q1_11y <= 2008 & q4_8 != 0)
log_sales_08=log(data_2008$q4_8)
age_2=data_2008$q1_13
start_work_2=data_2008$q2_3
exper_2008=age_2-start_work_2-1
years_educ_2008=data_2008$q2_2
sector_2008=data_2008$nob
total_workers_08=data_2008$q1_12a5a

# Run regression with sales in 2009 as dependent, years_educ_2009 and experience independent
reg_2009=lm(log_sales_09 ~ years_educ_2009 + exper_2009 + sector_2009 + total_workers_09)
print(coeftest(reg_2009, vcov=vcovHC)) # use coeftest() to print HC standard errors

# Run regression with sales in 2008 as dependent, years_educ_2008 and experience independent
reg_2008=lm(log_sales_08 ~ years_educ_2008 + exper_2008 + sector_2008 + total_workers_08)
print(coeftest(reg_2008, vcov=vcovHC)) # use coeftest() to print HC standard errors

# run joint tests for both 2008 and 2009 with H0: b1=0 and b2=0, H1: b1!=0 or b2!=0
print(linearHypothesis(reg_2009, c("years_educ_2009 = 0", "exper_2009 = 0"), test="Chisq", vcov=vcovHC(reg_2009)))
print(linearHypothesis(reg_2008, c("years_educ_2008 = 0", "exper_2008 = 0"), test="Chisq", vcov=vcovHC(reg_2008)))

## 2SLS REGRESSION

# Define IV for years of work experience for 2009
dt_iv_09=subset(data_2009, q1_11y != 999) # create subset without the answer "I don't know" for year business was founded
business_years=2009-dt_iv_09$q1_11y

# Define IV for years of education for 2009
father_educ_09=dt_iv_09$q2_5

# Define outcome, explanatory and control variables with new subset
log_sales_iv_09=log(dt_iv_09$q4_7)
educ_iv_09=dt_iv_09$q2_2
exper_iv_09=dt_iv_09$q1_13-dt_iv_09$q2_3
sector_iv_09=dt_iv_09$nob
workers_iv_09=dt_iv_09$q1_12a5a

# Run 1st stage for IVs for years of education
srf1_educ_2=lm(educ_iv_09 ~ father_educ_09 + exper_iv_09 + business_years + sector_iv_09 + workers_iv_09)
print(coeftest(srf1_educ_2, vcov=vcovHC))

# Run 1st stage for IVs for years of work experience
srf1_exper=lm(exper_iv_09 ~ business_years + educ_iv_09 + father_educ_09 + sector_iv_09 + workers_iv_09)
print(coeftest(srf1_exper, vcov=vcovHC))

# Run combined 2SLS Regression
ivreg_09=ivreg(log_sales_iv_09 ~ educ_iv_09 + exper_iv_09 + sector_iv_09 + workers_iv_09 | father_educ_09 + business_years + sector_iv_09 + workers_iv_09)
print(coeftest(ivreg_09, vcov=vcovHC))

# Run joint Wald test for H0: b1=0 and b2=0, H1: b1!=0 or b2!=0
print(linearHypothesis(ivreg_09, c("educ_iv_09 = 0", "exper_iv_09 = 0"), test="Chisq", vcov=vcovHC(ivreg_09)))

# Do same as above for 2008 sales
dt_iv_08=subset(data_2008, q1_11y != 999)
business_years_08=2008-dt_iv_08$q1_11y
father_educ_08=dt_iv_08$q2_5
log_sales_iv_08=log(dt_iv_08$q4_7)
educ_iv_08=dt_iv_08$q2_2
exper_iv_08=dt_iv_08$q1_13-dt_iv_08$q2_3-1
sector_iv_08=dt_iv_08$nob
workers_iv_08=dt_iv_08$q1_12a5a
ivreg_08=ivreg(log_sales_iv_08 ~ educ_iv_08 + exper_iv_08 + sector_iv_08 + workers_iv_08 | father_educ_08 + business_years_08 + sector_iv_08 + workers_iv_08)
print(coeftest(ivreg_08, vcov=vcovHC))
print(linearHypothesis(ivreg_08, c("educ_iv_08 = 0", "exper_iv_08 = 0"), test="Chisq", vcov=vcovHC(ivreg_08)))


## DESCRIPTIVE STATISTICS

# Create table of summary statistics for key variables in reg_2009
data_2009=data.frame("Total Sales 2009"=data_2009$q4_7/1000000, "Years of education" = years_educ_2009, "Years of work experience in 2009" = exper_2009) # Create dataset
summary_stats_2009 <- sapply(data_2009, function(x) c(mean = mean(x), sd = sd(x), min = min(x), max = max(x))) # Create summary stats for variables in new dataset
stargazer(summary_stats_2009, type = "text", summary = FALSE) # Print the summary table using stargazer

# Create table of summary statistics for all potential control variables
father_educ=data$q2_5
sector=data$nob
workers=data$q1_12a5a
dt_start = subset(data, q1_11y != 999) # q1_11y is year business started operations. This subset removes '999' answer which means 'don't know'
business_years=2009-dt_start$q1_11y # number of years since business started operations

data_controls=data.frame("Father education" = father_educ, "Sector" = sector, "Total Workers"=workers) # Create dataset
summary_stats_controls <- sapply(data_controls, function(x) c(mean = mean(x), sd = sd(x), min = min(x), max = max(x))) # Create summary stats for variables in new dataset
stargazer(summary_stats_controls, type = "text", summary = FALSE) # Print the summary table using stargazer

summary_stats_byears <- sapply(data.frame(business_years), function(x) c(mean = mean(x), sd = sd(x), min = min(x), max = max(x))) # Create summary stats for variables in new dataset
stargazer(summary_stats_byears, type = "text", summary = FALSE)

## Robustness check - quadratic regressors
educ_2=years_educ_2009^2
exper_2=exper_2009^2
reg_2009_quad=lm(log_sales_09 ~ years_educ_2009 + educ_2 + exper_2009 + exper_2 + sector_2009 + total_workers_09)
print(coeftest(reg_2009_quad, vcov=vcovHC)) # use coeftest() to print HC standard errors

## Robustness check - started from scratch vs. didn't start
dt_founded=subset(dt_iv_09, q1_8 == 1)
business_years_founded=2009-dt_founded$q1_11y
father_educ_founded=dt_founded$q2_5
log_sales_founded=log(dt_founded$q4_7)
educ_founded=dt_founded$q2_2
exper_founded=dt_founded$q1_13-dt_founded$q2_3-1
sector_founded=dt_founded$nob
workers_founded=dt_founded$q1_12a5a
ivreg_founded=ivreg(log_sales_founded ~ educ_founded + exper_founded + sector_founded + workers_founded | father_educ_founded + business_years_founded + sector_founded + workers_founded)
print(coeftest(ivreg_founded, vcov=vcovHC))
print(linearHypothesis(ivreg_founded, c("educ_founded = 0", "exper_founded = 0"), test="Chisq", vcov=vcovHC(ivreg_founded)))

dt_not=subset(dt_iv_09, q1_8 == 2)
business_years_not=2009-dt_not$q1_11y
father_educ_not=dt_not$q2_5
log_sales_not=log(dt_not$q4_7)
educ_not=dt_not$q2_2
exper_not=dt_not$q1_13-dt_not$q2_3-1
sector_not=dt_not$nob
workers_not=dt_not$q1_12a5a
ivreg_not=ivreg(log_sales_not ~ educ_not + exper_not + sector_not + workers_not | father_educ_not + business_years_not + sector_not + workers_not)
print(coeftest(ivreg_not, vcov=vcovHC))
print(linearHypothesis(ivreg_not, c("educ_not = 0", "exper_not = 0"), test="Chisq", vcov=vcovHC(ivreg_not)))

## Multicollinearity tests for variables of interest
print(cor(years_educ_2009, exper_2009)) # correlation coefficient
vif_educ <- car::vif(reg_2009) # Variation Inflation Factor (VIF)
print(vif_educ)