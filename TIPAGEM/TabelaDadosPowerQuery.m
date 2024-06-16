let
    // Criação da tabela inicial com dados fictícios
    Fonte = #table(
        {"CHAVE", "PRODUTO", "GRUPO PRODUTO", "DIA", "MÊS", "ANO", "D2_EMISSAO", "D2_QUANT", "D2_VALBRUT"},
        {
            {"001", "Produto A", "Grupo 1", 15, 5, 2023, #date(2023, 5, 15), 10, 100.50},
            {"002", "Produto B", "Grupo 2", 22, 6, 2023, #date(2023, 6, 22), 20, 200.75},
            {"003", "Produto C", "Grupo 1", 30, 7, 2023, #date(2023, 7, 30), 30, 300.00}
        }
    ),
    // Definição dos tipos de dados
    TiposDeDados = {
        {"CHAVE", type text},
        {"PRODUTO", type text},
        {"GRUPO PRODUTO", type text},
        {"DIA", Int64.Type},
        {"MÊS", Int64.Type},
        {"ANO", Int64.Type},
        {"D2_EMISSAO", type date},
        {"D2_QUANT", type number},
        {"D2_VALBRUT", type number}
    },
    // Aplicação dos tipos de dados
    TabelaComTipos = Table.TransformColumnTypes(Fonte, TiposDeDados)
in
    TabelaComTipos
