/*
    Script básico de recursividade/Loop para adaptação
    em novos scripts/ETL de linguagem M que necessitem
    de repetições (Loopings).
*/

(
                Numero              as number,
                QtdLoopsDesejados   as number,
    optional    LoopsEfetuados      as number
)=>

let
    // Variável como contadora da qtde de Loops.
    LoopsEfetuados = 
        if LoopsEfetuados = null
        then 1
        else LoopsEfetuados + 1,

    // Código (Corpo) de execução
    Valor = Numero * 2,

    // Condicional para a decisão de chamar novamente a função e re-executar o código (corpo)
    out =
        if LoopsEfetuados >= QtdLoopsDesejados
        then Valor
        else @Recursividade_Loops (Valor, QtdLoopsDesejados, LoopsEfetuados)

in
    out
