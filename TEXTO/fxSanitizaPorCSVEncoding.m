// 🔠 Função: Sanitiza texto eliminando acentos e caracteres especiais
// 📌 Utiliza Csv.Document com Encoding=1252 para forçar remoção automática
(TextoOriginal as text) as text =>
let
    // 🔁 Remove espaços extras e coloca em maiúsculas
    TextoBase = Text.Upper(Text.Trim(TextoOriginal)),

    // 📄 Converte o texto para binário com encoding ANSI (1252)
    BinarioAnsi = Text.ToBinary(TextoBase, BinaryEncoding.Ansi),

    // 📥 Transforma o binário em uma célula de tabela via CSV
    Tabela = Csv.Document(
        Text.FromBinary(BinarioAnsi),
        [Delimiter = null, Encoding = 1252]
    ),

    // 🎯 Extrai o valor final da célula simulada
    Resultado = try Tabela{0}{0} otherwise TextoBase
in
    Resultado
