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
  option_list <- list(make_option("--m", default = "SP",
                                  help = ("Município a ser atualizado"),
                                  metavar = "m"))

  parser_object <- OptionParser(usage = "Rscript %prog [Opções] [município]\n",
                                option_list = option_list,
                                description = "Script para atualizar análise e plots do site do OBSERVATORIO COVID-19 BR com resultados por município")

  opt <- parse_args(parser_object, args = commandArgs(trailingOnly = TRUE), positional_arguments = TRUE)

  ## aliases
  mun <- opt$options$m
}

if (!exists('mun')) {
  print("Município não definido")
  #quit(status = 1)
}
print(paste("Atualizando municipio", mun))

sigla.municipios <- c(SP = "São Paulo")

#if (! mun %in% names(sigla.municipios)){
#    print(paste0("Município ", mun, " não consta na lista de suportados."))
#    quit(status=1)
#}
municipio <- sigla.municipios[mun]

# preparação dos dados específica por município?
# este arquivo deve se encarregar de procurar na pasta certa pelo arquivo com a
# data mais recente



source(paste0('prepara_dados_municipio_', mun, '.R'))

# códigos de análise e plot genéricos (mas pode usar as variáveis `mun` e
# `municipio` pra títulos de plot etc.
source('analises_municipio.R')
source('plots_municipios.R')

## Data de Atualizacao
print("Atualizando data de atualizacao...")
  web.path <- paste0("../web/")
  file <- file(paste0(web.path, "last.update.municipio_SP.txt"))
writeLines(c(paste(now())), file)
close(file)

################################################################# ###############
## Atualiza gráficos por estado
################################################################################
print("Atualizando plots...")

# Graficos a serem atualizados
plots.para.atualizar.municipio <- makeNamedList(
    plot.nowcast.covid,
    plot.nowcast.srag,
    plot.nowcast.cum.covid,
    plot.nowcast.cum.srag,
    plot.nowcast.ob.covid, 
    plot.nowcast.ob.srag,
    plot.tempo.dupl.covid,
    plot.tempo.dupl.ob.covid,
    plot.tempo.dupl.ob.srag,
    plot.tempo.dupl.srag,
    plot.estimate.R0.covid,
    plot.estimate.R0.srag
    )
filenames <- names(plots.para.atualizar.municipio)
n <- length(plots.para.atualizar.municipio)

for (i in 1:n) {
    fig.name <- paste0(filenames[i], "_municipio_SP")
    graph.html <- ggplotly(plots.para.atualizar.municipio[[i]]) %>%
      layout(margin = list(l = 50, r = 20, b = 20, t = 20, pad = 4))
    graph.svg <- plots.para.atualizar.municipio[[i]] +
        theme(axis.text = element_text(size = 11, family = "Arial", face = "plain"),# ticks
              axis.title = element_text(size = 14, family = "Arial", face = "plain")) # title
  filepath <- paste0(web.path, fig.name)
  saveWidget(frameableWidget(graph.html), file = paste0(filepath, ".html"), libdir = "./libs") # HTML Interative Plot
  ggsave(paste0(filepath,".svg"),
  plot = graph.svg, device = svg, scale = .8, width = 210, height = 142, units = "mm")
}
