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
