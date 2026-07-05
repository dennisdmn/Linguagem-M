// Exemplos gerais de funcoes Power Query M
//
// Este arquivo consolida exemplos que estavam no Google Doc
// "Exemplo de Funcoes Power - Linguagem M".
//
// A consulta retorna um registro com funcoes e exemplos reaproveitaveis.

let
    // Retorna um valor de uma tabela a partir de uma chave.
    // Equivalente ao acesso: Tabela{[Campo = Valor]}[ColunaRetorno]
    fxBuscaRegistroPorCodigo = (
        tabela as table,
        nomeCampoBusca as text,
        valorBusca as any,
        nomeCampoRetorno as text
    ) as any =>
        let
            Registro = tabela{Record.FromList({valorBusca}, {nomeCampoBusca})},
            Resultado = Record.Field(Registro, nomeCampoRetorno)
        in
            Resultado,

    // Classifica um produto usando Text.Contains.
    fxClassificaProduto = (produto as nullable text) as nullable text =>
        if produto = null then null
        else if Text.Contains(produto, "Curso SSBI", Comparer.OrdinalIgnoreCase) then "Curso SSBI"
        else "Curso Dashboards",

    // Valida uma linha contabil com condicoes combinadas.
    fxValidaClassificacaoContabil = (
        tipoLancamento as nullable text,
        contaDebito as any,
        contaCredito as any
    ) as text =>
        let
            Tipo = if tipoLancamento = null then "" else tipoLancamento,
            TemDebito = contaDebito <> null,
            TemCredito = contaCredito <> null,
            Resultado =
                if Text.Contains(Tipo, "Partida Dobrada", Comparer.OrdinalIgnoreCase) and TemDebito and TemCredito then "Ok"
                else if Text.Contains(Tipo, "Credito", Comparer.OrdinalIgnoreCase) and TemCredito then "Ok"
                else if Text.Contains(Tipo, "Debito", Comparer.OrdinalIgnoreCase) and TemDebito then "Ok"
                else "Classif Contabil Errada"
        in
            Resultado,

    // Extrai parte de um texto a partir da posicao de outro texto.
    fxExtraiTrechoAPartirDeTexto = (
        texto as nullable text,
        textoProcurado as text,
        quantidadeCaracteres as number
    ) as nullable text =>
        let
            Posicao = if texto = null then -1 else Text.PositionOf(texto, textoProcurado, Occurrence.First),
            Resultado = if Posicao < 0 then null else Text.Range(texto, Posicao, quantidadeCaracteres)
        in
            Resultado,

    // Replica OR: qualquer condicao verdadeira aprova a linha.
    fxAlgumaCondicaoVerdadeira = (item as text, vendedor as text) as text =>
        if List.AnyTrue({item = "Talkative Parrot", vendedor = "Fred"}) then "Meets Criterias!" else "No Match",

    // Replica AND: todas as condicoes precisam ser verdadeiras.
    fxTodasCondicoesVerdadeiras = (item as text, vendedor as text) as text =>
        if List.AllTrue({item = "Talkative Parrot", vendedor = "Fred"}) then "Meets Criterias!" else "No Match",

    // Simula SWITCH usando tabela de pares chave/resultado.
    fxSwitchCodigo = (input as text) as text =>
        let
            Chave = Text.Upper(input),
            Valores = {
                {"E", "Employee"},
                {"S", "SCYC"},
                {"N", "Non-Taxable"},
                {"R", "Restricted"},
                {"I", "Inactive"},
                {"L", "Social"},
                {"M", "Medical"},
                {"U", "Regular"}
            },
            Encontrado = List.Select(Valores, each _{0} = Chave),
            Resultado = if List.IsEmpty(Encontrado) then "Undefined" else Encontrado{0}{1}
        in
            Resultado,

    ExemplosDeUso = [
        TextPositionOf = "Text.PositionOf([Produto], \"Tur\")",
        TextRange = "Text.Range([Produto], Text.PositionOf([Produto], \"Tur\"), 5)",
        TableMax = "Table.Max([Vendas], \"Total\")",
        TableAddIndexColumn = "Table.AddIndexColumn(tabela, \"Indice\", 1, 1)",
        TableSelectRows = "Table.SelectRows(tabela, each [Status] = \"Ativo\")",
        TablePromoteHeaders = "Table.PromoteHeaders(tabela)",
        DateToTextMes = "Date.ToText([DataBase], \"MMMM\", \"pt-BR\")",
        DateToTextDiaSemana = "Date.ToText([DataBase], \"dddd\", \"pt-BR\")"
    ]
in
    [
        fxBuscaRegistroPorCodigo = fxBuscaRegistroPorCodigo,
        fxClassificaProduto = fxClassificaProduto,
        fxValidaClassificacaoContabil = fxValidaClassificacaoContabil,
        fxExtraiTrechoAPartirDeTexto = fxExtraiTrechoAPartirDeTexto,
        fxAlgumaCondicaoVerdadeira = fxAlgumaCondicaoVerdadeira,
        fxTodasCondicoesVerdadeiras = fxTodasCondicoesVerdadeiras,
        fxSwitchCodigo = fxSwitchCodigo,
        ExemplosDeUso = ExemplosDeUso
    ]
