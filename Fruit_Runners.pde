PImage background; //for storing the background tile
String[] backgrounds = new String[]{ "Blue.png", "Brown.png", "Gray.png", "Green.png", "Pink.png", "Purple.png", "Yellow.png" }; //array containing all of the backgroud tile filenames
Boolean triggerNewLevel = true; //flag for signalling when to change the background
int currentLevel = 0; //integer to keep track of which level to display when the triggerNewLevel flag is set to true
float px, py; // position x and y for character
float sx, sy; // speed x and y for character

void setup() {
    frameRate(20); //set framerate to 20 (because the assets being used are designed for 20 fps)
    size(500, 300); //set window size
    
    px = width / 2; //Initial position of the player
    py = height / 2;
    sx = 0; //Initial Speed of the player, movment is in keypressed
    sy = 0;
}
void keyPressed() { // TODO : set and if statement to not exceed a specific height, gravity, 
  if (key == 'w') {//Up
    sy -= 0.5; 
  } else if (key == 's') {//Down, remove later and set as gravity
    sy += 0.5;
  } else if (key == 'd') {//Right
    sx += 0.5;
  } else if (key == 'a') {//Left
    sx -= 0.5; 
  }
}
void keyReleased() { //using keyReleased instead of keyPressed to prevent resetting multiple times if R is held down
   if (Character.toLowerCase(key) == 'r') { //if reset button (R) is pressed
      triggerNewLevel = true; //then set the flag for a new level to true
   }
    if (key == 'w') {//Up
    sy = 0; 
  } else if (key == 's') {//Down, remove later and set as gravity
    sy = 0;
  } else if (key == 'd') {//Right
    sx = 0;
  } else if (key == 'a') {//Left
    sx = 0;
  }
}

//the background is made up of a repeating tile, so these variables keep track of how many
//tiles need to be placed and at what offset (to create the slowly moving background effect)
int rows;
int columns;
int offset;
//this variable records the last used background so that no background is ever repeated
int lastBackground;
void draw() {
    if (triggerNewLevel) {
        triggerNewLevel = false;
        int index;
        do {
          index = int(random(backgrounds.length));
        } while (index == lastBackground);
        lastBackground = index;
        background = loadImage("Assets\\Background\\" + backgrounds[index]);
        columns = width/background.width;
        rows = height/background.height;
        if (width % background.width > 0) {
            columns++;
        }
        if (height % background.height > 0) {
            rows++;
        }
        offset = 0;
    }
    
    for (int x = 0; x < columns; x++) {
        for (int y = 0; y < rows; y++) {
            image(background, x * background.width, y * background.height + offset);
        }
        image(background, x * background.width, offset - background.height);
    }
    
    if (offset == background.height) {
       offset = 0;
    } else {
        offset++;
    }
    
  px += sx;  //newPosition = Position + speed
  py += sy;
  
   //Teleport the player if they move off the edges of the screen TEMPORARY!
  if (py < 0) py = height;
  else if (py > height) py = 0;
  if (px < -32) px = width;
  else if (px > width ) px = 0;
  
  fill(146, 211, 202);
  rect(px, py, 32, 32);
}


    

 
