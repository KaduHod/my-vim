plugindir="$(pwd)/after/plugin"
kadudir="$(pwd)/lua/kadu"


source(){
	local diretorio="$1"
	for arquivo in "$diretorio"/*
	do
		# Verifica se o arquivo é um arquivo regular
		if [ -f "$arquivo" ]
		then
			echo "Executando source em $arquivo"

      # Executa o comando source no arquivo
      source "$arquivo"
		fi
	done
}

source "$plugindir"
source "$kadudir"
