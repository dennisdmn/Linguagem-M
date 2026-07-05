# TEXTO

Funcoes Power Query M para tratamento, padronizacao e limpeza de textos.

## fxRemovedorAcentosCaracteresEspeciais

Arquivo: [`fxRemovedorAcentosCaracteresEspeciais.m`](./fxRemovedorAcentosCaracteresEspeciais.m)

Remove acentos, converte o texto para maiusculas e preserva apenas os caracteres permitidos na lista interna da funcao.

A funcao usa o mesmo principio que estava no Google Doc `Exemplo de Funcoes Power - Linguagem M`:

- `Text.ToList` para quebrar o texto em caracteres;
- `List.ReplaceMatchingItems` para trocar caracteres acentuados por equivalentes sem acento;
- `Text.Combine` para montar o texto novamente;
- `Text.Select` para manter somente caracteres permitidos.

Exemplo:

```m
fxRemovedorAcentosCaracteresEspeciais("João & Márcia - Área de TI")
```

Resultado esperado:

```text
JOAO E MARCIA - AREA DE TI
```

## fxSanitizaPorCSVEncoding

Arquivo: [`fxSanitizaPorCSVEncoding.m`](./fxSanitizaPorCSVEncoding.m)

Alternativa de sanitizacao por conversao de encoding. Pode ser util quando o objetivo for forcar uma limpeza mais agressiva de caracteres nao suportados.

## Quando usar cada uma

- Use `fxRemovedorAcentosCaracteresEspeciais` quando quiser controle explicito sobre quais caracteres substituir e quais manter.
- Use `fxSanitizaPorCSVEncoding` quando quiser uma abordagem mais automatica baseada em encoding.
