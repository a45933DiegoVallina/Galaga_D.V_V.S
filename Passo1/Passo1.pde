PImage bg;                  // imagem de fundo

// nave
float x, y;                 // posição da nave
float vel = 10;             // velocidade da nave
float lado = 30;            // tamanho da nave
PImage nave;
boolean up, down, left, right, shot; // movimentos e tecla de tiro

// tiro
float tiroX, tiroY;         // posição do tiro
float velocidadeTiro = 10;  // velocidade do tiro (pra cima)
boolean tiroAtivo = false;

// dano/tempo
int ultimoAcerto = -1;      // ms do último hit
int duracaoDano = 300;      // ms vermelho
int duracaoDesaparecer = 100; // ms até sumir (desde o hit)

// inimigo
float inimigoX, inimigoY;   // posição inimigo
float tamanhoI;             // Diametro inimgo
PImage inimigo;
boolean inimigoVivo = true; // estado de vida

void setup() {
  size(800, 600);
  rectMode(CENTER);
  imageMode(CENTER);

  x = width/2;
  y = height - 50;

  inimigoX = -15;           // Posição inicial I
  inimigoY = 100;
  tamanhoI = 30;

  bg = loadImage("background.png");
  nave = loadImage("nave.png");
  inimigo = loadImage("inimigo.png");
}

void draw() {
  // fundo
  image(bg, width/2, height/2, width, height);

  //movimento da nave
  if (up)    y -= vel;
  if (down)  y += vel;
  if (left)  x -= vel;
  if (right) x += vel;
  x = constrain(x, lado/2, width - lado/2);
  y = constrain(y, lado/2, height - lado/2);

  // desenhar nave
  noStroke();
  image(nave, x, y, 30, 30);

  // tiro 
  if (tiroAtivo) {
    tiroY -= velocidadeTiro;
    fill(255);
    ellipse(tiroX, tiroY, 10, 10);
    if (tiroY < 0) tiroAtivo = false;
  }

  //  inimigo
  if (inimigoVivo) {
    // movimento
    inimigoX += 1;
    if (inimigoX - tamanhoI/2 > width) {
      inimigoX = -tamanhoI/2;
    }

    // janelas de tempo desde o hit
    int tempoPassado = (ultimoAcerto >= 0) ? millis() - ultimoAcerto : 999999;
    boolean emDano = (tempoPassado < duracaoDano);
    if (tempoPassado > duracaoDesaparecer && ultimoAcerto >= 0) {
      inimigoVivo = false;     // some após a janela
    } else {
      if (emDano) tint(255, 0, 0);
      else        tint(255);

      image(inimigo, inimigoX, inimigoY, tamanhoI, tamanhoI);
      noTint();
    }

    // colisão (raio = tamanhoI/2)
    if (tiroAtivo && dist(tiroX, tiroY, inimigoX, inimigoY) < tamanhoI/2) {
      ultimoAcerto = millis(); // inicia cronômetro de dano/desaparecer
      tiroAtivo = false;       // consome tiro
    }
  }

  // respawn
  if (!inimigoVivo && ultimoAcerto >= 0 && millis() - ultimoAcerto > duracaoDesaparecer + 2000) {
    inimigoVivo = true;
    ultimoAcerto = -1;
    inimigoX = -tamanhoI/2;
    inimigoY = random(70, 200);
  }
}

void keyPressed() {
  char c = Character.toLowerCase(key);
  if (c == 'w') up = true;
  if (c == 's') down = true;
  if (c == 'a') left = true;
  if (c == 'd') right = true;

  if (key == ' ') {
    shot = true;
  //  if (!tiroAtivo) {
      tiroX = x;
      tiroY = y - lado/2;
      tiroAtivo = true;
   // }
  }
}

void keyReleased() {
  char c = Character.toLowerCase(key);
  if (c == 'w') up = false;
  if (c == 's') down = false;
  if (c == 'a') left = false;
  if (c == 'd') right = false;
  if (key == ' ') shot = false;
}
