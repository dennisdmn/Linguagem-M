(LinkGitHub)=>

let
// 1. Código/Função para importar script hospedado em repositório no GitHub para o Editor do Power Query;
// 2. O repositório do GitHub para esse caso, o código precisa ser publico;
// 3. Trocar o link de arquivo TXT salvo para buscar script em linguagem M;
// 4. Funciona tanto para Power Query no Excel, quanto no próprio Power BI.
// 5. Exemplo (RAW): LinkGitHub = "https://raw.githubusercontent.com/dennisdmn/TesteM/main/Criando_Tabela_Feriados_Fixos.txt"	

    GIT = Web.Contents(
          LinkGitHub
	  ),

    // lendo o binario do conteudo
    script = Text.FromBinary(GIT),

    // executando
    run = Expression.Evaluate(script , #shared) 
    
in
    run
