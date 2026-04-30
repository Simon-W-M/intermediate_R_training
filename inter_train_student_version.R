# STUDENT VERSION #

# the other version has example answers in it


##########
#  help  #
##########

# hover over a function and press F1
# or
# type ?<function name>
#
# search within help tab 
#
# google.com!

##########################
# what we is going to do #
##########################

# a lot of intermediate data wrangling
# we may do a few minor graphs but the focus will be wrangling
# other training is available re charts, markdown and tables

# This course assumes a basic level of knowledge of R and dpylr
# It is expected that you are at least familiar with the contents of the 
# NHS-R Introduction to R and R Studio course

# in this tutorial we will be using modern |> pipes 
# these work exactly the same as old pipes %>%

##############################
# loading required libraries #
##############################

# load in initial libraries
# will come back to the code around this

# Specify required packages
my_packages <- c("tidyverse",
                 "NHSRdatasets",
                 "pacman") 

# Extract not installed packages
not_installed <- my_packages[!(my_packages %in% 
                                 installed.packages()[ , "Package"])]  

# Install not installed packages
if(length(not_installed)) install.packages(not_installed)   

# Load all packages
pacman::p_load(char = my_packages) 


################################
# Some useful base R functions #
################################

# make a dataframe
data <- ae_attendances

# get list of column names
colnames(data)

# little bit of base R  - using $ sign to select a column
data$type

# get list of unique data items in a variable
unique(data$org_code)

# notice the bit of base R
# base R is useful for certain things and it is a good idea
# to understand some of the basics at how some of the things work
# The $ sign allows us to call a column of a data frame as a vector.
data$type

# it is also possible to to select a specific entry within that vector with 
# square brackets
# to call the 4th entry we can
data$type[4]

# we could also call the 4th to 10th entries
data$type[4:10]

# note to python users, we start counting at 1 and not zero
# we also include the 10th entry 
#  this is very different to how python does indexing

# get number of distinct entries
n_distinct(data$org_code)

# get the range of a variable (useful for dates)
range(data$period)

# see structure of data to check data types
str(data)

# see the first 5 rows of data
head(data)

# see the last 5 rows of data
tail(data)

# see the first 15 rows of data
head(data, 
     15)

# see the first 15 rows of data - but using dpylr
slice_head(data, 
           n=15)

# see the first 15% of total rows of data - but using dpylr
# (defaults to last variable to order by)
slice_head(data, 
           prop= 0.15)

# see the first 15% of total rows of data - but using dpylr
# ordered by attendances
slice_max(data, 
           prop = 0.15, 
           order_by = attendances)

# <<< Over to you >>>>

# see if you can find the lowest 5 attendances for each org code
# do look for *help*






# bonus points if you can 
#find the lowest 5 attendances for each org code by each attendance type
#########################

# see summary statistics of a dataframe
# summary is a super function that also can give great summaries of other
# objects - such as linear models 
summary(data)

# quick counts by a column
table (data$type)

# or by 2 columns
table (data$type, 
       data$org_code)

# can do 3 columns but it starts to get silly how that is displayed

####################
# renaming columns #
####################

# dealing with spaces in variables (looking at you excel!)
# or if you want to rename a variable to a readable format for table

# lets rename our 'org_code' to 'Organisation Code'
# use back ticks to enclose a variable with with a space in it
# kind of the equivalent to square brackets in sql
data <- data |>
  rename(`Organisation Code` = org_code)

# lets also rename some more variables to something horrible
data <- data |>
  rename(Breaches = breaches,
         PERIOD = period,
         ` type` = type)

# we now have the look of a typical NHS table
# we could clean all those names manually
# or we could call in a janitor to use a function to do this for us

library(janitor)
# if this is not installed, install it manually

data <- clean_names(data)

# phew! all better.

# <<< Over to you >>>>

# have a quick try at renaming breaches to 'number of breaches'
# then put it back again





#########################

# janitor has some other really helpful functions to 
# convert excel dates to dates (if they do that weird numeric thing)
# find duplicate rows
# add quick totals 
# check it out, tidyverse and janitor are probably the two librarys
# I call at the start of any analysis

# best to run this to ensure we are back to clean data
data <- ae_attendances

####################
# select statement #
####################

# The super useful select statement
# in very simple terms this works like a sql select statement
# we can select columns from our dataframe and in addition they
# will be ordered in the order we select them
data_select <- data |>
  select (period,
          org_code)

view(data_select)

# or

data_select <- data |>
  select (org_code,
          period)

view(data_select)

# I have included a view statement here to look at our data, there are various 
# other ways to achieve the same without having do so so much or indeed any 
# typing

# you can simply call the name of the dataframe object
data_select

# you can select over there on the top right hand size in the environment

# or my absolutely favourite is to hold control and click on an object name

# anyway back to codin'

# we can also do a simple rename at the select stage
data_select <- data |>
  select (date_period = period,
          organisation = org_code)

# can also do a ! or - for negative select
data_select <- data |>
  select (!c(org_code,
             period))

# NOTE - you have to put the multiples into a vector
data_select <- data |>
  select (!org_code,
          !period)
# THIS DOES NOT WORK

data_select <- data |>
  select (-org_code,
          -period)
# this does work

# we can use some additional verbs in our select statement
# select any column name that contains 'es'
data_select <- data |>
  select (contains ('es'))

# select any column name that does not contains 'es'
data_select <- data |>
  select (!contains ('es'))

# select columns where the data is numeric
data_select <- data |>
  select (where(is.numeric))

# select breaches then admissions and then everything else as it is
data_select <- data |>
  select (admissions, 
          breaches, 
          everything())

# <<< Over to you >>>>

# select the data so that it is order of admissions, 
#  any column that is a factor and then anything else





#########################

# note there are other tidy select verbs which we went over in the intro course
# starts_with, ends_with 

####################################################
# alternative joins - row and column concatenation #
####################################################

# a few more things to join datasets together
# standard joins are covered in the introduction course in some detail

# this is about joining tables without keys

df_one <- data |>
  select (period,
          org_code,
          type,
          attendances) |>
  head()

df_two <- data |>
  select (where(is.numeric)) |>
  head()

# jam the two data frames together, side by side
# column bind

df_new <- bind_cols(df_one,
                    df_two)

# note duplicated column is duplicated - which can cause issues - best to remove
# or rename - also maintains order - need to be mindful you have rows that line 
# up

# we can also bind data frames by rows, this is similar to concatenation 
# in sql, need matching columns
df_one <- data |>
  head()

df_two <- data |>
  tail()

df_new <- bind_rows(df_one,
                    df_two)

# if we dont have matching columns can use bind_rows
# which matches columns where they match and puts in na for where data does not 
# match

df_one <- data |>
  select (period,
          org_code,
          type,
          attendances) |>
  head()

df_two <- data |>
  tail()

df_new <- bind_rows(df_one,
                    df_two)

# or in a pipe

df_new <- df_one |>
  bind_rows(df_two)

# <<< Over to you >>>>

# create a dataframe of the top 5 admissions only
# and the bottom 5 attendances only and join the two columns together





#########################

# if you want to join columns of different sizes you are 
# probably better off using the join family of functions

# Combining rows that exist in both tables and dropping duplicates 

# going to rename breaches to admissions to create some duplicates
df_one <- data |>
  select (org_code,
          admissions = breaches)

df_two <- data |>
  select (org_code,
          admissions) 

df_new_union <- union_all(df_one, 
                          df_two)

# Finding identical columns in both tables 
df_new_intersect <- intersect(df_one, 
                              df_two)

# Finding rows that don’t exist in another table 
df_new_diff <- setdiff(df_one, 
                       df_two)

#####################################
# Group within mutate and summarise #
#####################################

# this may or may not be new to you, depending on then you learnt R

# old skool would be
data_old <- data |>
  group_by(type) |>
  summarise (count = n()) |>
  ungroup ()

# nu skool is
data_nu <- data |>
  summarise (count = n(), 
             .by = type) 

# old skool would be
data_old <- data |>
  group_by(type) |>
  mutate (double_admissions = admissions * 2) |>
  ungroup ()

# nu skool is
data_nu <- data |>
  mutate (double_admissions = admissions * 2, 
          .by = type)

# nu skool, dropping groups is default, no need to ungroup()

###################
# Count functions #
###################

# lets do some more dpylr

# lets do a tidy version of 'table'
# this is useful if we want that kind of summary at the end
# of a longer pipe of  stuff
data_count <- data |>
  count(type)

# this could be the same as
data_count <- data |>
  summarise (count = n(),
             .by = type)

# creates a new column like a mutate with a count by feature
# eg how many times an org_code has submitted
data_count <- data |>
  add_count(org_code)

# is the same as
data_count <- data |>
  mutate (count = n(),
          .by = type)


###################
# fancy filtering #
###################

# filters data to org codes that contain a 'R' at any point
data_filter <- data |>
  filter(str_detect(org_code, "R"))

# filters data to latest date period per org code 
# (such an awesome feature to put a group by in a filter!)
data_filter <- data |>
  filter(period == max(period), 
         .by = org_code)

# filters data to type 1 AND 'attendances over 10,000
data_filter <- data |>
  filter(type == '1', 
         attendances > 10000)

# filters data to type 1 OR 'attendances over 10,000
data_filter <- data |>
  filter(type == '1' | 
           attendances > 10000)

# <<< Over to you >>>>

# can you write a script that returns the org codes for type 1 attendances
# where we have at least 24 submissions per org_code?
# and for bonus points put them in order by number of submissions?







# HINT - you can *count* on the fact we have already covered how to do this
# and maybe look at what else the function can do

#########################

################
# conditionals #
################

# basic two part conditional - if_else

# lets flag all instances where attendances were above 20,000
# a simple if_else statement if condition, do this else do that
data <- data |>
  mutate(above_20000 = if_else (attendances >= 20000, 
                                'Y',
                                'N'))

# NOTE data types and outputs for two conditions need to be the same
data <- data |>
  mutate(above_20000 = if_else (attendances >= 20000, 
                                100,
                                "9999"))

# will throw a wobble

# if_else is great for a single conditional - you can nest if_else statements
# but that gets really messy quickly, especially with the amount of brackets at
# the end

# multi part conditional - or case statement

# lets create a grouping column for our attendances in 5000s

data <- data |>
  mutate(
    attendance_grouping = case_when(
      attendances < 5000 ~ 'Less than 5,000',
      attendances < 10000 ~ '5,000 to 9,999',
      attendances < 15000 ~ '10,000 to 14,999',
      attendances < 20000 ~ '15,000 to 19,999',
      attendances < 25000 ~ '20,000 to 24,999',
      .default =  'Over 25,0000'
    )
  )

# the .default gives the default or 'else' statement
# the '~' is called a tilde and can be found as shift # next to the return key

# there is also an old skool way of doing this 
data <- data |>
  mutate(
    attendance_grouping = case_when(
      attendances < 5000 ~ 'Less than 5,000',
      attendances < 10000 ~ '5,000 to 9,999',
      attendances < 15000 ~ '10,000 to 14,999',
      attendances < 20000 ~ '15,000 to 19,999',
      attendances < 25000 ~ '20,000 to 24,999',
      TRUE ~ 'Over 25,0000'
    )
  )

# note the 'true' is the else statement and you use a tilde rather than equals
# both work the same, the .default is the more modern method


# however lets make a deliberate issue

# for example this case statement fails if we have a value of exactly 25,000
# well not fail, we just don't have a proper category for exactly 25,000
data$attendances[1] <- 25000

# now rerun the above case statement

# Lets also add some null data 
data$attendances[2] <- NA

# again the case statement 'works' but is incorrect

# personally I find it best to use the true statement as an error catch 

data <- data |>
  mutate(
    attendance_grouping = case_when(
      attendances < 5000 ~ 'Less than 5,000',
      attendances < 10000 ~ '5,000 to 9,999',
      attendances < 15000 ~ '10,000 to 14,999',
      attendances < 20000 ~ '15,000 to 19,999',
      attendances < 25000 ~ '20,000 to 24,999',
      attendances > 25000 ~ 'Over 25,0000',
      .default = 'ERROR - does not compute'
    )
  )

# we can fix this by adding a >= and changing our grouping
# description to '25,000 and over'

# NOTE: As the the if_else, the case_when also requires all the possible results
# to be of the same format and will check that is the case.
# If dealing with numeric - often you need to include a 'magic error number'
# This will be a result that stands out that could not possibly 
# be part of the equation - for dates you can set 'magic error dates' etc



# <<< Over to you >>>>

# add a column called whatever you wish, that returns 
#                   if type 1 ~ halves the attendances
#                   if type 2 ~ triples the attendances
#                   if type other ~ quads the attendances
#                   if error ~ a suitable error





#########################


# base R if statement - allows us to do what I call a one-sided if statement
# really useful if you want to trigger a conditional process

# curly brackets denote a 'scope' - a scope being a piece of code that may
# not necessarily be evaluated and does not always affect the global environment

a <- 5

if (a == 5)  {
  a <- 10
  print ('a is now 10')
  b <- a
  print('b has been created as a variable and is now a')
} 


# this is really powerful as works by if condition in brackets is met
# to do ALL of what is in the brackets
# the 'scope' of the if statement is global only when invoked

a <- 5

if (a == 5)  {
  a <- 10
  print ('a is now 10')
  c <- a
  print('c has been created as a variable and is now a')
} else {
  print(paste0('a is ', a))
  print('c does not exist')
}


#####################
# group and mutate  #
# to make sub total #
#####################

# grouping and mutating rather than summarising
# calc total and percentages by month and org

# lets create a total number of attendances across all types by org and month

data_tot_perc <- data |>
  mutate (total_attend = sum(attendances),
          perc_attend = (attendances / total_attend) * 100,
          .by = c(org_code, period)) 


# <<< Over to you >>>>

# that creates a pretty long decimal as a percentage
# can you round it to 1 decimal place?
# may need a little google fu and commas and brackets will get messy fast







#########################

##########################
# column wise operations #
##########################

# say we wanted to do that on all our numeric data
# the awesome across function allows us to do pretty fancy stuff

data_tot_perc <- data |>
  mutate (across(where(is.numeric),
                 ~(. / sum(.)) * 100,
                 .names = "perc_{.col}"),
          .by = c(org_code, period))

# across also uses tidy select functions
data_tot_perc <- data |>
  mutate (across(contains('es'),
                 ~(. / sum(.)) * 100,
                 .names = "perc_{.col}"),
          .by = c(org_code, period))

# this may be a little too advanced for now, but do come back to it!

#######################
# row wise operations #
#######################

# we are now going to do a rowwise operation to find the maximum of our 
# attendances, admissions and our newly created column
# in essence rowwise treats each each row as its own group
data <- data |>
  rowwise() |>
  mutate(max_col = max(attendances,
                       admissions, 
                       breaches,
                       na.rm = TRUE)) |>
  ungroup()

# note that rowwise is an old skool grouping function and needs to be ungrouped

##########################
# pivot wider and longer #
##########################

# pivoting data to longer or wider formats

# often we want long data for charts and wide data for tables and often have to
# convert from one to another

# lets go wide, lets look at a handful of sites and attendances and pivot wider 
# on date

# ie convert

#  org   period  attendances
#  abd   jan     100
#  abd   feb     200
#  abd   mar     300

# to

# org   jan   feb   mar
# abd   100   200   300

# lets start with filtering our data and selecting only a few columns


data_long <- data |>
  filter(org_code == 'RQM',
         type == '1',
         period >= '2018-08-01') |>
  select (org_code,
          period,
          attendances)

# have quick look at your data and see what shape it is in

# lets pivot
data_wide <- data_long |>
  pivot_wider(names_from = period,
              values_from = attendances)

# <<< Over to you >>>>

#  do the same but for breaches





#########################

# lets do a complex version
data_long <- data |>
  filter(org_code == 'RF4',
         #type == '1',                     # have not removed the type this time
         period >= '2018-08-01') |>
  select (org_code,
          period,
          attendances,
          type)                            # have included type back in 

# look at the data

# lets pivot
data_wide <- data_long |>
  pivot_wider(names_from = period,
              values_from = attendances)

# lets do a complex version with more sites
data_long <- data |>
  filter(org_code %in% c('RQM',
                         'RJ1', 
                         'RF4'), 
         # type == '1',                    # have not removed the type
         period >= '2018-08-01') |>
  select (org_code,
          period,
          attendances,
          type)                            # have included type back in 

# look at the data

# lets pivot
data_wide <- data_long |>
  pivot_wider(names_from = period,
              values_from = attendances)

# lets do a complex version with breaches as well - another period dependent 
# variable
data_long <- data |>
  filter(org_code %in% c('RQM',
                         'RJ1', 
                         'RF4'), 
         period >= '2018-08-01') |>
  select (org_code,
          period,
          attendances,
          breaches,                      # have breaches type back in 
          type)                           

# look at the data

# lets pivot 
data_wide <- data_long |>
  pivot_wider(names_from = period,
              values_from = attendances)

# yuck not what we want - reset the data and lets try again
data_long <- data |>
  filter(org_code %in% c('RQM','RJ1', 'RF4'), 
         period >= '2018-08-01') |>
  select (org_code,
          period,
          attendances,
          breaches,                      # have breaches type back in 
          type)                           

# lets pivot 
data_wide <- data_long |>
  pivot_wider(names_from = period,
              values_from = c(attendances, 
                              breaches))

# r has given us automatically generated column names
# (there are options to change how that is handled, but not going to go into 
# that now)

# lets make our wide data long

# start with a basic wide dataset again

data_wide <- data |>
  filter(org_code == 'RQM',
         type == '1',
         period >= '2018-08-01') |>
  select (org_code,
          period,
          attendances)

# lets pivot
data_wide <- data_wide |>
  pivot_wider(names_from = period,
              values_from = attendances)

# and make it long
data_long <- data_wide |>
  pivot_longer(cols = where(is.numeric),
               names_to = 'period',
               values_to = 'attendances')

# not going to lie, pivoting wide data to long is harder and requires much more
# wrangling, however the principle is the same and so going to move on 

#####################
# rolling functions #
#####################

# lets just do some other bits of wrangling
# say we wanted a 6 month rolling mean of attendances by each of the sites in
# our data...

library(zoo)

# zoo has a lovely function for rolling windows

data <- ae_attendances

data_roll <- data |>
  filter(org_code %in% c('RQM',
                         'RJ1', 
                         'RDD')
  ) |>
  arrange(org_code,
          type,
          period) |>
  mutate(rolling = rollapply(attendances,
                             6,
                             mean,
                             align = 'right',
                             fill = NA),
         .by = c(org_code,
                 type))

# <<< Over to you >>>>

# see if you can change the window to 3 months
# then add an additional new column with a median over 3 months
# with the median, see if you can calculate it on the middle time period
# so that it is the median of the month behind and month ahead
# and replace any blanks with 9999








#########################

#####################
# row numbers       #
# and               #
# date manipulation #
##################### 

# adding a row number - useful for calculating times between things
# or identifying things like referral time to second contact etc

data_row <- data |>
  filter(org_code %in% c('RQM',
                         'RJ1', 
                         'RDD')) |>
  arrange(org_code,
          type,
          period) |>
  mutate(row_number = row_number())

# row number per org_code
data_row <- data |>
  filter(org_code %in% c('RQM',
                         'RJ1', 
                         'RDD')) |>
  arrange(org_code,
          type,
          period) |>
  mutate(row_number = row_number(),
         .by = c(org_code, type))

# row number per date (dense rank)
data_row <- data |>
  filter(org_code %in% c('RQM',
                         'RJ1', 
                         'RDD')) |>
  arrange(period) |>
  mutate(row_number = dense_rank(period))

# row number per date (dense rank) but in reverse order
# normally would put a '-' in front of the variable to rank by and it would
# rank its inverse which would work just fine
# however you can't inverse a date. Therefore have reordered them and then 
# converted the rank into an absolute value
# (horrible but it works) 
# (this was an answer to a student question and so left it here)
data_row <- data |>
  filter(org_code %in% c('RQM',
                         'RJ1', 
                         'RDD')) |>
  mutate(row_number = abs(desc(dense_rank(period))))

# row number per date - jump missing (rank)
data_row <- data |>
  filter(org_code %in% c('RQM',
                         'RJ1', 
                         'RDD')) |>
  arrange(period) |>
  mutate(row_number = min_rank(period))

# now lets remove 2018 and check the row numbers still work on the new dataset

data_row <- data |>
  filter(org_code %in% c('RQM',
                         'RJ1', 
                         'RDD'),
         !between (period,  # note the ! in front for the between to convert it 
                   # into a not between
                   as.Date('2018-01-01') , 
                   as.Date('2018-12-31'))
  ) |>  
  arrange(org_code,
          type,
          period) |>
  mutate(row_num = row_number(),
         .by = org_code, type)

# the ! is awesome - for example could add it in front of the org code 
# to filter everything except for those org codes

# <<< Over to you >>>>

#  adjust the code above to remove the year 2017 and
#  return only the first 3 rows for only type 1 for each organisation





#########################

#####################
# grouping by dates #
#####################

# grouping our data by year and getting totals
data_year <- data |>
  filter(org_code == 'RQM',
         type == '1') |>
  group_by(year_total = floor_date(period,       # note calling a new name to 
                                   # the grouped variable
                                   'year')) |>
  summarise (total_attendances = sum(attendances),
             total_breaches = sum(breaches),
             median_admissions = median(admissions, 
                                        na.rm = TRUE))

# calculating a financial year
data_finance <- data |>
  filter(org_code == 'RQM',
         type == '1') |>
  mutate(finance_year = ifelse(month(period) >= 4, 
                               year(period) + 1, 
                               year(period)))

# <<< Over to you >>>>

# create a dataframe that contains a summary of sites RF4 and RQ3
# and returns the maximum number of type 1 attendances 
# across those sites by financial year








#########################

######################
# cutting up strings #
# and                #
# parsing numbers    #
######################

# lets see if we can extract some more info from our data

# our org_code contains numbers and letters  
# what if we want to pull out just the numbers from those org_codes?

data_org_code_numbers <- data |>
  mutate(org_code_number = parse_number(as.character(org_code), 
                                        na = c("NA", 
                                               "Nothing")))

# this does throw up a warning as a number of org_codes do not have numbers in 
# them it also is a little messy, but gives and idea of what can be done

# maybe we want to filter our data to any org code that contains a 'R' or a 'P' 
# anywhere

data_filt <- data |>
  filter (str_detect (org_code,'R') |      # note the use of | to denote 'or'
            str_detect (org_code,'P'))

# <<< Over to you >>>>

# what organisations code have a number in them over 50?
# can you return a dataframe with just the org_codes of those with a number over
# 50





#########################

# sometimes we want to shorten strings 
# we can do this by words or characters

example <- 'This is an example of a long sentence that I would like to shorten as it is far too long'

# by characters

substr(example, start = 1, stop = 15) 

# by words 

word(example, start = 1, end = 4, sep = fixed(' ')) # note uses end and not stop

# removing words 
# useful for handling really long hospital names

################################
# make hospital names readable #
################################

long_hospital_name <- 'Boggins University HosPital NHS Trust'

# lets change this to 'Boggins HosPital'

library(tm)
# tm is a text mining library but has some nice text features

short_hospital_name <- removeWords(long_hospital_name, 
                                   c('University', 
                                     'NHS', 
                                     'Trust'))

short_hospital_name

# close but now we have odd spaces between our words and at the end

# nice little function call string squish

short_hospital_name <- str_squish(short_hospital_name)

short_hospital_name

# this all will work within a dataframe as well

# <<< Over to you >>>>

# we still have an annoying rogue capital P in our hospital
#  use your google foo to find a str_ function to fix it
#    we want 'Boggins Hospital'





#########################

#####################
# intro to  factors #
#####################

# a quick note on factors
# factors are a datatype that converts a character into a ordinal datatype
# think low medium and high

data <- ae_attendances


data <- data |>
  mutate(
    attendance_grouping = case_when(
      attendances < 5000 ~ 'Less than 5,000',
      attendances < 10000 ~ '5,000 to 9,999',
      attendances < 15000 ~ '10,000 to 14,999',
      attendances < 20000 ~ '15,000 to 19,999',
      attendances < 25000 ~ '20,000 to 24,999',
      attendances >= 25000 ~ '25,000 and over',
      .default = 'ERROR - does not compute'
    )
  )

# lets have a look at our attendance groupings
data_fact <- data |>
  filter (period == '2016-04-01',
          type == '1') |>
  arrange (attendance_grouping)


# lets do a super quick plot
data_fact |> 
  ggplot(aes(x = attendance_grouping)) +
  geom_bar()

# lets change our character data type to a factor data type
# we can then make it ordinal
data_fact <- data_fact |>
  mutate(attendance_grouping = factor(
    attendance_grouping,
    levels = c(
      "Less than 5,000",
      "5,000 to 9,999",
      "10,000 to 14,999",
      "15,000 to 19,999",
      "20,000 to 24,999",
      "25,000 and over")
  )
  )

# lets do our plot again
data_fact |> 
  ggplot(aes(x = attendance_grouping)) +
  geom_bar()

# also if we look at our dataframe again, we can sort it by that factor too

# this can be really useful to show groupings of providers by systems etc
# we can also reorder factors based on a different variable, for instance you 
# may want to order your providers by number of attendances or highest 
# performance

# there are further funky things with factors, but will have to skim over.
# just to say you can re order your factors for build your factors on other 
# variables.

# WARNING - if you set your data as factors, R will not like you adding data 
# into that column if is not one of the factors you have created.
# There are ways of doing this but don't have time now to go into detail
# It is also possible to make factors more dynamically - again no time

#########################
# intro to dynamic text #
#########################

# A quick note on combining text and variables - useful for writing commentary 
# or dynamic labels

# Say we want to create a sentence that says 
# 'The maximum number of attendances was 20000' (or whatever it is)

# we can create join a string together with the paste0 command 

text <- paste0('The maximum number of attendances was ', 
               max(data$attendances))

# you can make longer strings and switch between text and non text with commas

text <- paste0('The maximum number of attendances was ', 
               max(data$attendances), 
               ' and the lowest was ', 
               min(data$attendances))

# the glue library has functions that are easier to use than paste
library (glue)

max_attend <- max(data$attendances)
min_attend <- min(data$attendances)

glue('The maximum number of attendances was {max_attend} and the lowest was {min_attend}')
# this does the same with with considerably fewer brackets and commas

# check out my git hub for a whole mini tutorial on dynamic text

############################################
# SPC - statistical process control graphs #
############################################

# Plot the dots - SPC charts
library(NHSRplotthedots)

data_spc <- data |>
  filter(org_code == 'RVR',
         type == '1')

data_spc |>
  ptd_spc(value_field = attendances,
          date_field = period)

# <<< Over to you >>>>

#  add in a target of 17500
#  we actually want to show improvement as a reduction





#########################

# we now want to create a chart for each attendance type
data_spc <- data |>
  filter(org_code == 'RVR')

# simply add a facet field
data_spc |>
  ptd_spc(value_field = attendances,
          date_field = period,
          improvement_direction = 'decrease',
          facet_field = type)

# not bad but looks a bit clumpy and we need to tweak a few things to make this 
# a pretty ggplot 

# turn our ptd_spc into an object
plot_spc <- data_spc |>
  ptd_spc(value_field = attendances,
          date_field = period,
          improvement_direction = 'decrease',
          facet_field = type)

# feed that object into ptd_create_ggplot

plot_spc |> 
  ptd_create_ggplot(fixed_y_axis_multiple = FALSE,
                    x_axis_date_format = "%b %y",
                    x_axis_breaks = "2 months")

# <<< Over to you >>>>

#  Create a faceted plot for type 1 attendances RQM, RJ1 and RDD
#   Change the point size to look nicer
#    Change the x axis label to date rather than period
#      Make any other changes you feel would be useful to describe chart





#########################

################################
# Basic functional programming #
################################

# say we want to do something many times,  we could just copy and paste our 
# code, but that gets really dull really quickly
# it also means if we update something, we have to update it in all the 
# duplicate instances of that code
# this gets super dull super quickly

# so what we can do is set up a function do repeat a number of steps

# lets start simple

x <-  5
y <- 10
z <- 15

# we want to triple each of our variables and then 
# we could do x*3, y*3, z*3 


# so in long hand we could do
x_mult <- x * 3


# but we would have to repeat all of that again if we wanted to check y & z and
# change all the variables

# so lets build a function
# we start with naming our function
# we then do all the calculations
# we then return the result
# NOTE - a function can only return one result, but later we will be clever in 
#        how this 'one result' is built

times_three <- function (input) {
  return (input * 3)
}

# we can now test it with our variables
times_three(x)

times_three(y)

# or put in a new number completely
times_three(7)

# NOTE a function can only return one object
# you can add more than one variable into a function separated by commas

x_times_y <- function (x, y) {
  result <- x * y
  b <- 150
  return (print(paste0('The answer is ', result, ' and b is ', b)))
}

var <- x_times_y (x, y)

# a function will only return one thing.  
# You do not have to specify what it returns with a return function
# R will by default return the last thing in a function

x_times_y_no_return <- function (x, y) {
  result <- x * y
  print(paste0('The answer is ', result))
}

x_times_y_no_return (5, 4)

# going back to our curly brackets and 'scope' for a function
# what happens in a function's scope is not in the global environment
# for instance the variable 'result' has not been created
# it only exists within the scope
# a function's scope can not affect outside of the function

test <- 'monkey'

x_times_y_scope <- function (x, y) {
  result <- x * y
  test <- 'moo'
  print(paste0('The answer is ', test))
}

# before we run this what will happen to the variable 'test'?
x_times_y_scope (5, 4)


# you can also add multiple steps in a function
x_times_y_plus_ten_date <- function (x, y) {
  result <- x * y
  day_of_month <- day(Sys.Date())
  if_else(day_of_month > 15, 
          result + 10, 
          result)
}

# without running it please type into the chat the result of the function
x_times_y_plus_ten_date (3, 10)

# functions get pretty convoluted pretty quickly and can be hard to read
# which is why it is good practice to write doc strings for functions 

x_times_y_plus_ten_date <- function (x, y) {
  # This function multiplies two numbers (x and y) and adds 10 to the result 
  # if the current day of the month is greater than 15. Otherwise, it simply 
  # returns the product of x and y.
  #
  # @param x [numeric] The first number to be multiplied.
  # @param y [numeric] The second number to be multiplied.
  #
  # @return The product of x and y, with 10 added if the current day is past 
  # the 15th.
  #
  # @examples
  # Example 1: Today is the 10th of the month
  # x <- 5
  # y <- 2
  # result <- x_times_y_plus_ten_date(x, y)
  # print(result) # Output: 10
  #
  # Example 2: Today is the 20th of the month
  # x <- 3
  # y <- 4
  # result <- x_times_y_plus_ten_date(x, y)
  # print(result) # Output: 22
  
  result <- x * y
  day_of_month <- day(Sys.Date())
  if_else(day_of_month > 15, 
          result + 10, 
          result)
}

# now this is an extreme example with multiple examples, at the most basic
# you should include a description and a variable description
# future you or anyone else reading the code will be very thankful!

# this function will fall over if you feed it the wrong data type, more
# advanced functions can handle error checking and testing, but that's for 
# another day

# <<< Over to you >>>>

#  tweak the above function so that instead of times the first two inputs and 
#  add 10 to the result based on the day in the month it adds a number you 
#  specify (another variable)







#########################

# we can apply our made up new functions to a dataframe

data_fun <- data |>
  filter(org_code %in% c('RQM', 'RJ1', 'RDD'),
         type == '1') |>
  select (-breaches)

# perhaps the most ludicrous column name yet!
data_fun <- data_fun |>
  rowwise() |>
  mutate(attend_times_admit_maybe_plus_ten = 
           x_times_y_plus_ten_date (attendances, admissions, 10))


# this is a bit of a silly example but shows what potentially can be done.
# can be great for calculating rates per 10,000 

# lets do another quick example function

# <<< Over to you >>>>

# create a function to calculate the mean of 3 numbers
# without using the 'mean' function
# for extra credit
# create a function that calculates the mean over any set of numbers
# HINT: How would you have a multiple length input, 
#                                 obviously not a single variable...
# How you you then determine what its *length* is?



#########################

# is not just data functions, we can set up a plot to be a function
# say we had our lovely SPC chart set up the way we want it and we just want 
# to tweak the site 

plot_site <- function (site) {
  
  # we now want to create a for each attendance type
  data_spc <- data |>
    filter(org_code == site)      # note this is where we are using our 'site' 
  # variable
  
  # turn our ptd_spc into an object
  plot_spc <- data_spc |>
    ptd_spc(value_field = attendances,
            date_field = period,
            improvement_direction = 'decrease',
            facet_field = type)
  
  # feed that object into ptd_create_ggplot
  
  return (plot_spc |> 
            ptd_create_ggplot(fixed_y_axis_multiple = FALSE,
                              x_axis_date_format = "%b %y",
                              x_axis_breaks = "2 months"))
}


plot_site('RJ1')

plot_site('RDD')

# it is good practice for a function not to call on anything outside of the 
# function
# in this instance we are calling on our 'data' which does not exist within the 
# function
# this can cause issues, especially if we later change something in the data
# so best practice is to feed the data into function.
# We can set it to a default, but this allows us to change it later without 
# issue
# or to point it at another dataset if we want to without having to copy the 
# function


plot_site <- function(site = 'RJ1', df = data) {# this is where we set a default
  
  # we now want to create a for each attendance type
  data_spc <- df |>                 # note this is where pulling in our data
    filter(org_code == site)      
  
  # turn our ptd_spc into an object
  plot_spc <- data_spc |>
    ptd_spc(value_field = attendances,
            date_field = period,
            improvement_direction = 'decrease',
            facet_field = type)
  
  # feed that object into ptd_create_ggplot
  
  return (plot_spc |> 
            ptd_create_ggplot(fixed_y_axis_multiple = FALSE,
                              x_axis_date_format = "%b %y",
                              x_axis_breaks = "2 months"))
}

# works just the same 
plot_site('RJ1')

# ok so we have a nice facet plot for a single site, but now I want to create 
# the same plot but over a number of sites, or even all the sites
# of course I could just call the function for each and every site, however
# what if there is a new site or a site is removed.  I then have to keep a 
# curated site list.  Sounds like hard work.  Yerk!


# the same function but with added doc string

plot_site <- function (site, df = data) {
  #
  # This function generates a PTD (Plot the dots)ggplot for a specific site 
  # based on attendance data. It utilizes pre-defined functions like 
  # `ptd_spc` and `ptd_create_ggplot` (assumed to be available).
  #
  # @param site The organizational code of the site you want to plot data for.
  # @param df (default = data) A data frame containing the attendance data.
  #        This data frame should have columns named `org_code`, `attendances`, 
  #        `period`, and `type`.
  #
  # @details This function filters the data frame based on the provided `site` 
  #          code. It then uses `ptd_spc` to calculate PTD values and improvement 
  #          direction (assumed to be decrease based on the code) for each 
  #          attendance type (`type`). Finally, it utilizes `ptd_create_ggplot` 
  #          to create the PTD ggplot with specific formatting options 
  #          (formatting options are assumed to be set in `ptd_create_ggplot`).
  #
  # @return A ggplot object representing the PTD for the specified site.
  #
  # @examples
  # 
  # Assuming you have data loaded in a data frame named 'data' containing 
  # columns 'org_code', 'attendances', 'period', and 'type', you can use the 
  # following code to generate a PTD plot for site 'ABC':
  #
  # plot_site("ABC", data)
  # This will display the ggplot object
  
  data_spc <- df |>     
    filter(org_code == site)      
  
  # turn our ptd_spc into an object
  plot_spc <- data_spc |>
    ptd_spc(value_field = attendances,
            date_field = period,
            improvement_direction = 'decrease',
            facet_field = type)
  
  return (plot_spc |> 
            ptd_create_ggplot(fixed_y_axis_multiple = FALSE,
                              x_axis_date_format = "%b %y",
                              x_axis_breaks = "2 months"))
}


####################
# simple for loops #
####################

# a loop is a element of that repeats a portion of code a desired number of 
# times
# often with an iteration of values or variables

# lets look at a simple sequence

seq(1:10)

# this gives us a simple sequence from one to ten
# we want to print out the sequence number plus 5

# we can make a loop to do this

for (i in seq(1, 10)) {          # traditionally variables in a loop start at i 
  # (they just do!)
  # what will happen is R will run the loop and for the first iteration 
  # i will be 1 and then 2 and then 3 etc 
  i_plus_five <- i + 5
  result <- paste0(i,' plus 5 equals ', i_plus_five)
  print(result)
}

# again with the curly brackets and scope
# a for loop does have global scope, if you look i_plus_five
# exists in the global environment, only with its last value
# it was over written each time time in the loop


# we can mess about with seq to come up with all sorts of number patterns

seq(50, nrow(data), 500)

# this makes a number sequence that starts at 50, ends at the number of rows in 
# our data (12765) and steps in increments of 500

# however the real magic starts is when we feed in a vector of data

vector <- c('Bob', 'Pete', 'Mary')

for (i in vector) {                 
  result <- paste0('Hello ', i)
  print(result)
}

# so now we can look at running our function but within a loop 
# almost that simple but we need to recall that a function can only return one 
# result
# we would really like to collate all of those results into one object
# we do this by utilising a list object
# a list object is a super special multi dimensional thing that can contain
# a mix of variables, dataframes, plot objects and any combination thereof

# we can not create a list from within our loop, otherwise we would be creating it
# blank on each iteration
# so lets make a blank list outside of our loop

plot_list <- list ()

# this is the vector we will feed to our loop
vector <- c('RQM', 'RJ1', 'RDD')

for (i in vector) {
  plot_list[i] <- plot_site(i)
}

# lets call some of our plots from the list
plot_list['RQM']

plot_list['RJ1']

# it is also possible to call the plot from its position in the list
plot_list[1]


# lets just say for example we wanted to run across all sites in a dynamic way
# we could create a vector of all the site names from the data

vector <- unique(data$org_code)

vector

# this does create a list 274 long and so lets not run it now, 
# but we could feed that into the loop if we really really wanted to


###########
# the end #
###########

# we made it!

# looking to build some further courses 

# pretty tables
# pretty graphs
# markdown/quarto