# Prompt para resumir uma aula

Cole o prompt abaixo na sua IA (Claude, ChatGPT, Gemini...) junto com o arquivo `.txt` da
transcrição. Se usar o Claude Code ou outra ferramenta que lê arquivos, basta indicar o caminho.

---

Você vai resumir a transcrição automática de uma aula da matéria **<NOME DA MATÉRIA>**.
A transcrição foi feita por reconhecimento de voz, então pode ter palavras trocadas, nomes errados
e trechos sem pontuação. Corrija pelo contexto quando tiver certeza e marque com [?] quando não tiver.

Entregue em Markdown:

1. **Tema da aula** em uma frase.
2. **Pontos principais**: os conceitos explicados, em tópicos, cada um com 1 a 3 frases.
3. **Exemplos e exercícios** que o professor usou, de forma resumida.
4. **Avisos práticos**: datas de prova, entregas, trabalhos, material indicado. Se não houver, escreva
   "nenhum aviso".
5. **Dúvidas para revisar**: até 5 perguntas que eu deveria saber responder depois desta aula.

Regras: não invente conteúdo que não está na transcrição; não use conhecimento externo para
"completar" a aula, a não ser para corrigir um termo técnico claramente mal transcrito.

---

## Resumo geral da matéria (opcional)

Para revisar para a prova, mantenha um arquivo `resumos/RESUMO_GERAL.md` por matéria e peça,
a cada aula nova:

> Acrescente ao `RESUMO_GERAL.md` uma seção com a data desta aula e os pontos-chave, sem apagar
> o que já existe.
