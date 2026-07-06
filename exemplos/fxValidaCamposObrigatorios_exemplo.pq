let
    // 📁 Exemplo de tabela simulada para teste da função
    Fonte = #table(
        type table [
            empresa = text,
            filial = text,
            debito = text,
            credito = text,
            valor = number,
            hist = text,
            ccustod = text,
            ccustoc = text,
            usuario = text,
            clvlrdeb = text,
            clvlrcrd = text,
            ent05deb = text,
            ent05crd = text,
            tpsaldo = text,
            lote = text,
            versao = text,
            data = date
        ],
        {
            {"3113", "01", "110101", "210101", 1000, "LANÇAMENTO TESTE", "CC01", "CC02", "USUARIO1", "CL01", "CL02", "E01", "E02", "D", "001", "TNT", #date(2026, 7, 1)},
            {"3113", "01", null, "210101", 2500, "LANÇAMENTO TESTE", "CC01", "CC02", "USUARIO2", "CL01", "CL02", "E01", "E02", "C", "001", "TNT", #date(2026, 7, 2)},
            {"", "01", "110101", null, 500, "LANÇAMENTO TESTE", "CC01", "CC02", "USUARIO3", "CL01", "CL02", "E01", "E02", "D", "001", "TNT", #date(2026, 7, 3)}
        }
    ),

    // ✅ Valida campos obrigatórios informados por texto separado por vírgula
    Etapa_ValidaCamposObrigatorios = fxValidaCamposObrigatorios(
        Fonte,
        "empresa, filial, debito, credito, valor, hist, ccustod, ccustoc, usuario, clvlrdeb, clvlrcrd, ent05deb, ent05crd, tpsaldo, lote, versao, data"
    )
in
    Etapa_ValidaCamposObrigatorios
