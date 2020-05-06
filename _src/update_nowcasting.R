# Libraries
library(widgetframe)
library(tidyverse)
library(plotly)
library(lubridate)
library(optparse)
library(Hmisc)

# Helper Function
makeNamedList <- function(...) {
  structure(list(...), names = as.list(substitute(list(...)))[-1L])
}

# if executed from command line, look for arguments
# else variable `mun` is assumed to be defined
if (sys.nframe() == 0L) {
  # Parsing command line arguments
  option_list <- list(
    make_option("--estado", default = "estado",
                help = ("Selecione uma escala administrativa: estado, municipio"),
                metavar = "estado"),
    make_option("--sigla", default = "NULL",
                help = ("Estado a ser atualizado"),
                metavar = "sigla")
  )
  #ö checar os detalles do parse usage aqui
  parser_object <- OptionParser(usage = "Rscript %prog [Opções] [sigla UF]\n",
                                option_list = option_list,
                                description = "Script para atualizar análise e plots do site do OBSERVATORIO COVID-19 BR com resultados por município ou estado")
  
  opt <- parse_args(parser_object, args = commandArgs(trailingOnly = TRUE), 
                    positional_arguments = TRUE)
  
  ## aliases
adm <- opt$options$estado
sigla.adm <- opt$options$sigla
#ö: isto ficou assim porque municipio SP ainda está independente o terminal vai perguntar estado e sigla. mas isso não muda a parametrizaçãõ de adm e sigla.adm
}

#if you are going to run this interactively uncomment: 
# adm <- "estado"
# sigla.adm <- "RJ"

if (!exists('sigla.adm')) {
  print("Sigla do estado não definida")
  quit(status = 1)
}
print(paste("Atualizando", adm , sigla.adm))

sigla.municipios <- c(SP = "São Paulo",
                      RJ = "Rio de Janeiro")

estados <- read.csv("../dados/estados_code.csv", row.names = 1,
                    stringsAsFactors = F)
sigla.estados <- estados$nome
names(sigla.estados) <- estados$sigla
#só mantendo o formato de sigla.municipios

if (adm == "estado" & !sigla.adm %in% names(sigla.estados) |
    adm == "municipio" & !sigla.adm %in% names(sigla.municipios)) {
  print(paste(Hmisc::capitalize(adm), sigla.adm, "não consta na lista de suportados."))
  #quit(status = 1)
}
if (adm == "estado")
  nome.adm <- sigla.estados[sigla.adm]
if (adm == "municipio")
  nome.adm <- sigla.municipios[sigla.adm]


# este arquivo deve se encarregar de procurar na pasta certa pelo arquivo com a
# data mais recente
#ö: perdi muito tempo botando dentro a checagem se tem nowcasting ou não mas isso tem que ser aqui :( t
source(paste0('prepara_dados_nowcasting.R'))#

# códigos de análise e plot genéricos (mas pode usar as variáveis `mun` e
# `municipio` pra títulos de plot etc.%isso agora adm.sigla too
source('analises_nowcasting.R')
source('plots_municipios.R')

## Data de Atualizacao
print("Atualizando data de atualizacao...")
file <- file(paste0("../web/last.update.", adm, "_", sigla.adm, ".txt")) # coloco o nome do municipio?#coloquei para diferenciar do de estados
writeLines(c(paste(now())), file)
close(file)

################################################################# ###############
## Atualiza gráficos por estado
################################################################################
print("Atualizando plots...")
 
# Graficos a serem atualizados
plots.para.atualizar <- makeNamedList(
  plot.nowcast,
  plot.nowcast.srag,                 
  plot.nowcast.cum,
  plot.nowcast.cum.srag,
  plot.nowcast.ob.covid,
  plot.nowcast.ob.srag,
  plot.tempo.dupl.municipio, 
  plot.tempo.dupl.municipio.ob.covid,
  plot.tempo.dupl.municipio.ob.srag,
  plot.tempo.dupl.municipio.srag,
  plot.estimate.R0.municipio,
  plot.estimate.R0.municipio.srag
  ) # plots obitos
filenames <- names(plots.para.atualizar)
n <- length(plots.para.atualizar)

for (i in 1:n) {
  graph.html <- ggplotly(plots.para.atualizar[[i]]) %>%
    layout(margin = list(l = 50, r = 20, b = 20, t = 20, pad = 4))
  graph.svg <- plots.para.atualizar[[i]] +
    theme(axis.text = element_text(size = 11, family = "Arial", face = "plain"),
          # ticks
          axis.title = element_text(size = 14, family = "Arial", face = "plain")) # title
  filepath <- paste0("../web/",filenames[i],".", tolower(sigla.adm))
  saveWidget(frameableWidget(graph.html), file = paste(filepath,".html",sep = ""), libdir = "./libs") # HTML Interative Plot
  ggsave(paste(filepath, ".svg", sep = ""), plot = graph.svg, device = svg, scale = .8, width = 210, height = 142, units = "mm")
}

