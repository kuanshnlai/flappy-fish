class Game{
  Player _player;
  Background _bg;
  int _width;
  int _height;
  int _posx,_posy;
  int cnt = 0;
  Game(int w,int h){
    _width = w;
    _height = h;
    _posx = w/2;
    _posy = h/2;
    _player = new Player(_posx,_posy);
    _bg = new Background(_width,_height);
  }
  boolean GameOver(){
    return _player.die(_bg);
  }
  void draw(){
    _bg.draw();
    _player.draw();
    if(_player.invincible){
      cnt++;
      _player._dy = 0;
      if(cnt == 100){
          _player.invincible = false;
          _player._dy = 1;
          cnt = 0;
      }
    }
    if(GameOver()){
      _player._dy = 0;
      _bg.pause();
      textSize(50);
      textAlign(CENTER);
      text("Game Over",_width/2,_height/2-70);
    }
    fill(255,255,255);
    textAlign(LEFT,TOP);
    textSize(20);
    text("hp:"+_player._hp,0,0);
  }
  void keyEvent(int key){
    if(GameOver()){
      return;
    }
    if(key == ' '){
      _player.jump();  
    }
  }
  
}
class Background{
  int _ground;
  int _width;
  int _height;
  int speed = 1;
  ArrayList<Pipe> pipes;
  Background(int w,int h){
    _width = w;
    _height = h;
    _ground = 600;
    pipes = new ArrayList<Pipe>();
  }
  void draw(){
    fill(0,0,255);
    rect(0,0,_width,_ground);
    fill(0,255,0);
    rect(0,_ground,_width,_height-_ground);
    for(int i = 0;i<pipes.size();i++){
      pipes.get(i).draw();
      pipes.get(i).move(speed);
      if(pipes.get(i)._x<=-70){
         pipes.remove(i);
      }
      
    }
    if(pipes.size()==0){
       int _x = int(random(_width))+_width;
       Pipe p = new Pipe(_x,300,100);
       pipes.add(p); 
    }
  }
  void pause(){
    speed = 0;
  }
    
}
class Player{
  int _posx,_posy;
  int _dx = 0;
  int _dy = 1;
  int _width = 20;
  int _height = 20;
  int _hp = 3;
  boolean invincible = false;
  int _iy;
  Player(int px,int py){
    _posx = px;
    _posy = py;
    _iy = py;
  }
  void sety(int y){
    _posy = y;
  }
  
  void draw(){
    if(!invincible){
      fill(255,255,255);
    }
    else{
      fill(255,0,0);  
    }
    rect(_posx,_posy,20,20);
    _posy+=_dy;
    if(_dy<=1){
      _dy++;  
    }
  }
  void jump(){
    _dy = -10;
  }
  boolean die(Background bg){
    if(_hp <= 0){
      return true;  
    }
    if(invincible){
      println("not invincible");
      return false;  
    }
    if(_posy>=bg._ground-_height){
      _hp--; 
      if(_hp>0){
        invincible = true;  
        sety(_iy);
      }
    }
    for(int i=0;i<bg.pipes.size();++i){
       if(bg.pipes.get(i).collision(this)){
         //println("collision");
         _hp--; 
         if(_hp>0){
          invincible = true;  
          sety(bg.pipes.get(i)._regiony+bg.pipes.get(i)._regionh/2);
         }
       }

    }
    if(_hp<=0){
      return true;  
    }
    return false;  
  }
}

class Pipe{
  int _x;
  int _regiony,_regionh;
  int _width;
  int _ground;
  Pipe(int x,int ry,int rh){
     _x = x;     
     _regiony = ry;
     _regionh = rh;
     _width = 70;
     _ground = 600;
  }
  boolean collision(Player p){
      if(_x<=p._posx&&p._posx<=_x+_width){
        if(p._posy<=_regiony||p._posy>=_regiony+_regionh-p._height){
          return true;
        }
      }
      return false;
  }
  void move(int i){
    _x-= i;  
  }
  void draw(){
    fill(0,255,0);
    rect(_x,0,_width,_regiony);
    rect(_x,_regiony+_regionh,_width,_ground-(_regiony+_regionh));
  }
}
Game game;
void setup(){
  size(600,900);
  game = new Game(width,height);
}

void draw(){
  game.draw();
}
void keyReleased(){
   game.keyEvent(key);
}
