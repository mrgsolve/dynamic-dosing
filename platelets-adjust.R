library(mrgsolve)
library(dplyr)
library(patchwork)
library(ggplot2)

theme_set(theme_minimal())
options(pillar.width = Inf)

mod <- mread("model/platelet.mod")

mod <- param(mod, ADJUST  = 1, BMAX = 100, UNTIL = 168*52)
mod <- update(mod, outvars = outvars(mod)$capture)
mod <- update(mod, end = 168*55, delta = 2)

data <- expand.ev(ID = 1:300, amt = 0, evid = 2)

set.seed(10203)
out <- mrgsim(mod, data = data, obsonly = TRUE)

sims <- filter(out, max(epoch)==3, .by = ID)
sims <- filter(sims, ID==nth(unique(ID), 1))

sims <- mutate(sims, WEEK = time / 168)
vis <- filter(sims, visit==1)

wk <- seq(0,52,4)

p1 <- 
  ggplot(sims) + 
  geom_line(aes(WEEK, PLATELET), color = "darkgrey", lwd = 1) + 
  geom_point(data = vis, aes(WEEK, Y), color = "firebrick") + 
  geom_hline(yintercept = c(25,50), lty = 2, lwd = 0.6) + 
  scale_y_continuous(limits = c(0, 200), breaks = c(25, seq(0,500,50))) +
  scale_x_continuous(breaks = wk) + 
  labs(x = "Time (weeks)", y = "Platelets (10^9/L)") 

p2 <- 
  ggplot(sims) + 
  geom_line(aes(WEEK, current_dose), lwd=0.6) + 
  scale_y_continuous(breaks = c(0, 100, 150 ,200), limits = c(0,210)) +
  scale_x_continuous(breaks = wk) + 
  labs(y = "Dose (mg)", x = "Time (weeks)")

p3 <- 
  ggplot(sims) + 
  geom_line(aes(WEEK, UNBOUND)) +
  scale_x_continuous(breaks = wk) +
  labs(y = "Unbound PK (ng/mL)", x = "Time (weeks)")


p <- (p1 / p2 / p3) + plot_layout(axes="collect", heights = c(2,1.1,1.1)); p

ggsave("platelets.pdf", width = 5, height = 6, scale = 1)

