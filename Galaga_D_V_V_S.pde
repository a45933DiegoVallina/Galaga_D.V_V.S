import gifAnimation.*;  // Biblioteca para lidar com GIFs animados
import processing.sound.*;  //Biblioteca de áudio nativa do Processing Foundation
SoundFile som; // Variavel "som" para buscar arquivos de som em "data" 



////////////////////////////////
// -> DECLARAÇÃO DE VARIÁVEIS //
////////////////////////////////


// Imagens do jogo
PImage bg;                       // Fundo do jogo
PImage nave;                     // Sprite da nave do jogador
PImage inimigoSprite;            // Sprite dos inimigos normais
PImage boss;                     // Sprite do boss

// ------------------------
// NAVE (JOGADOR)
// ------------------------
float x, y;                      // Posição da nave
float vel = 10;                  // Velocidade de movimento
float lado = 30;                 // Largura da nave para colisão
boolean up, down, left, right;   // Flags para detectar teclas pressionadas

// ------------------------
// TIROS DA NAVE
// ------------------------
int maxTirosNave = 10;           // Número máximo de tiros ativos
float[] tiroX = new float[maxTirosNave]; // Posição X dos tiros
float[] tiroY = new float[maxTirosNave]; // Posição Y dos tiros
boolean[] tiroAtivo = new boolean[maxTirosNave]; // Se o tiro está ativo
float velocidadeTiro = 10;       // Velocidade dos tiros

// ------------------------
// HORDA DE INIMIGOS
// ------------------------
int totalInimigos = 12;          // Quantidade inicial de inimigos
int maxInimigos = 50;            // Quantidade máxima de inimigos
float[] ix = new float[maxInimigos]; // Posições X dos inimigos
float[] iy = new float[maxInimigos]; // Posições Y dos inimigos
boolean[] vivo = new boolean[maxInimigos]; // Se o inimigo está vivo

// movimento lateral
float movimentoX = 1.2;          // Velocidade horizontal da horda
boolean indoDireita = true;      // Direção atual da horda
float limiteDireita = 560;       // Limite direito da horda
float limiteEsquerda = 40;       // Limite esquerdo da horda
float descida = 15;              // Quanto desce ao bater na borda

// ------------------------
// TIROS DOS INIMIGOS
// ------------------------
int maxTirosInimigo = 100;       // Máximo de tiros ativos inimigos
boolean[] tiroInimigoAtivo = new boolean[maxTirosInimigo]; // Se está ativo
float[] tx = new float[maxTirosInimigo]; // Posições X dos tiros inimigos
float[] ty = new float[maxTirosInimigo]; // Posições Y dos tiros inimigos
float velTiroInimigo = 5;        // Velocidade dos tiros inimigos

// tempo aleatório de disparo
int[] proxTiroInimigo = new int[maxInimigos]; // Contador de próximo tiro

// ------------------------
// VARIÁVEIS DE JOGO
// ------------------------
boolean hordaAtiva = false;      // Se horda normal está ativa
int vida = 3;                     // Vida do jogador
boolean gameOver = false;         // Flag de game over
int pontuacao = 0;                // Pontuação do jogador
int hordaAtual = 1;               // Número da horda atual
int incrementoPorHorda = 3;       // Quantidade de inimigos aumenta por horda

// ------------------------
// MENU
// ------------------------
Gif gifMenu;                      // GIF animado do menu
boolean jogoIniciado = false;     // Se o jogo iniciou

// ------------------------
// BOSS
// ------------------------
boolean bossAtivo = false;        // Se o boss está ativo
float bossX, bossY;               // Posição do boss
float bossLargura = 80, bossAltura = 60; // Tamanho do boss
float bossVel = 1.5;              // Velocidade de movimento do boss
int bossVida;                      // Vida atual do boss
int bossProxTiro = 0;             // Contador para próximo tiro do boss
int bossMaxVida;                   // Vida máxima do boss

int maxTirosBoss = 50;             // Máximo de tiros do boss
boolean[] tiroBossAtivo = new boolean[maxTirosBoss]; // Tiros ativos do boss
float[] bx = new float[maxTirosBoss]; // Posições X tiros boss
float[] by = new float[maxTirosBoss]; // Posições Y tiros boss
float velTiroBoss = 4;            // Velocidade tiros boss

// ------------------------
// RANKING
// ------------------------
ArrayList<Score> ranking = new ArrayList<Score>();
int maxRanking = 10;
boolean pedirNome = false;
String nomeJogador = "";

////////////////////////////////
// -> SETUP
////////////////////////////////
void setup() {
  size(800, 600);                 // Tamanho da tela
  rectMode(CENTER);               // Desenhar retângulos pelo centro
  imageMode(CENTER);              // Desenhar imagens pelo centro

  bg = loadImage("background.png");     // Carregar fundo
  nave = loadImage("nave.png");         // Carregar sprite da nave
  inimigoSprite = loadImage("inimigo.png"); // Carregar inimigos
  boss = loadImage("boss.png");         // Carregar boss
  
  som = new SoundFile(this, "tema.mp3"); //chamar o arquivo que já está em "data"
  som.play();            //Essa variável eu peguei do site processing, mas ela é dedicada a dar PLAY

  x = width/2;                   // Posicionar nave no centro
  y = height - 50;               // Posição vertical da nave

  // Inicializar tiros inativos
  for(int i=0;i<maxTirosNave;i++) tiroAtivo[i]=false;

  // Carregar GIF do menu e iniciar
  gifMenu = new Gif(this, "gif_menu.gif");
  gifMenu.play();
  carregarRanking();

}

////////////////////////////////
// -> DRAW
////////////////////////////////
void draw() {

  // Se o jogo não começou, mostrar menu
  if (!jogoIniciado) {
  mostrarMenu();
  return;
  }
  if (mostrarTop) {
    mostrarRankingAnimado();
    return;
  }
  



  image(bg, width/2, height/2, width, height); // Desenhar fundo
  

  moverNave();             // Atualiza posição da nave
  desenharNave();          // Desenha a nave
  atualizarTirosNave();    // Atualiza os tiros do jogador

  // Horda normal
  if (hordaAtiva && !bossAtivo) {
    atualizarHorda();        // Atualiza inimigos normais
    atualizarTirosInimigos();// Atualiza tiros inimigos

    if (todosMortos()){      // Se todos inimigos mortos
      hordaAtual++;          
      if (hordaAtual == 5) { // Se horda 5, iniciar boss
        iniciarBoss();
      } else {
        totalInimigos = min(totalInimigos + incrementoPorHorda, maxInimigos); 
        movimentoX += 0.1; 
        velTiroInimigo += 0.3; 
        iniciarHorda();
      }
    }
  }

  // Atualizar boss se ativo
  if (bossAtivo) atualizarBoss();

  // HUD centralizado
  fill(255);
  textSize(20);
  textAlign(CENTER);
  text("Vidas: " + vida + "   Pontuação: " + pontuacao + "   Horda: " + hordaAtual, width/2, 30);

  if (vida <= 0) gameOver = true; // Se vida <=0, game over

  // Tela de Game Over
  if (gameOver)
  {
    fill(0, 150);                     // Fundo semi-transparente
    rect(width/2, height/2, width, height);
    fill(255,0,0);
    textSize(40);
    textAlign(CENTER, CENTER);
    text("GAME OVER\nAperte R para reiniciar", width/2, height/2);
  }
}

////////////////////////////////
// -> INPUT
////////////////////////////////
void keyPressed() {
  if (!jogoIniciado && keyCode == ENTER)
  {
    jogoIniciado = true;
    iniciarHorda();
    return;
  }

  char c = Character.toLowerCase(key);
  if (c == 'w') up = true;
  if (c == 's') down = true;
  if (c == 'a') left = true;
  if (c == 'd') right = true;

  if (key == ' ') { // Atirar
    for(int i=0;i<maxTirosNave;i++){
      if(!tiroAtivo[i]){
        tiroX[i] = x;
        tiroY[i] = y - 15;
        tiroAtivo[i] = true;
        break;
      }
    }
  }

  if (c == 'r' && gameOver) { // Reiniciar jogo
    vida = 3;
    gameOver = false;
    hordaAtiva = false;
    bossAtivo = false;
    pontuacao = 0;
    hordaAtual = 1;
    totalInimigos = 12;
    movimentoX = 1.2;
    velTiroInimigo = 5;
    for(int i=0;i<maxTirosNave;i++) tiroAtivo[i]=false;
    for(int i=0;i<maxTirosInimigo;i++) tiroInimigoAtivo[i]=false;
    for(int i=0;i<maxTirosBoss;i++) tiroBossAtivo[i]=false;
    iniciarHorda();
  }
  // RANKING
  if (pedirNome) 
  {
    if (key == ENTER) 
    {
      adicionarScore(nomeJogador, pontuacao);
      pedirNome = false;
    } 
    else if (key == BACKSPACE && nomeJogador.length() > 0) 
    {
      nomeJogador = nomeJogador.substring(0, nomeJogador.length() - 1);
    } 
    else if (key >= 'A' && key <= 'Z' || key >= 'a' && key <= 'z') 
    {
      nomeJogador += key;
    }
  }
}

void keyReleased() {
  char c = Character.toLowerCase(key);
  if (c == 'w') up = false;
  if (c == 's') down = false;
  if (c == 'a') left = false;
  if (c == 'd') right = false;
}
