////////////////////////////////
// -> HORDA DE INIMIGOS
////////////////////////////////
void iniciarHorda() {
  int cols = 6;                           // Colunas da horda
  int rows = ceil(totalInimigos / (float)cols); // Linhas
  float startX = 60; 
  float startY = 40;
  float spacingX = 70; 
  float spacingY = 50;

  for (int i = 0; i < totalInimigos; i++) {
    vivo[i] = true;                        // Inimigo vivo
    int col = i % cols;
    int row = i / cols;
    ix[i] = startX + col * spacingX;       // Posição X
    iy[i] = startY + row * spacingY;       // Posicão Y
    proxTiroInimigo[i] = frameCount + int(random(120, 300)); // Próximo tiro aleatório
  }

  hordaAtiva = true;
  indoDireita = true;
}

void atualizarHorda() {
  boolean bateu = false;

  for (int i = 0; i < totalInimigos; i++) {
    if (!vivo[i]) continue;
    if (indoDireita) ix[i] += movimentoX;
    else ix[i] -= movimentoX;

    if (ix[i] > limiteDireita || ix[i] < limiteEsquerda) bateu = true;
  }

  if (bateu) {
    indoDireita = !indoDireita;
    for (int i = 0; i < totalInimigos; i++) {
      if (vivo[i]) iy[i] += descida;
    }
  }

  for (int i = 0; i < totalInimigos; i++) {
    if (!vivo[i]) continue;
    image(inimigoSprite, ix[i], iy[i], 30, 30); // Desenhar inimigo

    // Colisão com tiros
    for(int j=0;j<maxTirosNave;j++){
      if(tiroAtivo[j] && dist(tiroX[j], tiroY[j], ix[i], iy[i]) < 20){
        vivo[i]=false;
        tiroAtivo[j]=false;
        pontuacao += 10;
      }
    }

    if(frameCount >= proxTiroInimigo[i]){
      inimigoAtira(ix[i], iy[i]);
      proxTiroInimigo[i] = frameCount + int(random(120, 300));
    }
  }
}

boolean todosMortos() {
  for (int i = 0; i < totalInimigos; i++) {
    if (vivo[i]) return false; // Se algum vivo, retorna false
  }
  return true;
}
