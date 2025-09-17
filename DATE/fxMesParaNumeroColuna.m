// fxMesParaNumeroColuna — compatível sem Text.RemoveDiacritics
// Converte uma coluna de meses por extenso (MAIÚSCULO) em número (1–12).
(tabela as table, nomeColuna as text, optional novoNome as nullable text) as table =>
let
    // Normaliza: trim, maiúsculas e substituições básicas de acento
    fnNormaliza = (txt as any) as nullable text =>
        if txt = null then null else
        let
            t0   = Text.From(txt),
            t1   = Text.Trim(t0),
            t2   = Text.Upper(t1),
            subs = {{"Á","A"},{"À","A"},{"Ã","A"},{"Â","A"},{"Ä","A"},
                    {"É","E"},{"Ê","E"},{"È","E"},{"Ë","E"},
                    {"Í","I"},{"Ì","I"},{"Î","I"},{"Ï","I"},
                    {"Ó","O"},{"Ò","O"},{"Ô","O"},{"Õ","O"},{"Ö","O"},
                    {"Ú","U"},{"Ù","U"},{"Û","U"},{"Ü","U"},
                    {"Ç","C"}},
            norm = List.Accumulate(subs, t2, (state, pair) => Text.Replace(state, pair{0}, pair{1}))
        in
            norm,

    // Mapeia um valor para número do mês
    fnMesParaNumero = (v as any) as nullable number =>
        if v = null then null
        else if Value.Is(v, type number) then Number.RoundDown(Number.From(v))
        else if Value.Is(v, type date) then Date.Month(Date.From(v))
        else
            let
                t     = fnNormaliza(v),
                meses = {"JANEIRO","FEVEREIRO","MARCO","ABRIL","MAIO","JUNHO","JULHO","AGOSTO","SETEMBRO","OUTUBRO","NOVEMBRO","DEZEMBRO"},
                pos   = List.PositionOf(meses, t, Occurrence.First)
            in
                if pos = -1 then null else pos + 1,

    saida =
        if novoNome = null or novoNome = "" or novoNome = nomeColuna then
            Table.TransformColumns(tabela, {{nomeColuna, each fnMesParaNumero(_), Int64.Type}})
        else
            Table.AddColumn(tabela, novoNome, each fnMesParaNumero(Record.Field(_, nomeColuna)), Int64.Type)
in
    saida
