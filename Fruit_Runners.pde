PImage background; //for storing the background tile
String[] backgrounds = new String[]{ "Blue.png", "Brown.png", "Gray.png", "Green.png", "Pink.png", "Purple.png", "Yellow.png" }; //array containing all of the backgroud tile filenames
Boolean triggerNewLevel = true; //flag for signalling when to change the background
int currentLevel = 0; //integer to keep track of which level to display when the triggerNewLevel flag is set to true
ArrayList<Object> objects = new ArrayList<Object>(); //list of objects to keep track of which things need to be redrawn
Player player; //global instance of the player for use where needed

void setup() {
    frameRate(20); //set framerate to 20 (because the assets being used are designed for 20 fps)
    size(500, 300); //set window size
    player = new Player(); //initialize the player variable
    objects.add(player); //add the player to the list of objects
}

void keyReleased() { //using keyReleased instead of keyPressed to prevent resetting multiple times if R is held down
   if (Character.toLowerCase(key) == 'r') { //if reset button (R) is pressed
      triggerNewLevel = true; //then set the flag for a new level to true
   }
}

//the background is made up of a repeating tile, so these variables keep track of how many
//  tiles need to be placed and at what offset (to create the slowly moving background effect)
int rows;
int columns;
int offset;
//this variable records the last used background so that no background is ever repeated
int lastBackground;
void draw() {
    if (triggerNewLevel) { //if a new level needs to be displayed
        triggerNewLevel = false; //reset the flag
        int index;
        do {
            index = int(random(backgrounds.length));
        } while (index == lastBackground); //pick a random background which isn't the same as the current one
        lastBackground = index; //update the value of the last used background
        background = loadImage("Assets\\Background\\" + backgrounds[index]); //set the background image to the new one
        columns = width / background.width; //calculate the number of columns needed
        rows = height / background.height; //calculate the number of rows needed
        if (width % background.width > 0) { //if there is a bit of width remaining (not an exact fit)
            columns++; //then increase the columns by 1
        }
        if (height % background.height > 0) { //if there is a bit of height remaining (not an exact fit)
            rows++; //then increase the rows by 1
        }
        offset = 0; //set the offset to 0 so that the tiles start at the top
        player.spawn(0,0); //spawn the player in at 0,0 (will change depending on what level it is later on)
    }
    //these nested for loops display the grid of background tiles
    for (int x = 0; x < columns; x++) {
        for (int y = 0; y < rows; y++) {
            image(background, x * background.width, y * background.height + offset);
        }
        //this part ensures that the gap at the top created by offsetting the y axis is filled
        image(background, x * background.width, offset - background.height);
    }
    //this simple if statement ensures that the offset is increased every loop until it has reached
    //  the size of one full tile height, then resets it to 0 so that the next iteration of draw()
    //  displays the tiles starting from the top again (with no offset)
    if (offset == background.height) {
        offset = 0;
    } else {
        offset++;
    }
    
    //lastly, redraw all of the level objects so that they appear in front of the background
    for (Object obj : objects) {
        obj.redraw();
    }
}
