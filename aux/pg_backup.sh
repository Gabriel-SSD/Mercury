#!/bin/bash

# Função para realizar o backup do banco de dados
# Parâmetros: $1 - Nome do banco de dados, $2 - Nome do contêiner
function backup {
    local database_name="$1"
    local container_name="$2"

    # shellcheck disable=SC2155
    local is_running=$(docker inspect -f '{{.State.Running}}' "$container_name" 2>/dev/null)
    if [ "$is_running" = "true" ]; then
        # echo "O contêiner $container_name está ativo. Realizando o backup do banco de dados $database_name..."
        backup_date=$(date +"%Y-%m-%d")
        docker exec "$container_name" pg_dump -U MercuryDBA "$database_name" > "/home/prison/mercury/files/backup/${database_name}_dump_$backup_date.sql"
        echo "$backup_date Backup do banco de dados $database_name concluído com sucesso" >> "$log_file"
    else
        echo "$backup_date $container_name não está ativo. Backup do banco de dados $database_name não realizado." >> "$log_file"
    fi
}

log_file="/home/prison/mercury/logs/pg_backup.log"
backup "MercuryDW" "pg_dw"
backup "MetabaseDB" "pg_metabase"
