library(tidyverse)
library(dash)
library(ggplot2)
library(plotly)


data_df = read.csv("data/processed_data.csv")
price_subset = list(
  list(print="Total Monthly cost", column="all"),
  list(print="Basic Groceries", column= "grocery_for_one_person"),
  list(print="Childcare", column ="childcare_for_one_child"),
  list(print = "Entertainment", column ="entertainment"),
  list(print ="Fitness", column ="fitness"),
  list(print="Monthly Rent", column="rent_for_one_person"),
  list(print="Public Transport", column="transportation_public"),
  list(print="Shopping", column="shopping"),
  list(print="Utilities", column="utility_bills")
)

cities = unique(data_df$city)
regions = unique(data_df$region)


# names = list(fnameDict.keys())
# nestedOptions = fnameDict[names[0]]
# 
# exp_earn_plot = function(){
#   
# 
#   # subset = data_df %>%
#   #   filter(city %in% city_name) %>%
#   #   mutate(monthly_surplus = Expected_earnings - all)
#   
#   
#   p <- ggplot(data_df, aes(
#     x= city,
#     y=monthly_saving, 
#     fill= city))+
#     geom_col(show.legend = FALSE)  +
#     labs(x= "Monthly Surplus (USD)", y="City", 
#          title= "Salary minus the monthly cost of living")
#   ggplotly(p)
# }

app = Dash$new()

app$layout(dbcContainer(
  list(dccDropdown( id= "city-names",
                options = data_df %>%
                  select(city) %>%
                  pull() %>%
                  purrr::map(function(col) list(label = col, value = col)),
                multi = TRUE, 
                value=c('Vancouver','Calgary','New York City','London')
              ),
       dccInput(id="expected-earnings", 
                      type="number",
                      placeholder=2000,
                      value=2000),
    dccGraph(id='plot-area'))
  )
)

app$callback(
  output('plot-area', 'figure'),
  list(input('city-names', 'value'),
       input('expected-earnings', 'value')),
  function(cities, earning) {
    subset <- data_df %>%
      filter(city %in% cities) %>%
      mutate(surplus = earning - all  )
    p <- ggplot(subset, aes(
      x = city,
      y = surplus, 
      fill = city))+
      geom_col(show.legend = FALSE)  +
      labs(x = "Monthly Surplus (USD)", y = "City", 
           title = "Salary minus the monthly cost of living")
    ggplotly(p)
  }
)

        
app$run_server(debug)
