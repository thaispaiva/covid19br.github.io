## Pacotes necessários
library(zoo)
library(dplyr)
library(stringr)
source("funcoes.R")

# testando se existe nowcasting
existe.covid <- existe.nowcasting(adm = adm, sigla.adm = sigla.adm, tipo = "covid")
existe.srag <- existe.nowcasting(adm = adm, sigla.adm = sigla.adm, tipo = "srag")
existe.ob.covid <- existe.nowcasting(adm = adm, sigla.adm = sigla.adm, tipo = "obitos_covid")
existe.ob.srag <- existe.nowcasting(adm = adm, sigla.adm = sigla.adm, tipo = "obitos_srag")

## Usa funcao prepara.dados
################################################################################
## Dados e nowcastings COVID
################################################################################
if (existe.covid) { 
  lista.covid <- prepara.dados(tipo = "covid", 
                               adm = adm, 
                               sigla.adm = sigla.adm)
}
################################################################################
## Dados e nowcastings SRAG
################################################################################
if (existe.srag) { 
  lista.srag <- prepara.dados(tipo = "srag",
                              adm = adm, 
                              sigla.adm = sigla.adm)
}  
################################################################################
## Dados e nowcastings COVID OBITOS
################################################################################
if (existe.ob.covid) { 
  lista.ob.covid <- prepara.dados(tipo = "obitos_covid", 
                                  adm = adm, 
                                  sigla.adm = sigla.adm)
}  
################################################################################
## Dados e nowcastings SRAG OBITOS
################################################################################
if (existe.ob.srag) { 
  lista.ob.srag <- prepara.dados(tipo = "obitos_srag", 
                                 adm = adm, 
                                 sigla.adm = sigla.adm)
}
