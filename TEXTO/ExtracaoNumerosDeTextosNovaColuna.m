let
    // Função personalizada para extrair números de uma string e converter para número inteiro.
    ExtractNumbersAsInt = (inputText as text) as number =>
    let
        // Extrair apenas os caracteres que são números
        extractedText = Text.Select(inputText, {"0".."9"}),
        // Converter o texto extraído para número
        resultNumber = Number.FromText(extractedText)
    in
        resultNumber,

    // Função personalizada para adicionar uma nova coluna com o nome especificado
    AdicionarColunaComNome = (tabela as table, colunaNome as text) as table =>
    let
        // Adiciona uma nova coluna com o nome especificado utilizando a função personalizada
        NovaTabela = Table.AddColumn(tabela, colunaNome, each ExtractNumbersAsInt([DESCRICAO_PERIODO]), Int64.Type)
    in
        NovaTabela
in
    // Função que aceita uma tabela e uma coluna para o nome da nova coluna
    (tabela as table, colunaNome as text) as table => AdicionarColunaComNome(tabela, colunaNome)
