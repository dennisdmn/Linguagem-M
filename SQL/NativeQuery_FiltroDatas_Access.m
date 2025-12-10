let
    // 1. Extrai o valor da Célula Nomeada 'dtini' de forma robusta
    DataInicial = Table.FirstValue(
        Excel.CurrentWorkbook(){[Name="dtini"]}[Content]
    ),
    
    // 2. Extrai o valor da Célula Nomeada 'dtfim' de forma robusta
    DataFinal = Table.FirstValue(
        Excel.CurrentWorkbook(){[Name="dtfim"]}[Content]
    ),
    
    // 3. Define a conexão com o banco de dados Access
    FonteAccess = Access.Database(
        File.Contents("C:\Rieger\Blog Guia do Excel\Controle de hora extra access\Ponto.accdb"),
        [CreateNavigationProperties=true]
    ),
    
    // 4. Executa a consulta SQL nativa no Access, usando os parâmetros de data.
    // Isso utiliza o recurso de 'Query Folding' (Dobramento de Consulta) para otimização.
    DadosFiltrados = Value.NativeQuery(
        FonteAccess,
        "SELECT * FROM PONTO WHERE DATA BETWEEN ? AND ? ORDER BY DATA",
        {DataInicial, DataFinal} // Lista de parâmetros
    )

in
    // 5. Retorna o resultado da consulta
    DadosFiltrados
