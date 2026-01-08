////////////////////////////////
// -> TIROS DOS INIMIGOS
////////////////////////////////
void inimigoAtira(float px, float py) {
  for (int i = 0; i < maxTirosInimigo; i++) {
    if (!tiroInimigoAtivo[i]) {
      tiroInimigoAtivo[i] = true;
      tx[i] = px;
      ty[i] = py;
      return;
    }
  }
}

void atualizarTirosInimigos() {
  fill(255,100,100);
  for (int i = 0; i < maxTirosInimigo; i++) {
    if (tiroInimigoAtivo[i]) {
      ty[i] += velTiroInimigo;
      ellipse(tx[i], ty[i], 8, 8);

      if (dist(tx[i], ty[i], x, y) < 20) {
        tiroInimigoAtivo[i] = false;
        vida--;
        if (vida <= 0) gameOver = true;
      }

      if (ty[i] > height) tiroInimigoAtivo[i] = false;
    }
  }
}
