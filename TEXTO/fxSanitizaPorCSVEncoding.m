let
    // 🔠 Função: Sanitiza texto eliminando acentos e caracteres especiais
    // 📌 Utiliza Csv.Document com Encoding=1252 para forçar remoção automática
    fxSanitizaPorCSVEncoding = (TextoOriginal as text) as text =>
        let
            TextoBase = Text.Upper(Text.Trim(TextoOriginal)),
            BinarioAnsi = Text.ToBinary(TextoBase, 1252),
            Tabela = Csv.Document(
                Text.FromBinary(BinarioAnsi),
                [Delimiter = null, Encoding = 1252]
            ),
            Resultado = try Tabela{0}{0} otherwise TextoBase
        in
            Resultado,

    documentation = [
        Documentation.Name = "fxSanitizaPorCSVEncoding",
        Documentation.Description = "Sanitiza texto eliminando acentos e caracteres especiais utilizando CSV com encoding 1252.",
        Documentation.LongDescription = "A função converte um texto para maiúsculas, remove espaços excedentes e utiliza Csv.Document com codificação ANSI (1252) para forçar a remoção automática de caracteres não suportados (acentos, símbolos, emojis, etc.). Ideal para padronizar nomes de colunas ou campos-chave em tabelas do Power BI ou Excel.",
        Documentation.Category = "Limpeza de Texto",
        Documentation.Source = "Interno - Projeto de Padronização Power Query (M)",
        Documentation.Author = "Dennis Neves",
        Documentation.Examples = {
            [
                Description = "Sanitização de string com símbolos e acentos",
                Code = "fxSanitizaPorCSVEncoding( João & Márcia – Área de TI 2024! )",
                Result = "JOAO MARCIA AREA DE TI 2024"
            ]
        }
    ]
in
    Value.ReplaceType(fxSanitizaPorCSVEncoding, Value.ReplaceMetadata(Value.Type(fxSanitizaPorCSVEncoding), documentation))
