## Pacotes necessários
library(zoo)
library(dplyr)
library(stringr)
source("funcoes.R")

## Usa funcao prepara.dados

################################################################################
## Dados e nowcastings COVID
################################################################################
lista.covid <- prepara.dados(tipo = "covid", 
                             adm = adm, 
                             sigla.adm = sigla.adm)

################################################################################
## Dados e nowcastings SRAG
################################################################################
lista.srag <- prepara.dados(tipo = "srag",
                            adm = adm, 
                            sigla.adm = sigla.adm)

################################################################################
## Dados e nowcastings COVID OBITOS
################################################################################
lista.ob.covid <- prepara.dados(tipo = "obitos_covid", 
                                adm = adm, 
                                sigla.adm = sigla.adm)

################################################################################
## Dados e nowcastings SRAG OBITOS
################################################################################
lista.ob.srag <- prepara.dados(tipo = "obitos_srag", 
                               adm = adm, 
                               sigla.adm = sigla.adm)

