(CaminhoArquivoCSV_GitHub as text) =>
let
	// Importando dados de arquivos salvo em repositorio publico do GitHub.
	// Arquivo de Excel salvo com a extensão: CSV (separado por ";" )
	Fonte = Csv.Document(
		Web.Contents(
		    CaminhoArquivoCSV_GitHub
		),
		[
		    Delimiter=";", 
		    Columns=3, 
		    Encoding=65001, 
		    QuoteStyle=QuoteStyle.None
		]
	)    
in
    Fonte
