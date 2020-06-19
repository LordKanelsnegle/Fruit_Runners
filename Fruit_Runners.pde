import ddf.minim.*; //import Minim audio library

PImage background; //for storing the background tile
PImage[] backgrounds; //array containing all of the backgroud tile filenames
Boolean triggerNewLevel = true; //flag for signalling when to change the level
int currentLevel = 0; //integer to keep track of which level to display when the triggerNewLevel flag is set to true
Object[] objects; //array of objects to keep track of which things need to be redrawn
Entity[] entities; //array of entities to keep track of which entities need to move and be redrawn

Player player; //global instance of the player for use where needed
PImage indicator; //image of an indicator for use on the main menu
Minim minim; //for audio functionality
AudioPlayer ambient; //menu and game theme music player
AudioPlayer[] soundEffects; //array of sound effect audio players

PFont titleFont; //font for the menu title
PFont optionsFont; //font for the menu options

void setup() {
    frameRate(30); //initially set fps to 30 so menu background plays in "slow motion"
    background(33,31,48); //set a backgroud color for when the game is loading up
    size(500, 300); //set window size
    player = new Player(); //initialize the player variable
    indicator = loadImage("Assets\\Menu\\Strawberry.png"); //load the indicator
    minim = new Minim(this); //pass 'this' to Minim so it can load files
    ambient = minim.loadFile("Assets\\Sound\\Menu Theme.mp3"); //load menu theme mp3 into ambient
    ambient.setGain(-10); //set gain to -10db (reduce volume)
    soundEffects = new AudioPlayer[]{ //load all of the sound effect files into the sound effects array
        minim.loadFile("Assets\\Sound\\Menu Select.wav"),
        minim.loadFile("Assets\\Sound\\Menu Confirm.wav"),
        minim.loadFile("Assets\\Sound\\Run.mp3"),
        minim.loadFile("Assets\\Sound\\Jump.wav"),
        minim.loadFile("Assets\\Sound\\Land.wav"),
        minim.loadFile("Assets\\Sound\\Hurt.wav")
    };
    backgrounds = new PImage[]{ //load all of the background image files into the backgrounds array
        loadImage("Assets\\Background\\Blue.png"),
        loadImage("Assets\\Background\\Brown.png"),
        loadImage("Assets\\Background\\Gray.png"),
        loadImage("Assets\\Background\\Green.png"),
        loadImage("Assets\\Background\\Pink.png"),
        loadImage("Assets\\Background\\Purple.png"),
        loadImage("Assets\\Background\\Yellow.png")
    };
    titleFont = createFont("Assets\\Menu\\Text\\Title.ttf", 42); //load the font for the menu title
    optionsFont = createFont("Assets\\Menu\\Text\\Options.ttf", 25); //load the font for the menu options
    ambient.loop(); //play/loop the menu music once all assets have loaded
}

void keyPressed() {
    //ignore key presses if this is the main menu
    if (currentLevel == 0) {
        return;
    }
    //otherwise, check the keycode and get the player ready to move accordingly
    switch (keyCode) {
        case LEFT:
            player.movingLeft = true;
            player.flipped = true;
            break;
        case RIGHT:
            player.movingRight = true;
            player.flipped = false;
            break;
        case UP:
            player.jump();
            break;
    }
    //if both left and right are pressed, reset the player to the idle animation since they won't be able to move
    if (player.movingRight && player.movingLeft && player.animationState != Animation.IDLE) {
        player.changeAnimation(Animation.IDLE); 
    }
}

int option = 0;
void keyReleased() {
    if (currentLevel == 0) { //if on the menu, check to see if the option selected should be updated or has been chosen
        switch (keyCode) {
            case UP: //if the up key was pressed, decrement the option
                option--;
                if (option < 0) { //if the option is negative, wrap it back around to the lowest option
                    option = 2;
                }
                playSound(Sound.SELECT, false); //play the option select sound effect
                break;
            case DOWN: //if the down key was pressed, increment the option
                option++;
                if (option > 2) { //if the option is too large, wrap it back around to the highest option
                    option = 0;
                }
                playSound(Sound.SELECT, false); //play the option select sound effect
                break;
            case ENTER: //if the player presses the confirm key (enter), play the confirm sound effect
                playSound(Sound.CONFIRM, false);
                if (option == 0) { //if the play option is selected
                    currentLevel++;
                    if (ambient.isPlaying()) { //if the music is playing (ie hasnt been disabled)
                        ambient.pause(); //stop playing the menu theme
                        ambient = minim.loadFile("Assets\\Sound\\Game Theme.mp3"); //technically should avoid loading files outside of setup() but shouldnt be a big deal
                        ambient.setGain(-10); //set gain to -10db again since loading a new track resets the gain
                        ambient.loop(); //loop the game music
                    }
                    frameRate(60); //set the framerate back up to 60
                    player.die(); //kill the player to load the next level
                } else if (option == 1) { //if the music toggle has been selected
                    if (ambient.isPlaying()) {
                        ambient.pause(); //pause the music if its playing
                    } else {
                        ambient.loop(); //otherwise play/loop it
                    }
                } else { //if the quit option was selected, quit the game
                    exit();
                }
                break;
        }
    } else { //otherwise, check if the player movement flags need to be updated
        switch (keyCode) {
            case LEFT:
                player.movingLeft = false; //update the player's movingLeft flag
                //if the player is still holding down the right key, dont flip the sprites so the player faces right
                if (player.movingRight) {
                    player.flipped = false;
                }
                //if the player is NOT falling, set them back to the idle animation once they release the left key
                if (player.animationState != Animation.FALL) {
                    player.changeAnimation(Animation.IDLE);
                }
                break;
            case RIGHT:
                player.movingRight = false; //update the player's movingRight flag
                //if the player is still holding down the left key, flip the sprites so the player faces left
                if (player.movingLeft) {
                    player.flipped = true;
                }
                //if the player is NOT falling, set them back to the idle animation once they release the right key
                if (player.animationState != Animation.FALL) {
                    player.changeAnimation(Animation.IDLE);
                }
                break;
            case +'R': //if reset button (R) is pressed and released (to prevent accidentally resetting everytime if R is pressed too long)
                player.die(); //kill the character off, which will cause the level to reset
                break;
        }
    }
}

//the background is made up of a repeating tile, so these variables keep track of how many
//  tiles need to be placed and at what offset (to create the slowly moving background effect)
int rows;
int columns;
float offset;
//this variable records the last used background so that no background is ever repeated twice in a row
int lastBackground;
void draw() {
    //if the player is dead, trigger a new level
    if (player.died) {
        triggerNewLevel = true;
    }
    if (triggerNewLevel) { //if a new level needs to be displayed
        triggerNewLevel = false; //reset the flag
        //pick a random background which isn't the same as the current one
        int index;
        do {
            index = int(random(backgrounds.length));
        } while (index == lastBackground);
        //update the value of the last used background
        lastBackground = index;
        background = backgrounds[index]; //set the background image to the new one
        columns = width / background.width; //calculate the number of columns needed
        rows = height / background.height; //calculate the number of rows needed
        if (width % background.width > 0) { //if there is a bit of width remaining (not an exact fit)
            columns++; //then increase the columns by 1
        }
        if (height % background.height > 0) { //if there is a bit of height remaining (not an exact fit)
            rows++; //then increase the rows by 1
        }
        offset = 0; //set the offset to 0 so that the tiles start at the top
        loadLevel(); //load the level (corresponding to currentLevel)
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
    if (offset >= background.height) {
        offset = 0;
    } else {
        offset += 0.32;
    }
    
    //redraw all of the level objects so that they appear in front of the background
    for (Object obj : objects) {
        obj.redraw();
    }
    //move all of the entities however much they should be moved,
    //  then redraw all of the level entities so that they appear in front of the background
    for (Entity ent : entities) {
        ent.move();
        ent.redraw();
    }
    
    //lastly, move the player, check player collisions and draw the player separately to the rest of the entities
    player.move();
    player.checkCollisions();
    player.redraw();
    
    //if this is the menu, additionally display menu text
    if (currentLevel == 0) {
        displayText("FRUIT RUNNERS", true, width/2, height * 0.05);
        displayText("PLAY", false, width/2, height * 0.25);
        //display different music option text depending on whether the music is playing or not
        if (ambient.isPlaying()) {
            displayText("MUSIC OFF", false, width/2, height * 0.36);
        } else {
            displayText("MUSIC ON", false, width/2, height * 0.36);
        }
        displayText("QUIT", false, width/2, height * 0.47);
        switch (option) {  //check the currently selected option and display the indicator beside it
            case 0:
                image(indicator, width * 0.35, height * 0.25);
                break;
            case 1:
                if (ambient.isPlaying()) {
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

//this function is used for displaying the text on the menu (with an outline)
private void displayText(String text, Boolean isTitle, float x, float y) {
    textFont(optionsFont); //set the font to the options font by default
    if (isTitle) { //if the text being displayed is for the title, set the font to the title font instead
        textFont(titleFont);
    }
    textAlign(CENTER, TOP); //set the text align to be centered and anchored from the top
    fill(0); //set the color to black
    //create an outline effect by putting two black texts behind the white one with varied offsets
    for(int i = -1; i < 2; i++){
        text(text, x + i, y);
        text(text, x, y + i);
    }
    //set the color back to white and display the main text
    fill(255);
    text(text, x, y);
}

//this function (and variable) set up the scene programmatically depending on the level that needs to be loaded
int lastLevelLoaded = -1; //keep track of the last level loaded so we dont load resources (by creating a class instance) if the level hasn't changed
private void loadLevel() {
    switch(currentLevel) { //check the current level
        case 0: //MENU LEVEL
            //if the level HAS changed, initialise all of the objects for this level
            if (lastLevelLoaded != currentLevel) {
                objects = new Object[]{
                    new Terrain(TerrainType.GRASS, -player.Width, height - 48, 13, 1)
                };
                entities = new Entity[0];
            }
            //spawn the character just offscreen
            player.spawn(-player.Width, height - (48 + player.Height));
            player.movingRight = true; //set the player to be permanently moving to the right
            break;
        case 1: //FIRST LEVEL
            //if the level HAS changed, load all of the objects for this level
            if (lastLevelLoaded != currentLevel) {
                objects = new Object[]{
                    new Terrain(TerrainType.GRASS, 52, 163, 1, 2),
                    new Terrain(TerrainType.CARAMEL, 100, 100, 6, 3),
                    new Terrain(TerrainType.BRICK, 300, 260, 4, 1),
                    new Terrain(TerrainType.COTTONCANDY, 455, 60, 1, 8)
                };
                entities = new Entity[]{
                    new Mushroom(250, 50, 50,50)
                };
            }
            //spawn the entities
            for (Entity entity : entities) {
                entity.spawn();
            }
            //spawn the player
            player.spawn(300,50);
            break;
    }
    lastLevelLoaded = currentLevel; //update the value of the last level loaded to be the current level
}

//the following 2 functions and enumerator are used for playing and stopping sound effects
public void playSound(Sound sound, Boolean loop) {
    int effect = 0;
    switch (sound) {
        case SELECT:
            effect = 0;
            break;
        case CONFIRM:
            effect = 1;
            break;
        case RUN:
            effect = 2;
            break;
        case JUMP:
            effect = 3;
            break;
        case LAND:
            effect = 4;
            break;
        case HURT:
            effect = 5;
            break;
    }
    soundEffects[effect].setGain(-10); //set the gain to -10db before playing it
    if (loop) { //if the sound needs to be looped (e.g. running sound effect)
        if (!soundEffects[effect].isPlaying()) { //and it wasnt already running
            soundEffects[effect].loop(); //then play/loop it
        }
    } else { //otherwise, reset/rewind the audio then play it again
        soundEffects[effect].rewind();
        soundEffects[effect].play();
    }
}
public void stopSound(Sound sound) {
    int effect = 0;
    switch (sound) {
        case SELECT:
            effect = 0;
            break;
        case CONFIRM:
            effect = 1;
            break;
        case RUN:
            effect = 2;
            break;
        case JUMP:
            effect = 3;
            break;
        case LAND:
            effect = 4;
            break;
        case HURT:
            effect = 5;
            break;
    }
    //if the effect chosen is playing, pause it
    if (soundEffects[effect].isPlaying()) {
        soundEffects[effect].pause();
    }
}
public enum Sound {
    SELECT,
    CONFIRM,
    RUN,
    JUMP,
    LAND,
    HURT
}
