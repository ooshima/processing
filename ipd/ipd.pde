String[] _strategy = {"Random", "AllC", "AllD", "TFT", "Friedman", "Tullock"};
float[][] _score = { {3.0,0.0}, {5.0,1.0} };
int _steps = 100;

Agent[][] _agentArray;
int _cellSize = 10;
int _numX,_numY;

void setup(){
  size(250, 20);
  frameRate(12);
  _numX = floor(width/_cellSize);
  _numY = floor(height/_cellSize);
  restart();
}

void restart(){
  _agentArray = new Agent[_numX][_numY];
  for (int x = 0; x<_numX; x++){
    for (int y = 0; y<_numY; y++){
      Agent newAgent = new Agent(x, y);
      _agentArray[x][y] = newAgent;
    }
  }
}

void draw(){
  background(200);
  
  for (int x = 0; x < _numX; x++){
    for (int y = 0; y < _numY; y++){
    _agentArray[x][y].calcNextAction();
    }
  }
  
  //translate(_cellSize/2, _cellSize/2);
  
  for (int x = 0; x < _numX; x++){
    for (int y = 0; y < _numY; y++){
    _agentArray[x][y].drawMe();
    }
  }
}

void mousePressed(){
  restart();
}

//=================================== object
class Agent {
  float x, y;
  int action;
  int nextAction;
  String strategy;
  int[] moves;
  float[] scores;

  Agent(float ex, float why){
    x = ex * _cellSize;
    y = why * _cellSize;
    strategy = _strategy[int(random(6))];
    moves = new int[0];
    scores = new float[0];
  }
  
  void calcNextAction(){
    switch(strategy){
      case "Random":
        nextAction = int(random(2));
        break;
      case "AllC":
        nextAction = 0;
        break;
      case "AllD":
        nextAction = 1;
        break;
      case "TFT":
        //nextAction = tft(action);
        break;
      case "Friedman":
        //nextAction = freidman(action);
        break;
      case "Tullock":
        //nextAction = tullock(action);
        break;
    }
  }
  
  void tft(Agent agent){
    if (moves.length == 1){
      nextAction = 0;
    }
  // to come
  }
  
  void freidman(){
  // to come
  }
  
  void tullock(){
  // to come
  }
  
  void calcScore(){
  // to come
  }
  
  void drawMe(){
    action = nextAction;
    stroke(0);
    if (action == 0){
      fill(0);
    } else if (action == 1){
      fill(150);
    } else {
      fill(255);
    }
    rect(x,y,_cellSize,_cellSize);  
  }
}