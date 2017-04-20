String[] _race = {"penny", "dime"};
int _bgColor = 175;

Cell[][] _cellArray;
int _cellSize = 10;
int _numX, _numY;

Agent[] _agentArray;
int _numAgent;

void setup(){
  size(500, 300);
  _numX = floor(width/_cellSize);
  _numY = floor(height/_cellSize);
  _numAgent = int((_numX * _numY)*2/3*1/2);  //エージェント数は格子全体の2/3を埋めるくらい
  //println(_numAgent);
  restart();
}

void restart(){
  _cellArray = new Cell[_numX][_numY];
  for (int x = 0; x<_numX; x++){
    for (int y =0; y<_numY; y++){
    Cell newCell = new Cell(x, y);
    _cellArray[x][y] = newCell;
    }
  }
  
  for (int x = 0; x < _numX; x++){
    for (int y = 0; y < _numY; y++){
          
    int above = y-1;
    int below = y+1;
    int left = x-1;
    int right = x+1;
    
    if (above < 0) { above = _numY-1;}
    if (below == _numY) {below = 0;}
    if (left < 0) { left = _numX-1;}
    if (right ==_numX) {right = 0;}
    
    _cellArray[x][y].addNeighbour(_cellArray[left][above]);
    _cellArray[x][y].addNeighbour(_cellArray[left][y]);
    _cellArray[x][y].addNeighbour(_cellArray[left][below]);
    _cellArray[x][y].addNeighbour(_cellArray[x][below]);
    _cellArray[x][y].addNeighbour(_cellArray[right][below]);
    _cellArray[x][y].addNeighbour(_cellArray[right][y]);
    _cellArray[x][y].addNeighbour(_cellArray[right][above]);
    _cellArray[x][y].addNeighbour(_cellArray[x][above]);
    }
  }
  
  //エージェントをばらまく（格子配列のインデックスをシャッフルして欲しい数だけ先頭から取得）
  _agentArray = new Agent[_numAgent * _race.length];
  
  //すべての格子座標インデックスの配列を作る
  int nums[][] = new int[_numX * _numY][2];
  int k=0;
  for (int i=0; i < _numX; i++){
    for (int j=0; j < _numY; j++){
      nums[k][0] = i;
      nums[k][1] = j;
      //println(nums[k][0],nums[k][1]);
      k++;
    }
  }
  
  IntList idx = new IntList(_numX * _numY);
  for (int i=0; i < _numX*_numY; idx.append(i++));
  idx.shuffle();
  int[] arr = idx.array();
  
  int x,y;
  k=0;
  for (int i=0; i < _race.length; i++){
    for (int j=0; j < _numAgent; j++){
      int tmp = arr[k];
      x = nums[tmp][0];
      y = nums[tmp][1];
      Agent newAgent = new Agent(_cellArray[x][y], i);
      _agentArray[k] = newAgent;
      _cellArray[x][y].agent = newAgent;
      //println(i, j, arr[k], newAgent.race, newAgent.pos);
      k++;
    }
  }

 /*
  for (int i = 0; i < _numAgent*_race.length; i++){
      println(_agentArray[i].pos.x, _agentArray[i].pos.y, _agentArray[i].race);
  }
 */
}

void draw(){
  background(_bgColor);
  //background(200);
  
  for (int x = 0; x < _numX; x++){
    for (int y = 0; y < _numY; y++){
    _cellArray[x][y].calcNextState();
    }
  }
  
  translate(_cellSize/2, _cellSize/2);
  
  for (int x = 0; x < _numX; x++){
    for (int y = 0; y < _numY; y++){
    _cellArray[x][y].drawMe();
    }
  }
  for (int i = 0; i < _numAgent*_race.length; i++){
    _agentArray[i].drawMe();
  }
}

void mousePressed(){
  restart();
}

//=================================== object

class Cell {
  float x, y;
  boolean state;
  boolean nextState;
  Cell[] neighbours;
  Agent agent;
  
  Cell(float ex, float why){
    x = ex * _cellSize;
    y = why * _cellSize;
    if (random(2)>1){
      nextState = true;
    } else {
      nextState = false;
    }
    state = nextState;
    neighbours = new Cell[0];
  }
  
  void addNeighbour(Cell cell){
    neighbours = (Cell[])append(neighbours, cell);
  }
  
  void calcNextState(){
    int liveCount = 0;
    if (state) { liveCount++; }
    for (int i=0; i < neighbours.length; i++){
      if (neighbours[i].state == true){
        liveCount++;
      }
    }    
    
    if (liveCount <= 4){
      nextState = false;
    } else {
      nextState = true;
    }
    
    /*
    if (liveCount == 4) || (liveCount == 5){
      nextState = !nextState;
    }
        
    for (int i=0; i < neighbours.length; i++){
      if (neighbours[i].state == true){
        liveCount++;
      }
    }
    
    if (state == true){
      if ((liveCount == 2) || (liveCount == 3)){
        nextState = true;
      } else {
        nextState = false;
        }
    } else {
      if (liveCount == 3){
        nextState = true;
      } else {
        nextState = false;
      }
    }
    */
  }
  
  void drawMe(){
    state = nextState;
    stroke(0);
    fill(_bgColor);
    /*
    fill(175);
    if (state == true){
      fill(0);
    } else {
      fill(255);
    }
    */
    ellipse(x, y, _cellSize, _cellSize);
  }
}

class Agent {
  Cell pos;
  float rate;
  String race;
  
  Agent(Cell cell, int i){
    pos = cell;
    race = _race[i];
//    println(race);
  }
  
  void drawMe(){
    stroke(0);
    if (race == "penny"){
      fill(0);
    } else if (race == "dime"){
      fill(255);
    }
    ellipse(pos.x, pos.y, _cellSize, _cellSize);
    //println(race, pos.x, pos.y);
  }
}