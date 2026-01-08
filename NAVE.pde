////////////////////////////////
// -> NAVE
////////////////////////////////
void moverNave() {
  if (up) y -= vel;   // Mover para cima
  if (down) y += vel; // Mover para baixo
  if (left) x -= vel; // Mover para esquerda
  if (right) x += vel;// Mover para direita

  x = constrain(x, lado/2, width - lado/2); // Limitar dentro da tela
  y = constrain(y, lado/2, height - lado/2);
}

void desenharNave() {
  image(nave, x, y, 30, 30);  // Desenha nave na tela
}

////////////////////////////////
// -> TIROS DA NAVE
////////////////////////////////
void atualizarTirosNave() {
  for(int i=0;i<maxTirosNave;i++){
    if(tiroAtivo[i]){
      tiroY[i] -= velocidadeTiro;        // Move o tiro para cima
      fill(255);
      ellipse(tiroX[i], tiroY[i], 8, 8); // Desenha o tiro

      if(tiroY[i]<0) tiroAtivo[i]=false; // Desativa se sair da tela
    }
  }
}
