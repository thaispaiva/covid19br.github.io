# Metadados sobre as planilhas

Análise de *nowcasting* para COVID-19 e SRAG no município de São Paulo a partir da base de dados SIVEP-gripe. Dados dos casos notificados e estimados por *nowcasting* com projeção para os próximos 5 dias. 

Arquivos .csv separados por vírgula, separador de decimal ponto. A data indica a data de geração da análise.  

- `nowcasting_acumulado_srag*` - análise para SRAG
- `nowcasting_acumulado_covid*` - análise para COVID-19

## Sobre as acolunas 

Os arquivos seguem o mesmo padrão de nomes de colunas. Os dados de estimados por *nowcasting* possuem iniciam o nome por  `now.` e os notificados iniciam-se por`.not`. As colunas que contém a terminação `.proj` no nome são referentes às projeções para os próximos 5 dias. Células vazias são preenchidas com NA.

- `data` - data em formato ISO 8601 YYYY-MM-DD

### Valores de casos **estimados** por *nowcasting* e respectivas projeções

- `now.mean.c` - valor médio acumulado por data
- `now.mean.c.proj` - valor médio acumulado por data para a projeção
- `now.low.c` - intervalo de credibilidade inferior
- `now.low.c.proj` - intervalo de credibilidade inferior para a projeção
- `now.upp.c`- intervalo de credibilidade superior
- `now.upp.c.proj` - intervalo de credibilidade superior para a projeção

### Valores de casos **notificados** e respectivas projeções
- `not.mean.c`- valor médio acumulado por data
- `not.mean.c.proj`- valor médio acumulado por data para a projeção
- `not.low.c`- intervalo de credibilidade inferior
- `not.mean.c.proj` - intervalo de credibilidade inferior para a projeção
- `not.upp.c` - intervalo de credibilidade superior
- `not.upp.c.proj` - intervalo de credibilidade superior para a projeção

Para compor a curva média de casos estimados por *nowcasting*, por exemplo, usa-se as colunas `now.mean.c` e `now.mean.c.proj`. Como não há casos para o período da projeção, a coluna `now.mean.c` possui NA para o período de projeção. Da mesma forma, como a projeção é só para o período de 5 dias não há dados `.proj` para o período de casos estimados por *nowcasting*.  
