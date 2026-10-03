# diabetes risk analysis

# this file reads the correlation_results.csv and plot_data.csv exported 
# by main.r, and produces 3 plots:
# 1. correlation_comparison.png: lifestyle vs biological correlation
#    strength with Diabetes_Risk_Score
# 2. risk_score_distribution.png: distribution of the outcome 
#    variable itself
# 3. risk_by_family_history.png: boxplot showing the risk score
#    split by family history of diabetes 

import pandas as pd
import matplotlib.pyplot as plt

# plot 1: correlation comparison chart

# load the correlation table computed by main.r
results = pd.read_csv("correlation_results.csv")

# sort by correlation value from smallest to largest
results = results.sort_values("Correlation")

# compute the group means
mean_abs_lifestyle = results.loc[results["Group"] == "lifestyle", "Correlation"].abs().mean()
mean_abs_biological = results.loc[results["Group"] == "biological", "Correlation"].abs().mean()

# assign a colour per row based on the group, for a two-colour bar chart
# .map() looks up each row's Group value in the dictionary and returns 
# its matching colour
colors = results["Group"].map({"lifestyle": "#4C9AFF", "biological": "#FF8C00"})

# figsize sets the plot's width and height
fig1, ax1 = plt.subplots(figsize=(8, 5))

# make the variable names readable by removing "_num" and replacing the "_" with a space and to lower case
labels = results["Variable"].str.replace("_num", "").str.replace("_", " ").str.lower()

# barh() draws a horizontal bar chart
ax1.barh(labels, results["Correlation"], color=colors)
ax1.set_xlabel("pearson correlation (r)")

# the title has a subtitle line with the two group means, with 3 decimal
# places each (.3f)
ax1.set_title(
    "correlation with diabetes risk score\n"
    f"mean |r|: biological = {mean_abs_biological:.3f}  vs.  "
    f"lifestyle = {mean_abs_lifestyle:.3f}"
)

# barh() doesn't generate a legend by group, so it is built manually
legend_handles = [
    plt.Rectangle((0, 0), 1, 1, color="#FF8C00", label="biological"),
    plt.Rectangle((0, 0), 1, 1, color="#4C9AFF", label="lifestyle"),
]
ax1.legend(handles=legend_handles)

# prevents labels from being cut off or overlapping
plt.tight_layout()

# saves the figure as a PNG file
plt.savefig("correlation_comparison.png")

# displays the plot in a separate window, the script is paused here until
# the window is closed
plt.show()

# plot 2: distribution of Diabetes_Risk_Score

# load the columns exported by main.r
data = pd.read_csv("plot_data.csv")

fig2, ax2 = plt.subplots(figsize=(7, 5))

# hist() groups Diabetes_Risk_Score values into 30 bins, then counts 
# how many patients fall into each one
ax2.hist(data["Diabetes_Risk_Score"], bins=30, color="#4C9AFF", edgecolor="white")
ax2.set_xlabel("diabetes risk score")
ax2.set_ylabel("number of patients")
ax2.set_title("distribution of diabetes risk score")
plt.tight_layout()
plt.savefig("risk_score_distribution.png")
plt.show()

# plot 3: boxplot of risk score by family history of diabetes

# split the risk score column into two groups based on the family history
yes_group = data[data["Family_History_Diabetes"] == "Yes"]["Diabetes_Risk_Score"]
no_group  = data[data["Family_History_Diabetes"] == "No"]["Diabetes_Risk_Score"]

fig3, ax3 = plt.subplots(figsize=(7, 5))

# boxplot() draws one box per group in the list, containing the median, 
# interquartile range, and its outliers for each
ax3.boxplot([no_group, yes_group], tick_labels=["no", "yes"])
ax3.set_xlabel("family history of diabetes")
ax3.set_ylabel("diabetes risk score")
ax3.set_title("risk score by family history of diabetes")
plt.tight_layout()
plt.savefig("risk_by_family_history.png")
plt.show()

print("code run successfully. saved correlation_comparison.png, risk_score_distribution.png, "
      "and risk_by_family_history.png")