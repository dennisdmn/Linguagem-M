/*
    fxSanitizaDatas

    Objetivo
    --------
    Sanitizar colunas de data (múltiplas) substituindo datas inválidas por null.

    Regras padrão
    -------------
    - Data "zero" (Default: 1899-12-30)  -> null
    - < DataMin  (Default: 1900-01-01)   -> null
    - > DataMax  (Default: 2100-12-31)   -> null

    Entradas aceitas
    ---------------
    - date, datetime, datetimezone
    - texto (com cultura)
    - número serial (estilo Excel/Access: 0 = 1899-12-30 por padrão)

    Melhorias
    ---------
    - Text.Trim antes de converter
    - Remoção opcional de "00:00:00" em strings antes da conversão

    Como usar
    ---------
    fxSanitizaDatas(
        Tabela,
        {"DT_COMPRA", "INIC_DEPREC", "DATA_FATURAMENTO", "DATA_ULT_MOV"},
        null, null, null, "pt-BR", true
    )

    Autor: Dennis (projeto) + ChatGPT
    Licença: MIT (sugestão)
*/

let
    fxSanitizaDatas =
        (
            Tabela as table,
            ColunasData as list,
            optional DataMin as nullable date,
            optional DataMax as nullable date,
            optional DataZero as nullable date,
            optional Cultura as nullable text,
            optional RemoverHoraZero as nullable logical
        )
        as table =>
        let
            // Defaults
            vDataMin  = if DataMin  = null then #date(1900, 1, 1)   else DataMin,
            vDataMax  = if DataMax  = null then #date(2100, 12, 31) else DataMax,
            vDataZero = if DataZero = null then #date(1899, 12, 30) else DataZero,
            vCultura  = if Cultura  = null then "pt-BR"             else Cultura,
            vRemHora0 = if RemoverHoraZero = null then true         else RemoverHoraZero,

            // Função interna: converte e valida 1 valor de data
            fxSanitizaData = (v as any) as nullable date =>
                let
                    // Normaliza texto (TRIM + remove "00:00:00")
                    txt =
                        if v = null then
                            null
                        else
                            let
                                t0 = Text.Trim(Text.From(v)),
                                t1 = if vRemHora0 then Text.Replace(t0, " 00:00:00", "") else t0,
                                t2 = if vRemHora0 then Text.Replace(t1, "00:00:00", "") else t1,
                                t3 = Text.Trim(t2)
                            in
                                if t3 = "" then null else t3,

                    // Tenta converter (prioriza tipos já data/datetime; depois número serial; depois texto)
                    d1 =
                        if v = null then
                            null
                        else if Value.Is(v, type date) then
                            v
                        else if Value.Is(v, type datetime) or Value.Is(v, type datetimezone) then
                            Date.From(v)
                        else if Value.Is(v, type number) then
                            // serial estilo Excel/Access: 0 = 1899-12-30 (por padrão)
                            Date.AddDays(vDataZero, Number.From(v))
                        else
                            let
                                tDate     = if txt = null then [HasError = true, Value = null] else try Date.FromText(txt, vCultura),
                                tDateTime = if txt = null then [HasError = true, Value = null] else try Date.From(DateTime.FromText(txt, vCultura))
                            in
                                if tDate[HasError] = false then
                                    tDate[Value]
                                else if tDateTime[HasError] = false then
                                    tDateTime[Value]
                                else
                                    null,

                    // Regras de invalidação
                    d2 =
                        if d1 = null then
                            null
                        else if d1 = vDataZero or d1 < vDataMin or d1 > vDataMax then
                            null
                        else
                            d1
                in
                    d2,

            // Só transforma as colunas que existirem na tabela (evita erro)
            ColunasExistentes = List.Intersect({ColunasData, Table.ColumnNames(Tabela)}),

            Transformacoes =
                List.Transform(
                    ColunasExistentes,
                    (c) => {c, each fxSanitizaData(_), type nullable date}
                ),

            Resultado =
                if List.Count(Transformacoes) = 0
                then Tabela
                else Table.TransformColumns(Tabela, Transformacoes)
        in
            Resultado
in
    fxSanitizaDatas
