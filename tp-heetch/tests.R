# tester le chainage ----
c(123, 50, 18,200) %>% mean() %>% round()

# on a l'eqvl de apply, map, ----
my_list <- list(A = c(5,8,7),
                B = c(11,2),
                C = c(56,76,78,55))

  # method 1
     # map the data
list_sum <- lapply(my_list, FUN = sum) # comppute sum
list_sum
lapply(my_list, FUN = mean)  #compute mean
lapply(my_list, FUN = sum) # compute length
    # parse to vector 
my_vector <- unlist(list_sum)

  # method 2: save the output in a vector instead of a 
my_vector <- sapply(my_list, FUN=sum)

# sampling ----
sample(x=1:10, size=30, replace=TRUE) #replace fait un echatillaonage avec remise

# histogram ----
vect_norm <- rnorm(n=100, mean=50, sd=5)
hist(vect_norm, col = "blue")

# more on colors ----
colors() #☻voir les couleurs
vect_norm <- rnorm(n=100, mean=50, sd=5)
hist(vect_norm, col = "blue")
hist(vect_norm, col = rgb(red = 0.2, green=0.2, blue = 0.2, alpha=0.5))
hist(vect_norm, col = rgb(red = 150, green=200, blue = 50, alpha=0.5, maxColorValue = 255))
hist(vect_norm, col = "#2596be25")

