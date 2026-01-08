////////////////////////////////
// -> BOSS
////////////////////////////////
void iniciarBoss() {
  bossAtivo = true;             // Ativa boss
  hordaAtiva = false;           // Remove inimigos normais
  bossX = width/2;
  bossY = 80;
  bossLargura = 80;
  bossAltura = 60;
  bossVel = 1.5;
  bossMaxVida = 20;              // Aumentei pra não ser fácil demais 
  bossVida = bossMaxVida;
  bossProxTiro = frameCount + 120;
}

void atualizarBoss() {
  bossX += bossVel;
  if (bossX > width - bossLargura/2 || bossX < bossLargura/2) bossVel *= -1; // Reverte ao bater

  image(boss, bossX, bossY, bossLargura, bossAltura); // Desenhar boss

  // Mortal instantâneo por toque
  if (dist(x, y, bossX, bossY) < (bossLargura/2 + lado/2)) {
    vida = 0;
    gameOver = true;
  }

  // Colisão com tiros
  for (int i = 0; i < maxTirosNave; i++) {
    if (tiroAtivo[i] && dist(tiroX[i], tiroY[i], bossX, bossY) < (bossLargura/2 + 4)) {
      tiroAtivo[i] = false;
      bossVida--;
      if (bossVida <= 0) {
        bossAtivo = false;
        hordaAtual++;
        totalInimigos = min(totalInimigos + incrementoPorHorda, maxInimigos); 
        iniciarHorda();
      }
    }
  }

  // Atirar lentamente
  if (frameCount >= bossProxTiro) {
    bossAtira();
    bossProxTiro = frameCount + 120;
  }

  atualizarTirosBoss();
}

void bossAtira() {
  for (int i = 0; i < maxTirosBoss; i++) {
    if (!tiroBossAtivo[i]) {
      tiroBossAtivo[i] = true;
      bx[i] = bossX;
      by[i] = bossY;
      return;
    }
  }
}

void atualizarTirosBoss() {
  fill(255,0,0);
  for (int i = 0; i < maxTirosBoss; i++) {
    if (tiroBossAtivo[i]) {
      by[i] += velTiroBoss;
      ellipse(bx[i], by[i], 10, 10);

      if (dist(bx[i], by[i], x, y) < 20) {
        tiroBossAtivo[i] = false;
        vida = 0;
        gameOver = true;
      }
      if (by[i] > height) tiroBossAtivo[i] = false;
    }
  }
}
