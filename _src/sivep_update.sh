#!/usr/bin/bash

# Estados a serem atualizados
estados="SP RJ RO AC AM RR PA AP TO MA PI CE RN PB PE AL SE BA MG ES PR SC RS MS MT GO DF"
# maximum number of parallel processes
N=4
# date of update
today=`LANG=en date +'%b %-d'`
today_=`date +'%Y_%m_%d'`
todaydash=`date +'%Y-%m-%d'`

out="nowcasting_covid_${today_}.rds"

## paralelize code
# initialize a semaphore with a given number of tokens
open_sem(){
    mkfifo pipe-$$
    exec 3<>pipe-$$
    rm pipe-$$
    local i=$1
    for((;i>0;i--)); do
        printf %s 000 >&3
    done
}

# run the given command asynchronously and pop/push tokens
run_with_lock(){
    local x
    # this read waits until there is something to read
    read -u 3 -n 3 x && ((0==x)) || exit $x
    (
     ( "$@"; )
    # push the return code of the command to the semaphore
    printf '%.3d' $? >&3
    )&
}

git pull
git log -- ../dados/SIVEP-Gripe/ | grep  "$today"
novos_dados=$?

if [[ $novos_dados = 0 && ! -f "../dados/Estado_SP/$out" ]]; then
    echo "Rodando Nowcasting"
    # initialize: N processes at most
    open_sem $N
    for estado in $estados; do
        run_with_lock Rscript gera_nowcastings_SIVEP.R --dataBase 2020-05-04 --file SRAGHospitalizado_2020_05_04.csv --estado $estado
        #run_with_lock Rscript gera_nowcastings_SIVEP.R --dataBase $todaydash --file SRAGHospitalizado_${today_}.csv --estado $estado
    done

    git pull
    git add ../dados/Estado_*/{n_casos_data_obitos_covid_${today_}.csv,n_casos_data_obitos_srag_${today_}.csv,n_casos_data_sintoma_covid_${today_}.csv,n_casos_data_sintoma_srag_${today_}.csv,notificacoes_covid_${today_}.csv,notificacoes_obitos_covid_${today_}.csv,notificacoes_obitos_srag_${today_}.csv,notificacoes_srag_${today_}.csv,nowcasting_covid_${today_}.rds,nowcasting_covid_previstos_${today_}.csv,nowcasting_obitos_covid_${today_}.rds,nowcasting_obitos_covid_previstos_${today_}.csv,nowcasting_obitos_srag_${today_}.rds,nowcasting_obitos_srag_previstos_${today_}.csv,nowcasting_srag_${today_}.rds,nowcasting_srag_previstos_${today_}.csv} &&
    git commit -m "[auto] atualizando paginas nowcasting Estados" &&
    git push

    for estado in $estados; do
        Rscript update_nowcasting.R --adm estado --sigla $estado
    done
fi
