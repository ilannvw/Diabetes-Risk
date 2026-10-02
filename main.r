# diabetes risk analysis

# loads and cleans the diabetes risk dataset, then categorises
# lifestyle / biological variables, computes the correlations
# against Diabetes_Risk_Score variable, and exports these results
# to a .csv file to be able to plot in Python.

# load the dataset
# read.csv() loads the file into a .csv file called 'data'
data <- read.csv("data/diabetes_risk_prediction_dataset.csv")

# this line is a structural check, to confirm the column names, types,
# and shows the first few values of each column
str(data)

# this line counts the number of missing values per column (NA)
# this is done to make sure that there are enough values to make
# the result meaningful.
# in this case, the average amount of NAs present is around 4%, meaning
# any existing NAs are not counted as the amount is low.
colSums(is.na(data))

# converts the categories (e.g. poor, average, healthy) into numbers (1, 2, 3)
# so they can be used for further analysis.
data$Diet_Quality_num <- as.numeric(factor(data$Diet_Quality,
                                           levels = c("Poor",
                                                      "Average",
                                                      "Healthy"),
                                           ordered = TRUE))

data$Smoking_Status_num <- as.numeric(factor(data$Smoking_Status,
                                             levels = c("Never",
                                                        "Former",
                                                        "Current"),
                                             ordered = TRUE))

data$Alcohol_Consumption_num <- as.numeric(factor(data$Alcohol_Consumption,
                                                  levels = c("Never",
                                                             "Occasionally",
                                                             "Frequently"),
                                                  ordered = TRUE))

# because Family_History_Diabetes is a simple Yes / No
# so it's converted to either 1 / 0
data$Family_History_Diabetes_num <- as.integer(data$
                                                 Family_History_Diabetes ==
                                                 "Yes")

# defining the two variable groups that are compared
# 1st research question: do modifiable lifestyle factors predict
# diabetes risk as strongly as fixed biological factors?
lifestyle_variables <- c(
  "Exercise_Hours_Per_Week",
  "Sleep_Hours",
  "Daily_Walking_Minutes",
  "Diet_Quality_num",
  "Smoking_Status_num",
  "Alcohol_Consumption_num"
)

biological_variables <- c(
  "Age",
  "BMI",
  "Family_History_Diabetes_num"
)

# Pearson correlation computation for each variable
# this function takes in a vector of column names, and then each
# one, it computes its correlation with the Diabetes_Risk_Score.

# the line 'use = "pairwise.complete.obs"' is for each correlation, only
# drops rows where that variable missing, instead of removing a row
# just because another column had an NA.
compute_correlations <- function(vars, data, target = "Diabetes_Risk_Score") {
  sapply(vars, function(v) {
    cor(data[[v]], data[[target]], use = "pairwise.complete.obs")
  })
}

lifestyle_corr  <- compute_correlations(lifestyle_variables, data)
biological_corr <- compute_correlations(biological_variables, data)

# combines both groups into a single data frame so it's easier to visualise,
# export
results <- data.frame(
  Variable = c(names(lifestyle_corr), names(biological_corr)),
  Correlation = c(lifestyle_corr, biological_corr),
  Group = c(
    rep("lifestyle", length(lifestyle_corr)),
    rep("biological", length(biological_corr))
  )
)

# rows are sorted by absolute correlation strength (descending order),
results <- results[order(-abs(results$Correlation)), ]
print(results)

# group level comparison
# 2nd research question: does one group, on average, correlate more
# strongly with diabetes risk than the other?

mean_abs_lifestyle  <- mean(abs(lifestyle_corr))
mean_abs_biological <- mean(abs(biological_corr))

cat("mean |correlation| - lifestyle factors:  ",
    round(mean_abs_lifestyle, 3), "\n")
cat("mean |correlation| - biological factors: ",
    round(mean_abs_biological, 3), "\n")

# export the results to be able to plot in Python

# file 1: correlation table
write.csv(results, "correlation_results.csv", row.names = FALSE)

# file 2: raw columns (needed for the two supporting plots)
# only exporting what's needed, not the full 50,000 x 41 dataset.
plot_data <- data[, c("Diabetes_Risk_Score", "Family_History_Diabetes")]
write.csv(plot_data, "plot_data.csv", row.names = FALSE)

cat("\nfiles exported correlation_results.csv and plot_data.csv 
    ready for Python plotting.\n")