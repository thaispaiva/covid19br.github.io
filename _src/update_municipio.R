# Libraries
library(widgetframe)
library(tidyverse)
library(plotly)
library(lubridate)
library(optparse)

# Helper Function
makeNamedList <- function(...) {
  structure(list(...), names = as.list(substitute(list(...)))[-1L])
}

# if executed from command line, look for arguments
# else variable `mun` is assumed to be defined
if (sys.nframe() == 0L) {
    # Parsing command line arguments
    option_list <- list(
      make_option("--adm", default = "municipio",
                  help = ("Selecione uma escala administrativa: estado, municipio"),
                  metavar = "adm"),
      make_option("--sigla", default = "NULL",
                        help = ("Estado ou municipio a ser atualizado"),#quando for muitos outros municipios a gente insire uma tabela de geocode para traduzir o nome.
                        metavar = "sigla.adm")
                        )

    parser_object <- OptionParser(usage = "Rscript %prog [Opções] [município]\n",
                                  option_list = option_list,
                                  description = "Script para atualizar análise e plots do site do OBSERVATORIO COVID-19 BR com resultados por município ou estado")

    opt <- parse_args(parser_object, args = commandArgs(trailingOnly = TRUE), positional_arguments = TRUE)

    ## aliases

    adm <- opt$options$adm
    sigla.adm <- opt$options$sigla
}

if (!exists('sigla.adm')) {
    print("Sigla do estado ou municipio não definida")
    quit(status = 1)
}
print(paste("Atualizando", adm , sigla.adm))

#ah isto é as siglas de municipios suportados. eventualmente será um geocode
sigla.municipios <- c(SP = "São Paulo")

sigla.estados <- c('SP', 'RJ', 'RO', 'AC', 'AM', 'RR', 'PA', 'AP', 'TO', 'MA', 'PI', 'CE', 'RN', 'PB', 'PE', 'AL', 'SE', 'BA', 'MG', 'ES', 'PR', 'SC', 'RS', 'MS', 'MT', 'GO', 'DF')

if (adm == "municipio" & !sigla.adm %in% names(sigla.municipios)) {
    print(paste0("Município ", sigla.adm, " não consta na lista de suportados."))
    quit(status = 1)
}

if (adm == "estado" & !sigla.adm %in% sigla.estados)) {
    print(paste0("Estado ", sigla.adm, " não consta na lista de suportados."))
    quit(status = 1)
}
#
municipio <- sigla.municipios[mun]
#ö precisamos ver onde o nome completo vai

# preparação dos dados específica por município? %acho que nao mas nao
# este arquivo deve se encarregar de procurar na pasta certa pelo arquivo com a
# data mais recente
source(paste0('prepara_dados_nowcasting.R'))#ast o ideal de nome mas posso esperar

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
plots.para.atualizar <- makeNamedList(plot.nowcast.cum,
                                      plot.tempo.dupl.municipio,
                                      plot.estimate.R0.municipio,
                                      plot.nowcast.ob.covid, plot.nowcast.ob.srag) # plots obitos
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
