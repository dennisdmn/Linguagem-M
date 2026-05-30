let
    Fonte = (
        pBinario as binary,
        optional pNomeObjeto as nullable text,
        optional pTipoObjeto as nullable text,
        optional pPromoverCabecalho as nullable logical
    ) as table =>
        let
            Etp_TipoObjeto =
                if pTipoObjeto = null then
                    "Sheet"
                else
                    pTipoObjeto,

            Etp_PromoverCab =
                if pPromoverCabecalho = null then
                    false
                else
                    pPromoverCabecalho,

            Etp_Excel = Excel.Workbook(
                pBinario,
                null,
                true
            ),

            Etp_FiltraObjeto =
                if pNomeObjeto = null then
                    Etp_Excel
                else
                    Table.SelectRows(
                        Etp_Excel,
                        each
                                [Item] = pNomeObjeto
                            and [Kind] = Etp_TipoObjeto
                    ),

            Etp_ValidaObjeto =
                if pNomeObjeto <> null and Table.IsEmpty(Etp_FiltraObjeto) then
                    error "Objeto nao encontrado no Excel binario. Verifique pNomeObjeto e pTipoObjeto."
                else
                    Etp_FiltraObjeto,

            Etp_Dados =
                if pNomeObjeto = null then
                    Etp_ValidaObjeto
                else
                    Etp_ValidaObjeto{0}[Data],

            Etp_Resultado =
                if pNomeObjeto <> null and Etp_PromoverCab then
                    Table.PromoteHeaders(
                        Etp_Dados,
                        [PromoteAllScalars = true]
                    )
                else
                    Etp_Dados
        in
            Etp_Resultado,

    TipoFuncao = type function (
        pBinario as (
            type binary meta [
                Documentation.FieldCaption = "Arquivo Excel binario",
                Documentation.FieldDescription = "Conteudo binario do arquivo Excel, normalmente vindo da coluna [Content] de Folder.Files, SharePoint.Files ou de File.Contents."
            ]
        ),
        optional pNomeObjeto as (
            type nullable text meta [
                Documentation.FieldCaption = "Nome da aba, tabela ou nome definido",
                Documentation.FieldDescription = "Nome do objeto dentro do Excel. Exemplo: tblParametros ou FactExtracao_1_2. Se nao for informado, a funcao retorna a lista de objetos do arquivo."
            ]
        ),
        optional pTipoObjeto as (
            type nullable text meta [
                Documentation.FieldCaption = "Tipo do objeto",
                Documentation.FieldDescription = "Tipo do objeto dentro do Excel. Normalmente Sheet, Table ou DefinedName. Se nao for informado, sera usado Sheet."
            ]
        ),
        optional pPromoverCabecalho as (
            type nullable logical meta [
                Documentation.FieldCaption = "Promover cabecalhos",
                Documentation.FieldDescription = "Informe true para promover a primeira linha como cabecalho. Se nao for informado, sera considerado false."
            ]
        )
    )
    as table meta [
        Documentation.Name = "fxTrataExcelBinario",
        Documentation.Description = "Le e trata um arquivo Excel a partir do seu conteudo binario.",
        Documentation.LongDescription = "A funcao recebe o binario de um arquivo Excel, normalmente vindo da coluna [Content] de Folder.Files ou SharePoint.Files. Ela pode retornar a lista de objetos do arquivo ou os dados de uma aba, tabela ou nome definido especifico, com opcao de promover cabecalhos.",
        Documentation.Category = "Funcoes de Importacao",
        Documentation.Source = "Excel.Workbook",
        Documentation.Author = "Dennis Neves",
        Documentation.Examples = {
            [
                Description = "Listar abas, tabelas e objetos existentes no arquivo Excel binario.",
                Code = "fxTrataExcelBinario(Etp_FiltraArquivo{0}[Content])",
                Result = "Retorna a estrutura do arquivo Excel com colunas como Name, Data, Item, Kind e Hidden."
            ],
            [
                Description = "Importar a tabela tblParametros.",
                Code = "fxTrataExcelBinario(Etp_FiltraArquivo{0}[Content], \"tblParametros\", \"Table\", false)",
                Result = "Retorna os dados da tabela tblParametros."
            ],
            [
                Description = "Importar a aba FactExtracao_1_2 e promover cabecalhos.",
                Code = "fxTrataExcelBinario(Etp_FiltraArquivo{0}[Content], \"FactExtracao_1_2\", \"Sheet\", true)",
                Result = "Retorna os dados da aba FactExtracao_1_2 com cabecalhos promovidos."
            ]
        }
    ]
in
    Value.ReplaceType(Fonte, TipoFuncao)
