/*
Função: fxImportaCsv
Descrição: Lê um arquivo CSV binário e retorna uma tabela estruturada com cabeçalho promovido.
           Utiliza delimitador ponto e vírgula (;), encoding UTF-8 (65001) e suporte a aspas CSV.

Parâmetros:
- vArquivoBinario: Valor binário do arquivo CSV (ex: proveniente de Folder.Files ou File.Contents)

Retorno: Tabela com a primeira linha promovida como cabeçalho

Exemplo de uso:
    let
        Arquivos  = Folder.Files("C:\Dados"),
        Resultado = Table.TransformColumns(
            Arquivos,
            {"Content", each fxImportaCsv(_)}
        )
    in
        Resultado

Observações:
    - Delimiter   = ";"           → ponto e vírgula como separador de colunas
    - Encoding    = 65001         → UTF-8 (suporte a acentos e caracteres especiais)
    - QuoteStyle  = QuoteStyle.Csv → trata aspas duplas como delimitador de campo
*/

let
    fxImportaCsv = (vArquivoBinario as binary) as table =>
        let
            // 📄 Lê o arquivo CSV
            Fonte = Csv.Document(
                vArquivoBinario,
                [
                    Delimiter = ";",
                    Encoding = 65001,
                    QuoteStyle = QuoteStyle.Csv
                ]
            ),

            // 🧾 Promove a primeira linha como cabeçalho
            CabecalhosPromovidos = Table.PromoteHeaders(
                Fonte,
                [PromoteAllScalars = true]
            )
        in
            CabecalhosPromovidos
in
    fxImportaCsv
