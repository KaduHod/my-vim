plugindir="$(pwd)/after/plugin"
kadudir="$(pwd)/lua/kadu"


carregar_arquivos(){
    local diretorio="$1"

    # Verifica se o diretório existe antes de continuar
    if [ -d "$diretorio" ]; then
        for arquivo in "$diretorio"/*
        do
            if [ -f "$arquivo" ]; then
                echo "Carregando: $arquivo"
                # O comando 'source' (ou '.') executa o conteúdo do arquivo no shell atual
                source "$arquivo"
            fi
        done
    fi
}

carregar_arquivos "$plugindir"
carregar_arquivos "$kadudir"
