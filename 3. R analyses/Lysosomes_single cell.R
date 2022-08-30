data = read.table("/Users/Lea/Documents/Experiences These/19-09-03 B vs. droplets #11/Rigides nouvelles/s2-1/s2-1.txt", header=T)
path ="/Users/Lea/Documents/Experiences These/19-09-03 B vs. droplets #11/Rigides nouvelles/s2-1"
setwd(path)
nrow(data)

#dataset2 <- dataset %in% filter(N == 2|4|6|8|10)
dataset_left <- data[seq(2, n/2, 2), c("Mean", "Slice")]
dataset_right <- data[seq(n/2+1, n, 2), c("Mean", "Slice")]

#--Libraries
library(ggplot2)
library(scales)
library(cowplot)
library(MASS)
library(plyr)
library(sm)

#--Theme
theme_jacques <- theme(
  plot.title=element_text(size=11, 
                          face="bold", 
                          family="Arial",
                          hjust=0.5,
                          lineheight=1.2),
  panel.grid.major = element_blank(), 
  panel.grid.minor = element_blank(), 
  panel.border = element_blank(),
  panel.background = element_blank(),
  axis.text.x=element_text(size=14, color='black'),
  axis.text.y=element_text(size=14, color='black'),
  axis.title.x=element_text(size=14), 
  axis.title.y=element_text(size=14),
  axis.line = element_line(color="black", size = 0), 
  legend.position = c(0.6, 0.9),
  legend.title=element_blank()
)

#--PLOTS
# 1. Left cell part
p1 <- ggplot(data=dataset_left, aes(dataset_left$Slice, dataset_left$Mean)) +
  geom_point(alpha = 0.5) +
  #scale_x_continuous (limits = c(0, 60)) +
  #scale_y_continuous (limits = c(0, 3e5)) +
  labs(x = "Slice", y = "Mean Fluorescence (a.u.)")
print(p1)

# 1. Right cell part
p2 <- ggplot(data=dataset_right, aes(dataset_right$Slice, dataset_right$Mean)) +
  geom_point(alpha = 0.5) +
  theme_jacques +
  #scale_x_continuous (limits = c(0, 60)) +
  #scale_y_continuous (limits = c(0, 3e5)) +
  labs(x = "Slice", y = "Mean Fluorescence (a.u.)")
print(p2)

# 3. Plot left and right on the same graph
plot_grid(p1, p2, labels = c("A", "B"))

dataset_ratio <- merge(dataset_left, dataset_right, by ="Slice")
dataset_ratio <- cbind(dataset_ratio, "Ratio"=dataset_right$Mean/dataset_left$Mean)
dataset_ratio <- cbind(dataset_ratio, "Minutes"=(dataset_ratio$Slice)*n_timeframe-i_frame) #Modify: n_timeframe = time between frames
#                                                                                                   i_frame = initial frame for which cell-droplet encounter occurs
dataset_ratio <- cbind(dataset_ratio, "Ratio/Bkg"=dataset_ratio$Ratio*dataset_left[1,1]/dataset_right[1,1]) #Subcript background

#Exponentiel fit
require(minpack.lm)
xx = dataset_ratio$Minutes
yy = dataset_ratio$`Ratio/Bkg`

model <- nlsLM(yy ~ a*(1-exp(- b * xx))+c,
               start = list(a=1.5, b=0, c=1)
)

summary(model)

q <- coef(model)

maFun <- function(x) {
  q[['a']]*(1-exp(-q[['b']] * x))+q[['c']]
}

# 4. Index of Polarization
p4 <- ggplot(data=dataset_ratio, aes(dataset_ratio$Minutes, dataset_ratio$`Ratio/Bkg`)) +
  geom_point(alpha = 0.5) +
  theme_jacques +
  #scale_x_continuous (limits = c(0, 1000)) +
  #scale_y_continuous (limits = c(0, 2)) +
  labs(x = "Time (sec)", y = "Ipol") +
  #geom_vline(xintercept = 810) +
  #stat_function(fun=maFun, col="blue") 
  geom_hline(yintercept = 1)
print(p4)

#--Save plots
ggsave("Name_cellxx.pdf", width = 8.9, height = 6.7, units = "cm")
ggsave("Name_cellxx.png", width = 8.9, height = 6.7, units = "cm")

#--Save (Index of Polarization) table
write.table(dataset_ratio, "Name_cellxx.txt", sep="\t", col.names = NA)
