// =============================================================================
// fxMantemPrimeirasLinhasTabelaAninhada
// =============================================================================
// Mantém apenas as primeiras N linhas de uma coluna que contém tabelas aninhadas.
// Aplica Table.FirstN sobre cada célula que for do tipo table, ignorando
// células de outros tipos (null, texto, número, etc.) sem gerar erro.
//
// Parâmetros:
//   pTabela             (table)  — Tabela de entrada que contém a coluna aninhada
//   pNomeColunaTabela   (text)   — Nome da coluna cujos valores são tabelas aninhadas
//   pQuantidadeLinhas   (number) — Número de linhas a manter em cada tabela aninhada
//
// Retorno: table — mesma estrutura de pTabela, com a coluna aninhada truncada
//
// Dependências nativas:
//   Table.TransformColumns  — transforma a coluna no lugar (sem criar coluna auxiliar)
//   Table.FirstN            — retorna as N primeiras linhas de uma tabela
//   Value.Is                — verifica se o valor é do tipo table antes de transformar
//
// Exemplo de uso:
//   PrimeiraLinhaApenas = fxMantemPrimeirasLinhasTabelaAninhada(
//       LinhasMescladas,
//       "DimDePara_Hyperion",
//       1
//   )
// =============================================================================

( pTabela as table, pNomeColunaTabela as text, pQuantidadeLinhas as number ) as table =>
let
    // 🧱 Mantém a quantidade desejada de linhas da tabela aninhada
    Resultado = Table.TransformColumns(
        pTabela,
        {
            {
                pNomeColunaTabela,
                each
                    if Value.Is(_, type table) then
                        Table.FirstN(_, pQuantidadeLinhas)
                    else
                        _,
                type table
            }
        }
    )
in
    Resultado
