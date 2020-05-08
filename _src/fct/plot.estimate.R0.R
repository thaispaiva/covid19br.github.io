# Funcao para plot do tempo de duplicacao, recebe objeto zoo
plot.estimate.R0 <- function(Re.now.zoo){
    plot <- ggplot(data = Re.now.zoo, aes(Index, Mean.R)) +
        geom_ribbon(aes(ymin = Quantile.0.025.R, ymax = Quantile.0.975.R), fill = "lightgrey") +
        geom_line(size = 1.25, colour = RColorBrewer::brewer.pal(4, "Dark2")[3]) +
        scale_x_date( date_labels = "%d/%b", name = "") +
        ylim(min(c(0.8, min(Re.now.zoo$Quantile.0.025.R))), max(Re.now.zoo$Quantile.0.975.R)) +
        geom_hline(yintercept = 1, linetype = "dashed", col = "red", size = 1) +          
        ylab("Número de reprodução da epidemia") +
        plot.formatos
    plot
}
