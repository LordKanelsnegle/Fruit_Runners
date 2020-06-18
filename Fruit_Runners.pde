PImage background; //for storing the background tile
String[] backgrounds = new String[]{ "Blue.png", "Brown.png", "Gray.png", "Green.png", "Pink.png", "Purple.png", "Yellow.png" }; //array containing all of the backgroud tile filenames
Boolean triggerNewLevel = true; //flag for signalling when to change the background
int currentLevel = 0; //integer to keep track of which level to display when the triggerNewLevel flag is set to true
ArrayList<Object> objects; //list of objects to keep track of which things need to be redrawn
Player player; //global instance of the player for use where needed
Boolean playSound = true;
PImage indicator;

void setup() {
    size(500, 300); //set window size
    player = new Player(); //initialize the player variable
    indicator = loadImage("Assets\\Menu\\Strawberry.png");
}

void keyPressed() {
    if (currentLevel == 0) {
        return;
    }
    switch (keyCode) {
        case LEFT:
            player.movingLeft = true;
            player.flipped = true;
            break;
        case UP:
            player.jump();
            break;
        case RIGHT:
            player.movingRight = true;
            player.flipped = false;
            break;
    }
    if (player.movingRight && player.movingLeft && player.animationState != Animation.IDLE) {
        player.changeAnimation(Animation.IDLE); //reset the player to the idle animation, if both left and right are pressed
    }
}

int option = 0;
void keyReleased() {
    if (currentLevel == 0) {
        switch (keyCode) {
            case UP:
                option--;
                if (option < 0) {
                    option = 2;
                }
                break;
            case DOWN:
                option++;
                if (option > 2) {
                    option = 0;
                }
                break;
            case ENTER:
                if (option == 0) {
                    currentLevel++;
                    player.die();
                } else if (option == 1) {
                    playSound = !playSound;
                } else {
                    exit();
                }
                break;
        }
    } else {
        //using keyReleased instead of keyPressed to prevent resetting multiple times if R is held down    
        switch (keyCode) {
            case LEFT:
                player.movingLeft = false;
                if (player.movingRight) {
                    player.flipped = false;
                }
                if (player.animationState != Animation.FALL) {
                    player.changeAnimation(Animation.IDLE); //reset the player to the idle animation, unless theyre falling
                }
                break;
            case RIGHT:
                player.movingRight = false;
                if (player.movingLeft) {
                    player.flipped = true;
                }
                if (player.animationState != Animation.FALL) {
                    player.changeAnimation(Animation.IDLE); //reset the player to the idle animation, unless theyre falling
                }
                break;
            case +'R': //if reset button (R) is pressed
                player.die(); //kill the character off
                break;
        }
    }
}

//the background is made up of a repeating tile, so these variables keep track of how many
//  tiles need to be placed and at what offset (to create the slowly moving background effect)
int rows;
int columns;
float offset;
//this variable records the last used background so that no background is ever repeated
int lastBackground;
void draw() {
    if (player.died) {
        triggerNewLevel = true;
    }
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
        loadLevel();
    }
    player.move();
    
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
    if (offset >= background.height) {
        offset = 0;
    } else {
        offset += 0.32;
    }
    
    //lastly, redraw all of the level objects so that they appear in front of the background,
    //  and check their collisions as well
    for (Object obj : objects) {
        obj.checkCollisions();
        obj.redraw();
    }
    //check player collisions and draw the player separately to the rest of the objects
    player.checkCollisions();
    player.redraw();
    
    if (currentLevel == 0) {
        displayText("FRUIT RUNNERS", "Title", 42, width/2, height * 0.05);
        displayText("PLAY", "Options", 25, width/2, height * 0.25);
        if (playSound) {
            displayText("SOUND OFF", "Options", 25, width/2, height * 0.36);
        } else {
            displayText("SOUND ON", "Options", 25, width/2, height * 0.36);
        }
        displayText("QUIT", "Options", 25, width/2, height * 0.47);
        switch (option) {
            case 0:
                image(indicator, width * 0.35, height * 0.25);
                break;
            case 1:
                if (playSound) {
                    image(indicator, width * 0.24, height * 0.36);
                } else {
                    image(indicator, width * 0.26, height * 0.36);
                }
                break;
            default:
                image(indicator, width * 0.35, height * 0.47);
                break;
        }
    }
}

private void displayText(String text, String fontFile, int size, float x, float y) {
    PFont font = createFont("Assets\\Menu\\Text\\" + fontFile + ".ttf", size);
    textFont(font);
    textAlign(CENTER, TOP);
    fill(0);
    for(int i = -1; i < 2; i++){ //create an outline effect by putting two black coloured text behind the main one with varied offsets
        text(text, x + i, y);
        text(text, x, y + i);
    }
    fill(255);
    text(text, x, y);
}



private void loadLevel() {
    switch(currentLevel) {
        case 0:
            objects = new ArrayList<Object>() {{
                add(new Terrain(TerrainType.GRASS, 0, height - 48, width, 48));
            }};
            player.spawn(10, height - (48 + player.Height));
            player.movingRight = true;
            break;
        case 1:
            objects = new ArrayList<Object>() {{
                add(new Terrain(TerrainType.GRASS, 52, 163, 48, 48));
                add(new Terrain(TerrainType.GRASS, 100, 132, 240, 48));
                add(new Terrain(TerrainType.GRASS, 340, 250, 48, 48));
            }};
            player.spawn(300,100);
            break;
    }
}
