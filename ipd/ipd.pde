String[] _strategy = {"Random", "AllC", "AllD", "TFT", "Friedman", "Tullock"};
float[][] _score = { {3.0,0.0}, {5.0,1.0} };
int _steps = 100;

Agent[][] _agentArray;
int _cellSize = 10;
int _numX,_numY;
int offsetY = 100;

void setup(){
  size(250, 200);
  frameRate(12);
  _numX = floor(width/_cellSize);
  _numY = 2; //floor(height/_cellSize);
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
  int enemyY;
  for (int x = 0; x < _numX; x++){
    for (int y = 0; y < _numY; y++){      
      if ( y == 0 ) { enemyY = y + 1; }
      else { enemyY = y - 1; }
      _agentArray[x][y].addEnemies(_agentArray[x][enemyY]);
    }
  }
}

void draw(){
  background(200);
  
  for (int x = 0; x < _numX; x++){
    for (int y = 0; y < _numY; y++){
    _agentArray[x][y].calcNextAction(_agentArray[x][y]);
    _agentArray[x][y].calcScore(_agentArray[x][y]);
    }
  }
  
  //translate(_cellSize/2, _cellSize/2);
  
  for (int x = 0; x < _numX; x++){
    for (int y = 0; y < _numY; y++){
    _agentArray[x][y].drawMe();
    }
  }
  
  calcAdvStrategy();
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
  float scores;
  Agent[] enemies;

  Agent(float ex, float why){
    x = ex * _cellSize;
    y = why * _cellSize + offsetY;
    strategy = _strategy[int(random(6))];
    moves = new int[0];
    scores = 0.0;
    enemies = new Agent[0];
  }
  
  void addEnemies(Agent agent){
    enemies = (Agent[])append(enemies, agent);
  }
  
  void calcNextAction(Agent agent){
    switch(strategy){
      case "Random":
        nextAction = int(random(2));
        moves = (int[])append(moves, nextAction);
        break;
      case "AllC":
        nextAction = 0;
        moves = (int[])append(moves, nextAction);
        break;
      case "AllD":
        nextAction = 1;
        moves = (int[])append(moves, nextAction);
        break;
      case "TFT":
        nextAction = tft(enemies[0]);
        moves = (int[])append(moves, nextAction);
        break;
      case "Friedman":
        nextAction = freidman(enemies[0]);
        moves = (int[])append(moves, nextAction);
        break;
      case "Tullock":
        nextAction = tullock(enemies[0]);
        moves = (int[])append(moves, nextAction);
        break;
    }
  }
  
  // return enemy's last action
  int tft(Agent agent){
    if (moves.length == 0){
      nextAction = 0;
    } else {
      nextAction = moves[moves.length-1];
    }
    return nextAction;
  }
  
  // at least one
  int freidman(Agent agent){
    if (moves.length == 0){
      nextAction = 0;
    } else {
      nextAction = 0;
      for (int i=moves.length-1; i>0; i--){
        if (moves[i] == 1){
          nextAction = 1;
          break;
        }
      }
    }
    return nextAction;
  }
  
  // till first 10 actions 
  int tullock(Agent agent){
    if (moves.length < 10){
      nextAction = 0;
    } else {
      int num = 0;
      for (int i=0; i<10; i++){
        if (moves[i] == 1){ num++;}
      }
      // caliculate next action based on enemy's coop rate
      float rate = num/10 - 0.1;
      if (rate < 0){rate = 0;}
      if (random(1) < rate){ nextAction = 0; }
      else { nextAction = 1; }
    }
    return nextAction;
  }
  
  void calcScore(Agent agent){
    if (moves.length > 0 && enemies[0].moves.length > 0){
      action = moves[moves.length-1];
      int enemyAction = enemies[0].moves[enemies[0].moves.length-1];
      float score=_score[action][enemyAction];
      scores = score + scores;
    }
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

void calcAdvStrategy(){
  float[] sumStrategy = {0,0,0,0,0,0};
  int[] numStrategy = {0,0,0,0,0,0};

  for (int x = 0; x < _numX; x++){
    for (int y = 0; y < _numY; y++){
      switch(_agentArray[x][y].strategy){
      case "Random":
        sumStrategy[0]=sumStrategy[0]+_agentArray[x][y].scores;
        numStrategy[0]++;
        break;
      case "AllC":
        sumStrategy[1]=sumStrategy[1]+_agentArray[x][y].scores;
        numStrategy[1]++;
        break;
      case "AllD":
        sumStrategy[2]=sumStrategy[2]+_agentArray[x][y].scores;
        numStrategy[2]++;
        break;
      case "TFT":
        sumStrategy[3]=sumStrategy[3]+_agentArray[x][y].scores;
        numStrategy[3]++;
        break;
      case "Friedman":
        sumStrategy[4]=sumStrategy[4]+_agentArray[x][y].scores;
        numStrategy[4]++;
        break;
      case "Tullock":
        sumStrategy[5]=sumStrategy[5]+_agentArray[x][y].scores;
        numStrategy[5]++;
        break;
      }
    }
  }
  
  for (int i=0; i<6; i++){
    int textX = 10;
    int textY = 10;
    //fill(0);
    text(i, textX, textY+10*i);
    text(numStrategy[i], textX+10, textY+10*i);
    text(sumStrategy[i]/numStrategy[i], textX+30, textY+10*i);
  }
}