## Função para checar se existem dados de nowcasting para a unidade administrativa
existe.nowcasting <- function(adm = adm, 
                              sigla.adm = sigla.adm, 
                              tipo) { 
    nome.dir <- paste0("../dados/", adm, "_", sigla.adm, "/")
    nowcasting.file <- list.files(path = nome.dir, 
                                  pattern = paste0("nowcasting", ".+", tipo, ".+.csv"))
    length(nowcasting.file) > 0
}
