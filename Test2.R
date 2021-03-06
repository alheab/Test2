library(readxl)
library(tidyverse)
library(broom)
library(MuMIn)
library(knitr)
library(tidyr)
library(stringr)
library(dplyr)
library(lubridate)


CMadres<- read_excel("C:/Users/Julio C�sar/Desktop/2018-02.13 Datos Alejandra Herrer�as/Documents/TesisM.C/Datos Ale-2015.xlsx",sheet = "CMadres")

CHijas <- read_excel("C:/Users/Julio C�sar/Desktop/2018-02.13 Datos Alejandra Herrer�as/Documents/TesisM.C/Datos Ale-2015.xlsx",sheet = "Fragmentos")

CoorCM<- read_excel("C:/Users/Julio C�sar/Desktop/2018-02.13 Datos Alejandra Herrer�as/Documents/TesisM.C/Datos Ale-2015.xlsx",sheet = "Mapa")


CM<-CMadres %>% filter(!is.na(`DiamMin`),!is.na(Altura),!is.na(`PorcentMuerto`),
                       !is.na(PorcentVivo),!is.na(`AreaMuerta`))


mod1<-lm(AreFrag.m2 ~ frag,data=CM)
mod2<-lm(AreFrag.m2 ~ frag+Signo,data=CM)
mod3<-lm(AreFrag.m2 ~ frag+Signo+Signo2+algas,data=CM)
mod4<-lm(AreFrag.m2 ~ frag:Signo,data=CM)
mod5<-lm(AreFrag.m2 ~ frag*Signo*Signo2*algas,data=CM)


Modelo1<-glance(mod1) %>% dplyr::select(r.squared,df,AIC) %>% mutate(Modelo="mod1")
Modelo2<-glance(mod2) %>% dplyr::select(r.squared,df,AIC) %>% mutate(Modelo="mod2")
Modelo3<-glance(mod3) %>% dplyr::select(r.squared,df,AIC) %>% mutate(Modelo="mod3")
Modelo4<-glance(mod4) %>% dplyr::select(r.squared,df,AIC) %>% mutate(Modelo="mod4")
Modelo5<-glance(mod5) %>% dplyr::select(r.squared,df,AIC) %>% mutate(Modelo="mod5")


Modelos<-bind_rows(Modelo1,Modelo2,Modelo3,Modelo4,Modelo5) %>% arrange(
  AIC)%>% mutate(DeltaAIC = AIC-min(AIC))
kable(Modelos, caption = "Tabla comparativa con las caracter�sticas principales de los modelos ")



###################Plots#####################
ggplot(CM, aes(x = Signo, y = AreFrag.m2)) + geom_point(aes(
  color=Signo2,size = frag))+theme_classic()+scale_color_manual(
    values=c("green2","black", "gray", "darkseagreen1","darkslategray3","goldenrod","snow2","Yellow"))


ggplot(CM, aes(x = DiamMax, y = AreFrag.m2)) + geom_point(aes(
  color = Signo, shape=Signo2), size = 3)

ggplot(CM)+geom_histogram(aes(X=DiamMax))

{r,fig.width=350, fig.height=250,echo=FALSE}
library(png)
library(grid)
appimg <- readJPG(system.file("C:/Users/Julio C�sar/Pictures/Papeles/coral.png"))
grid.raster(appimg)


