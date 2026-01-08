import java.util.ArrayList;

class Score {
  String nome;
  int pontos;
  String dataHora;

  Score(String nome, int pontos) {
    this.nome = nome;
    this.pontos = pontos;
    this.dataHora = dataAtual();
  }

  String dataAtual() {
    return nf(day(),2) + "/" + nf(month(),2) + "/" + year() + 
           " " + nf(hour(),2) + ":" + nf(minute(),2);
  }
}


void carregarRanking() {

  ranking.clear();                     // Limpa lista atual

  String[] linhas = loadStrings("ranking.txt");

  // Se não existir arquivo, não faz nada
  if (linhas == null) return;

  for (String linha : linhas) {

    if (linha == null || linha.trim().equals("")) continue;

    String[] partes = split(linha, ";");

    // FORMATO NOVO: nome;pontos;dataHora
    if (partes.length == 3) {
      Score s = new Score(partes[0], int(partes[1]));
      s.dataHora = partes[2];          // Mantém data original
      ranking.add(s);
    }

    // FORMATO ANTIGO: nome;pontos
    else if (partes.length == 2) {
      Score s = new Score(partes[0], int(partes[1]));
      // dataHora é gerada automaticamente no construtor
      ranking.add(s);
    }
  }

  // Ordena do maior para o menor
  ranking.sort((a, b) -> b.pontos - a.pontos);

  // Garante tamanho máximo do ranking
  while (ranking.size() > maxRanking) {
    ranking.remove(ranking.size() - 1);
  }
}


void salvarRanking() {
  String[] linhas = new String[ranking.size()];
  for (int i = 0; i < ranking.size(); i++) {
    Score s = ranking.get(i);
    linhas[i] = s.nome + ";" + s.pontos + ";" + s.dataHora;

  }
  saveStrings("ranking.txt", linhas);
}

void verificarRanking() {
  if (ranking.size() < maxRanking || pontuacao > ranking.get(ranking.size()-1).pontos) {
    pedirNome = true;
    nomeJogador = "";
  }
}

void adicionarScore(String nome, int pontos) {
  ranking.add(new Score(nome, pontos));

  ranking.sort((a, b) -> b.pontos - a.pontos); // Ordem decrescente

  if (ranking.size() > maxRanking) {
    ranking.remove(ranking.size() - 1);
  }

  salvarRanking();
}
