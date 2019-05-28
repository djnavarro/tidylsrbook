# setup
month <- 0 # count the number of months
balance <- 300000 # initial mortgage balance
payments <- 1600 # monthly payments
interest <- 0.05 # 5% interest rate per year
total_paid <- 0 # track what you’ve paid the bank

# convert annual interest to a monthly multiplier
monthly_multiplier <- (1 + interest) ^ (1/12)

# keep looping until the loan is paid off...
while(balance > 0){
  
  # do the calculations for this month
  month <- month + 1 # one more month
  
  balance <- balance * monthly_multiplier # add the interest 
  balance <- balance - payments # make the payments 
  total_paid <- total_paid + payments # track the total paid
  
  # print the results on screen
  cat("month", month, ": balance", round(balance), "\n")
  
}

# print the total payments at the end
cat("total payments made", total_paid, "\n")