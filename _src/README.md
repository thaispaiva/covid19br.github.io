# Para gerar os gráficos de nowcasting

Os scripts rodam automaticamente a partir de `update_*.R`, mas para testar localmente seguir a ordem abaixo. Os `update_*` são os arquivos que salvam as figuras .svg e .html para o site. 

## Município São Paulo

Automático a partir de update_municipio.R. Ainda aparte, mas no futuro próximo pode ser o mesmo fluxo dos estados.

### Localmente

1. `prepara_dados_municipio_SP.R` - lê arquivos .csv em dados/municipio_SP
2. ``analises_municipio.R` - gera objetos com projeções, R, TD
3. `plots_municipio.R` - exporta arquivos em web/

### Em bash

```bash
Rscript update_municipio.R --m SP
```

## Estados (e outros municípios)

Automático a partir de update_nowcasting.R

1. `prepara_nowcasting.R` - lê arquivos .csv em dados/estado_*
2. `analises_nowcastng.R` - gera objetos com projeções, R, TD
3. `plots_nowcasting.R` - exporta arquivos em web/estado_*
 
### Em bash

```bash
Rscript update_nowcasting.R --estado estado --sigla TO
```
 