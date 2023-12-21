( url as text ) =>

let
    /* Substitua a URL abaixo pelo URL direto do script M no GitHub
       url = "https://raw.githubusercontent.com/seu-usuario/seu-repositorio/seu-caminho/seu-arquivo.m"
    */
    
    // Use a função Web.Contents para obter o conteúdo do URL
    scriptM = Text.FromBinary(Web.Contents(url)),
    
    // Avalie o código M usando Expression.Evaluate
    resultado = Expression.Evaluate(scriptM, #shared)

in

    resultado
