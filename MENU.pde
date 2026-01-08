////////////////////////////////
// -> MENU
////////////////////////////////
void mostrarMenu() {
  image(bg, width/2, height/2, width, height);          // Desenhar fundo
  image(gifMenu, width/2, height/2, width, height);    // Desenhar GIF do menu

  fill(255);
  textSize(30);
  textAlign(CENTER, CENTER);
  text("Pressione ENTER para jogar", width/2, height - 50);
  
  // Botão TOP (Chat GePeTo)
  fill(50, 150, 255);
  rect(btnX, btnY, btnW, btnH, 8);

  fill(255);
  textSize(20);
  textAlign(CENTER, CENTER);
  text("VER TOP 10", btnX, btnY);

}

//A partir daqui foi o chatGePeTo. 
float animY = 450;   // começa fora da tela
float animAlpha = 0;
boolean animandoRanking = false;

boolean mostrarTop = false;

float btnX = 300;
float btnY = 300;
float btnW = 200;
float btnH = 40;


void iniciarAnimacaoRanking() {
  animY = height + 50;
  animAlpha = 0;
  animandoRanking = true;
}

void mostrarRankingAnimado() {

  if (animandoRanking) {
    animY = lerp(animY, 120, 0.08);
    animAlpha = min(animAlpha + 6, 255);

    if (abs(animY - 120) < 1) animandoRanking = false;
  }

  fill(255, animAlpha);
  textSize(28);
  textAlign(CENTER);
  text("TOP 5", width/2, animY - 40);

  textSize(18);
  for (int i = 0; i < ranking.size(); i++) {
    Score s = ranking.get(i);
    fill(255, animAlpha);
    text(
      (i+1) + ". " + s.nome + " - " + s.pontos + "  (" + s.dataHora + ")",
      width/2,
      animY + i * 30
    );
  }
}
