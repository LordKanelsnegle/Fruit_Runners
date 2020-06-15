PImage background; //for storing the background tile
String[] backgrounds = new String[]{ "Blue.png", "Brown.png", "Gray.png", "Green.png", "Pink.png", "Purple.png", "Yellow.png" }; //array containing all of the backgroud tile filenames
Boolean triggerNewLevel = true; //flag for signalling when to change the background
int currentLevel = 0; //integer to keep track of which level to display when the triggerNewLevel flag is set to true

void setup() {
    frameRate(20); //set framerate to 20 (because the assets being used are designed for 20 fps)
    size(500, 300); //set window size
}

void keyReleased() { //using keyReleased instead of keyPressed to prevent resetting multiple times if R is held down
   if (Character.toLowerCase(key) == 'r') { //if reset button (R) is pressed
      triggerNewLevel = true; //then set the flag for a new level to true
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
}
