# libraries
library(ggplot2)
library(dplyr)
library(tidyr)
library(zoo)

################################################################################
## Parametros de formatacao comum aos plots
################################################################################
plot.formatos <- theme_bw() +
    theme(axis.text = element_text(size = 10, face = "bold"),
          axis.title = element_text(size = 10, face = "bold"),
          legend.text = element_text(size = 12),
          title = element_text(size = 12),
          plot.margin = margin(2, 0, 0, 0, "pt"))


# srm: mantendo isso aqui por enquanto, mas ja ja sai
# Helper function
end.time <- function(pred.zoo, pred.zoo.original){
    if (min(time(pred.zoo.original)) < min(time(pred.zoo))) {
        end.time <- min(time(pred.zoo))
    } else {
        end.time <- min(time(pred.zoo.original))
    }
    return(end.time)
}

################################################################################
## N de novos casos observados e por nowcasting
## Com linha de média móvel
################################################################################
## COVID

end.time.covid <- end.time(now.pred.zoo, lista.covid$now.pred.zoo.original)

plot.nowcast.covid <- 
    df.covid %>%
    ggplot(aes(x = data)) +
    geom_line(aes(y = estimate.merged), lty = 2, col = "grey") +
    geom_point(aes(y = n.casos, col = "Notificado"), size = 2) +
    geom_point(aes(y = estimate, col = "Nowcasting"), size = 2) +
    geom_ribbon(aes(ymin = lower.merged.pred, ymax = upper.merged.pred),
                fill = RColorBrewer::brewer.pal(3, "Set1")[2], alpha = 0.1) +
    geom_line(aes(y = estimate.merged.smooth), alpha = 0.6, size = 2) +
    scale_x_date(date_labels = "%d/%b") +
    scale_color_manual(name = "", values = RColorBrewer::brewer.pal(3, "Set1")[1:2]) +
    xlab("Dia do primeiro sintoma") +
    ylab("Número de novos casos") +
    plot.formatos +
    theme(legend.position = c(0.2,0.8))
    
## SRAG
end.time.srag <- end.time(now.srag.pred.zoo, lista.srag$now.pred.zoo.original)
plot.nowcast.srag <- plot.nowcast.covid %+% fortify(df.srag)

## OBITOS COVID
end.time.ob.covid <- end.time(now.ob.covid.pred.zoo, lista.ob.covid$now.pred.zoo.original)
plot.nowcast.ob.covid <- plot.nowcast.covid %+% fortify(df.ob.covid)

## OBITOS SRAG
end.time.ob.srag <- end.time(now.pred.zoo, lista.ob.srag$now.pred.zoo.original)
plot.nowcast.ob.srag <- plot.nowcast.covid %+% fortify(df.ob.srag)


################################################################################
## N acumulados de casos (nowcasting) e de casos notificados
## com as projecoes para os próximos 5 dias
################################################################################
## COVID ##
plot.nowcast.cum.covid <-
    now.proj.zoo %>%
    ggplot(aes(Index)) +
    geom_line(data = window(now.proj.zoo, end = max(time(now.pred.zoo))),
              aes(y = now.mean.c, color = "Estimados"), size = 1) +
    geom_ribbon(data = window(now.proj.zoo, start = max(time(now.pred.zoo))),
                aes(ymin = now.low.c, ymax = now.upp.c), fill = "lightgrey") +
    geom_line(data = window(now.proj.zoo, start = max(time(now.pred.zoo))),
              aes(y = now.mean.c, color = "Estimados"), lty = "longdash") +
    geom_line(data = window(now.proj.zoo, end = max(time(now.pred.zoo))),
              aes(y = not.mean.c, color = "Notificados"), size = 1) +
    geom_ribbon(data = window(now.proj.zoo, start = max(time(now.pred.zoo))),
                aes(ymin = not.low.c, ymax = not.upp.c), fill = "lightgrey") +
    geom_line(data = window(now.proj.zoo, start = max(time(now.pred.zoo))),
              aes(y = not.mean.c, color = "Notificados"), lty = "longdash") +
    scale_x_date(date_labels = "%d/%b") +
    plot.formatos +
    scale_color_discrete(name = "") +
    scale_color_manual(name = "", values = RColorBrewer::brewer.pal(3, "Set1")[1:2]) +
    xlab("Dia do primeiro sintoma") +
    ylab("Número acumulado de casos") +
    theme(legend.position = c(0.2,0.8)) +
    scale_y_log10()


## SRAG ##
plot.nowcast.cum.srag <-
    now.srag.proj.zoo %>%
    ggplot(aes(Index)) +
    geom_line(data = window(now.srag.proj.zoo, end = max(time(now.srag.pred.zoo))),
              aes(y = now.mean.c, color = "Estimados"), size = 1) +
    geom_ribbon(data = window(now.srag.proj.zoo, start = max(time(now.srag.pred.zoo))),
                aes(ymin = now.low.c, ymax = now.upp.c), fill = "lightgrey") +
    geom_line(data = window(now.srag.proj.zoo, start = max(time(now.srag.pred.zoo))),
              aes(y = now.mean.c, color = "Estimados"), lty = "longdash") +
    geom_line(data = window(now.srag.proj.zoo, end = max(time(now.srag.pred.zoo))),
              aes(y = not.mean.c, color = "Notificados"), size = 1) +
    geom_ribbon(data = window(now.srag.proj.zoo, start = max(time(now.srag.pred.zoo))),
                aes(ymin = not.low.c, ymax = not.upp.c), fill = "lightgrey") +
    geom_line(data = window(now.srag.proj.zoo, start = max(time(now.srag.pred.zoo))),
              aes(y = not.mean.c, color = "Notificados"), lty = "longdash") +
    scale_x_date(date_labels = "%d/%b") +
    plot.formatos +
    scale_color_discrete(name = "") +
    scale_color_manual(name = "", values = RColorBrewer::brewer.pal(3, "Set1")[1:2]) +
    xlab("Dia do primeiro sintoma") +
    ylab("Número acumulado de casos") +
    theme(legend.position = c(0.2,0.8)) +
    scale_y_log10() 

################################################################################
## Plot do tempo de duplicação em função do tempo 
################################################################################
#ö: lidar com barras de erro negativas
plot.tempo.dupl.covid <-
    td.now %>%
    ggplot(aes(Index, estimativa)) +
    geom_ribbon(aes(ymin = ic.inf, ymax = ic.sup), fill = "lightgrey") +
    geom_line(size = 1.25, colour = RColorBrewer::brewer.pal(3, "Dark2")[1]) +
    scale_x_date(date_labels = "%d/%b", name = "") +
    ##coord_cartesian(ylim = c(0, 50)) +
    ylab("Tempo de duplicação (dias)") +
    plot.formatos 

plot.tempo.dupl.srag  <- plot.tempo.dupl.covid %+% 
    fortify(window(td.now.srag, start = min(time(td.now)))) 

##### OBITOS ####
## COVID
plot.tempo.dupl.ob.covid  <- plot.tempo.dupl.covid %+% 
    fortify(window(td.now.ob.covid, start = min(time(td.now)))) 

## SRAG
plot.tempo.dupl.ob.srag  <- plot.tempo.dupl.covid %+% 
    fortify(window(td.now.ob.srag, start = min(time(td.now)))) 

################################################################################
## Plot do R efetivo em função do tempo
################################################################################
## COVID
plot.estimate.R0.covid <-
    ggplot(data = Re.now.zoo, aes(Index, Mean.R)) +
    geom_ribbon(aes(ymin = Quantile.0.025.R, ymax = Quantile.0.975.R), fill = "lightgrey") +
    geom_line(size = 1.25, colour = RColorBrewer::brewer.pal(4, "Dark2")[3]) +
    scale_x_date( date_labels = "%d/%b", name = "") +
    ylim(min(c(0.8, min(Re.now.zoo$Quantile.0.025.R))), max(Re.now.zoo$Quantile.0.975.R))+
    geom_hline(yintercept=1, linetype = "dashed", col = "red", size = 1) +          
    ylab("Número de reprodução da epidemia") +
    plot.formatos

## SRAG #
plot.estimate.R0.srag <- plot.estimate.R0.covid %+% 
    fortify(window(Re.now.srag.zoo, start = min(time(Re.now.zoo))))

######################################################################
## Tabelas para preencher o html
######################################################################
## COVID ##

# separando os outputs em subpastas yay!
web.path <- paste0("../web/", adm, "_", sigla.adm, "/") 

if (!dir.exists(web.path)) dir.create(web.path)

## Tabela que preenche o minimo e o maximo do nowcast
minmax.casos <- data.frame(row.names = sigla.adm)
min <- as.integer(now.proj.zoo[max(nrow(now.proj.zoo)),2])
max <- as.integer(now.proj.zoo[max(nrow(now.proj.zoo)),3])
data <- format(max(time(now.proj.zoo)), "%d/%m/%Y")
minmax.casos <- cbind(minmax.casos, min, max, data)
write.table(minmax.casos, 
            file = paste0(web.path, "data_forecasr_exp_", adm, "_", tolower(sigla.adm), "_covid.csv"), 
            row.names = TRUE, col.names = FALSE)
# Não é generico, é apenas para o municipio de sp. Tendo mais, tem que atualizar

## Tabela do tempo de duplicação
temp.dupl <- data.frame(row.names = sigla.adm)
min.dias <- as.vector(round(td.now[max(nrow(td.now)), 2], 1))
max.dias <- as.vector(round(td.now[max(nrow(td.now)), 3], 1))
temp.dupl <- cbind(temp.dupl, min.dias, max.dias)
write.table(temp.dupl, 
            file = paste0(web.path, "data_tempo_dupli_", adm, "_", tolower(sigla.adm), "_covid.csv"), 
            row.names = TRUE, col.names = FALSE)


## Tabela do Re
Re.covid <- data.frame(row.names = sigla.adm)
min <- as.factor(round(Re.now.zoo[nrow(Re.now.zoo), 5], 1))
max <- as.factor(round(Re.now.zoo[nrow(Re.now.zoo), 11], 1))
Re.covid <- cbind(Re.covid, min, max)
write.table(Re.covid, 
            file = paste0(web.path, "data_Re_", adm, "_", tolower(sigla.adm), "_covid.csv"), 
            row.names = TRUE, col.names = FALSE)


## SRAG ##

## Tabela que preenche o minimo e o maximo do nowcast
minmax.casos.srag <- data.frame(row.names = sigla.adm)
min <- as.integer(now.srag.proj.zoo[max(nrow(now.srag.proj.zoo)),2])
max <- as.integer(now.srag.proj.zoo[max(nrow(now.srag.proj.zoo)),3])
data <- format(max(time(now.srag.proj.zoo)), "%d/%m/%Y")
minmax.casos.srag <- cbind(minmax.casos.srag,
                                      min, max, data)
write.table(minmax.casos.srag, 
            file = paste0(web.path, "data_forecasr_exp_", adm, "_", tolower(sigla.adm), "_srag.csv"), 
            row.names = TRUE, col.names = FALSE)
# Não é generico, é apenas para o municipio de sp. Tendo mais, tem que atualizar

## Tabela do tempo de duplicação
temp.dupl.srag <- data.frame(row.names = sigla.adm)
min.dias <- as.vector(round(td.now.srag[max(nrow(td.now.srag)),2], 1))
max.dias <- as.vector(round(td.now.srag[max(nrow(td.now.srag)),3], 1))
temp.dupl.srag <- cbind(temp.dupl.srag, min.dias, max.dias)
write.table(temp.dupl.srag, 
            file = paste0(web.path, "data_tempo_dupli_", adm, "_", tolower(sigla.adm), "_srag.csv"), 
            row.names = TRUE, col.names = FALSE)


## Tabela do Re
Re.srag <- data.frame(row.names = sigla.adm)
min <- as.factor(round(Re.now.srag.zoo[nrow(Re.now.srag.zoo), 5],1))
max <- as.factor(round(Re.now.srag.zoo[nrow(Re.now.srag.zoo), 11],1))
Re.srag <- cbind(Re.srag, min, max)
write.table(Re.srag, 
            file = paste0(web.path, "data_Re_", adm, "_", tolower(sigla.adm), "_srag.csv"), 
            row.names = TRUE, col.names = FALSE)


