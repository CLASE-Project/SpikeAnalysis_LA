library(ggrain)
library(ggplot2)

ggplot(iris, aes(1, Sepal.Width, fill = Species, color = Species)) +
  geom_rain(alpha = .6,
            boxplot.args = list(color = "black", outlier.shape = NA)) +
  theme_classic() +
  scale_fill_brewer(palette = 'Dark2') +
  scale_color_brewer(palette = 'Dark2')



ggplot(iris, aes(1, Sepal.Width, fill = Species, color = Species)) +
  geom_rain(alpha = .5, rain.side = 'l',
            boxplot.args = list(color = "black", outlier.shape = NA),
            boxplot.args.pos = list(
              position = ggpp::position_dodgenudge(x = .1), width = 0.1
            )) +
  theme_classic() +
  scale_fill_brewer(palette = 'Dark2') +
  scale_color_brewer(palette = 'Dark2') +
  guides(fill = 'none', color = 'none')








set.seed(42) # the magic number

iris_subset <- iris[iris$Species %in% c('versicolor', 'virginica'),]

iris.long <- cbind(rbind(iris_subset, iris_subset, iris_subset), 
                   data.frame(time = c(rep("t1", dim(iris_subset)[1]), rep("t2", dim(iris_subset)[1]), rep("t3", dim(iris_subset)[1])),
                              id = c(rep(1:dim(iris_subset)[1]), rep(1:dim(iris_subset)[1]), rep(1:dim(iris_subset)[1]))))

# adding .5 and some noise to the versicolor species in t2
iris.long$Sepal.Width[iris.long$Species == 'versicolor' & iris.long$time == "t2"] <- iris.long$Sepal.Width[iris.long$Species == 'versicolor' & iris.long$time == "t2"] + .5 + rnorm(length(iris.long$Sepal.Width[iris.long$Species == 'versicolor' & iris.long$time == "t2"]), sd = .2)
# adding .8 and some noise to the versicolor species in t3
iris.long$Sepal.Width[iris.long$Species == 'versicolor' & iris.long$time == "t3"] <- iris.long$Sepal.Width[iris.long$Species == 'versicolor' & iris.long$time == "t3"] + .8 + rnorm(length(iris.long$Sepal.Width[iris.long$Species == 'versicolor' & iris.long$time == "t3"]), sd = .2)

# now we subtract -.2 and some noise to the virginica species
iris.long$Sepal.Width[iris.long$Species == 'virginica' & iris.long$time == "t2"] <- iris.long$Sepal.Width[iris.long$Species == 'virginica' & iris.long$time == "t2"] - .2 + rnorm(length(iris.long$Sepal.Width[iris.long$Species == 'virginica' & iris.long$time == "t2"]), sd = .2)

# now we subtract -.4 and some noise to the virginica species
iris.long$Sepal.Width[iris.long$Species == 'virginica' & iris.long$time == "t3"] <- iris.long$Sepal.Width[iris.long$Species == 'virginica' & iris.long$time == "t3"] - .4 + rnorm(length(iris.long$Sepal.Width[iris.long$Species == 'virginica' & iris.long$time == "t3"]), sd = .2)

iris.long$Sepal.Width <- round(iris.long$Sepal.Width, 1) # rounding Sepal.Width so t2 data is on the same resolution
iris.long$time <- factor(iris.long$time, levels = c('t1', 't2', 't3'))



ggplot(iris.long[iris.long$time %in% c('t1', 't2'),], aes(time, Sepal.Width, fill = Species)) +
  geom_rain(alpha = .5, rain.side = 'f',
            boxplot.args.pos = list(width = .1,
                                    position = ggpp::position_dodgenudge(
                                      x = c(-.13, -.13, # pre versicolor, pre virginica
                                            .13, .13))), # post; post
            violin.args.pos = list(width = .7,
                                   position = position_nudge(x = c(rep(-.2, 256*2), rep(-.2, 256*2),# pre; pre
                                                                   rep(.2, 256*2), rep(.2, 256*2))))) + #post; post
  theme_classic() +
  scale_fill_manual(values=c("dodgerblue", "darkorange")) +
  guides(fill = 'none', color = 'none')
#> Warning: Using the `size` aesthetic with geom_polygon was deprecated in ggplot2 3.4.0.
#> ℹ Please use the `linewidth` aesthetic instead.
#> 
#> 
#> 




ggplot(iris.long[iris.long$time %in% c('t1', 't2'),], aes(time, Sepal.Width, fill = Species, color = Species)) +
  geom_rain(alpha = .5, rain.side = 'f2x2', id.long.var = "id",
            violin.args = list(color = NA, alpha = .7)) +
  theme_classic() +
  scale_fill_manual(values=c("dodgerblue", "darkorange")) +
  scale_color_manual(values=c("dodgerblue", "darkorange")) +
  guides(fill = 'none', color = 'none')
#> Warning: Duplicated aesthetics after name standardisation: alpha