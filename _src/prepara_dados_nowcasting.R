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
  # guarda data mais recente
  data.covid <- get.data.base(adm = adm, sigla.adm = sigla.adm, tipo = "covid")
  lista.covid <- prepara.dados(tipo = "covid", 
                               adm = adm, 
                               sigla.adm = sigla.adm,
                               data.base = data.covid)
}
################################################################################
## Dados e nowcastings SRAG
################################################################################
if (existe.srag) { 
  # guardando objeto data.base
  data.srag <- get.data.base(adm = adm, sigla.adm = sigla.adm, tipo = "srag")
  lista.srag <- prepara.dados(tipo = "srag",
                              adm = adm, 
                              sigla.adm = sigla.adm,
                              data.base = data.srag)
}  
################################################################################
## Dados e nowcastings COVID OBITOS
################################################################################
if (existe.ob.covid) { 
  data.ob.covid <- get.data.base(adm = adm, sigla.adm = sigla.adm, tipo = "obitos_covid")
  lista.ob.covid <- prepara.dados(tipo = "obitos_covid", 
                                  adm = adm, 
                                  sigla.adm = sigla.adm,
                                  data.base = data.ob.covid)
}  
################################################################################
## Dados e nowcastings SRAG OBITOS
################################################################################
if (existe.ob.srag) {
  data.ob.srag <- get.data.base(adm = adm, sigla.adm = sigla.adm, tipo = "obitos_srag")
  lista.ob.srag <- prepara.dados(tipo = "obitos_srag", 
                                 adm = adm, 
                                 sigla.adm = sigla.adm,
                                 data.base = data.ob.srag)
}

