# libraries
library(ggplot2)
library(dplyr)
library(tidyr)
library(zoo)

# Parametros de formatacao comum aos plots
source("funcoes.R") # plot.formatos vem junto aqui

# separando os outputs em subpastas yay!
web.path <- paste0("../web/", adm, "_", sigla.adm, "/") 

if (!dir.exists(web.path)) dir.create(web.path)

#############
## COVID ####
#############

if (existe.covid) {
    # PLOTS #### 
    ### diario
    ## N de novos casos observados e por nowcasting
    ## Com linha de média móvel
    plot.nowcast.covid <- plot.nowcast.diario(df.covid.diario)
    
    ### acumulado
    plot.nowcast.cum.covid <- plot.nowcast.acumulado(df.covid.cum)
    
    ### tempo de duplicação
    plot.tempo.dupl.covid <- plot.tempo.dupl(td.now)
    
    ### R efetivo
    plot.estimate.R0.covid <- plot.estimate.R0(Re.now.zoo)
    
    # TABELAS ####
    ## Tabela que preenche o minimo e o maximo do nowcast
    minmax.casos <- data.frame(row.names = sigla.adm)
    min <- as.integer(now.proj.zoo[max(nrow(now.proj.zoo)), 2])
    max <- as.integer(now.proj.zoo[max(nrow(now.proj.zoo)), 3])
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
    
}

############
## SRAG ####
############

if (existe.srag) {
    # PLOTS ####
    ### diario
    ## N de novos casos observados e por nowcasting
    ## Com linha de média móvel
    plot.nowcast.srag <- plot.nowcast.diario(df.srag.diario)
    
    ### acumulado
    plot.nowcast.cum.srag <- plot.nowcast.acumulado(df.srag.cum)
    
    ### tempo de duplicação
    plot.tempo.dupl.srag <- plot.tempo.dupl(td.now.srag)
    
    ### R efetivo
    plot.estimate.R0.srag <- plot.estimate.R0(Re.now.srag.zoo)
    
    # TABELAS ####
    
    ## Tabela que preenche o minimo e o maximo do nowcast
    minmax.casos.srag <- data.frame(row.names = sigla.adm)
    min <- as.integer(now.srag.proj.zoo[max(nrow(now.srag.proj.zoo)), 2])
    max <- as.integer(now.srag.proj.zoo[max(nrow(now.srag.proj.zoo)), 3])
    data <- format(max(time(now.srag.proj.zoo)), "%d/%m/%Y")
    minmax.casos.srag <- cbind(minmax.casos.srag,
                               min, max, data)
    write.table(minmax.casos.srag, 
                file = paste0(web.path, "data_forecasr_exp_", adm, "_", tolower(sigla.adm), "_srag.csv"), 
                row.names = TRUE, col.names = FALSE)
    # Não é generico, é apenas para o municipio de sp. Tendo mais, tem que atualizar
    
    ## Tabela do tempo de duplicação
    temp.dupl.srag <- data.frame(row.names = sigla.adm)
    min.dias <- as.vector(round(td.now.srag[max(nrow(td.now.srag)) ,2], 1))
    max.dias <- as.vector(round(td.now.srag[max(nrow(td.now.srag)), 3], 1))
    temp.dupl.srag <- cbind(temp.dupl.srag, min.dias, max.dias)
    write.table(temp.dupl.srag, 
                file = paste0(web.path, "data_tempo_dupli_", adm, "_", tolower(sigla.adm), "_srag.csv"), 
                row.names = TRUE, col.names = FALSE)
    
    
    ## Tabela do Re
    Re.srag <- data.frame(row.names = sigla.adm)
    min <- as.factor(round(Re.now.srag.zoo[nrow(Re.now.srag.zoo), 5], 1))
    max <- as.factor(round(Re.now.srag.zoo[nrow(Re.now.srag.zoo), 11], 1))
    Re.srag <- cbind(Re.srag, min, max)
    write.table(Re.srag, 
                file = paste0(web.path, "data_Re_", adm, "_", tolower(sigla.adm), "_srag.csv"), 
                row.names = TRUE, col.names = FALSE)
    
}

#####################
## OBTITOS COVID ####
#####################

if (existe.ob.covid) {
    ### diario
    ## N de novos casos observados e por nowcasting
    ## Com linha de média móvel
    plot.nowcast.ob.covid <- plot.nowcast.diario(df.ob.covid.diario) +
        xlab("Dia") +
        ylab("Número de novos óbitos")
    
    ### acumulado
    plot.nowcast.cum.ob.covid <- plot.nowcast.acumulado(df.ob.covid.cum) +
        xlab("Dia") +
        ylab("Número acumulado de óbitos")
    
    ### tempo de duplicação
    plot.tempo.dupl.ob.covid <- plot.tempo.dupl(td.now.ob.covid)
}

####################
## OBTITOS SRAG ####
####################

if (existe.ob.srag) {
    ### diario
    ## N de novos casos observados e por nowcasting
    ## Com linha de média móvel
    plot.nowcast.ob.srag <- plot.nowcast.diario(df.ob.srag.diario) +
        xlab("Dia") +
        ylab("Número de novos óbitos")
    
    ### acumulado
    plot.nowcast.cum.ob.srag <- plot.nowcast.acumulado(df.ob.srag.cum) +
        xlab("Dia") +
        ylab("Número acumulado de óbitos")
    
    ### tempo de duplicação
    plot.tempo.dupl.ob.srag <- plot.tempo.dupl(td.now.ob.srag)
}

