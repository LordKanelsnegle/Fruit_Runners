import ddf.minim.*; //import Minim audio library

PImage background; //for storing the background tile
PImage[] backgrounds; //array containing all of the backgroud tile files
PImage[] players; //array containing all of the player files
PImage[] mushrooms; //array containing all of the mushroom files
PImage[] fruits; //array containing all of the fruit files
PImage terrain; //terrain spritesheet
boolean triggerNewLevel = true; //flag for signalling when to change the level
int currentLevel = 0; //integer to keep track of which level to display when the triggerNewLevel flag is set to true
Object[] objects; //array of objects to keep track of which things need to be redrawn
ArrayList<Entity> entities; //list of entities to keep track of which entities need to move and be redrawn

Player player; //global instance of the player for use where needed
Minim minim; //for audio functionality
AudioPlayer ambient; //menu and game theme music player
AudioPlayer[] soundEffects; //array of sound effect audio players
File settingsFile;
String[] settings;
boolean muteMusic, muteSFX, showFPS;

PFont titleFont; //font for the menu title
PFont bigFont; //font for the menu options
PFont mediumFont; //font for timer
PFont smallFont; //font for the tips and fps counter
PImage indicatorSprite; //image of an indicator for use on the main menu
Indicator indicator;
int option;
int optionMax;

int gameStart;
ArrayList<Integer> times;
final int baseWidth = 500;
final int baseHeight = 300;

void settings() {
    PJOGL.setIcon("Assets\\Players\\Mask Dude\\Jump.png");
    size(baseWidth, baseHeight, P2D); //set window size and set graphics renderer to P2D
}

void setup() {
    surface.setTitle("Fruit Runners");
    surface.setResizable(false);
    background(33,31,48); //set a backgroud color for when the game is loading up
    noCursor();
    noStroke();
    settings = new String[] { "Mute Music:", "false", "", "Mute Sound Effects:", "false", "", "Show FPS:", "false" };
    settingsFile = new File(sketchPath("settings.txt"));
    if (settingsFile.exists()) {
        settings = loadStrings("settings.txt");
    } else {
        saveStrings(settingsFile, settings);
    }
    muteMusic = boolean(settings[1]);
    muteSFX = boolean(settings[4]);
    showFPS = boolean(settings[7]);
    times = new ArrayList<Integer>();
    minim = new Minim(this); //pass 'this' to Minim so it can load files
    ambient = minim.loadFile("Assets\\Sound\\Menu Theme.mp3"); //load menu theme mp3 into ambient
    ambient.setGain(-10); //set gain to -10db (reduce volume)
    soundEffects = new AudioPlayer[]{ //load all of the sound effect files into the sound effects array
        minim.loadFile("Assets\\Sound\\Menu Select.wav"),
        minim.loadFile("Assets\\Sound\\Menu Confirm.wav"),
        minim.loadFile("Assets\\Sound\\Run.mp3"),
        minim.loadFile("Assets\\Sound\\Jump.wav"),
        minim.loadFile("Assets\\Sound\\Land.wav"),
        minim.loadFile("Assets\\Sound\\Hurt.wav"),
        minim.loadFile("Assets\\Sound\\Collect.wav"),
        minim.loadFile("Assets\\Sound\\Kill.wav"),
        minim.loadFile("Assets\\Sound\\Success.mp3")
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
    players = new PImage[]{
        loadImage("Assets\\Players\\Mask Dude\\Idle.png"),
        loadImage("Assets\\Players\\Mask Dude\\Double Jump.png"),
        loadImage("Assets\\Players\\Mask Dude\\Fall.png"),
        loadImage("Assets\\Players\\Mask Dude\\Hit.png"),
        loadImage("Assets\\Players\\Mask Dude\\Jump.png"),
        loadImage("Assets\\Players\\Mask Dude\\Run.png"),
        loadImage("Assets\\Players\\Mask Dude\\Wall Jump.png"),
        loadImage("Assets\\Players\\Ninja Frog\\Idle.png"),
        loadImage("Assets\\Players\\Ninja Frog\\Double Jump.png"),
        loadImage("Assets\\Players\\Ninja Frog\\Fall.png"),
        loadImage("Assets\\Players\\Ninja Frog\\Hit.png"),
        loadImage("Assets\\Players\\Ninja Frog\\Jump.png"),
        loadImage("Assets\\Players\\Ninja Frog\\Run.png"),
        loadImage("Assets\\Players\\Ninja Frog\\Wall Jump.png"),
        loadImage("Assets\\Players\\Pink Man\\Idle.png"),
        loadImage("Assets\\Players\\Pink Man\\Double Jump.png"),
        loadImage("Assets\\Players\\Pink Man\\Fall.png"),
        loadImage("Assets\\Players\\Pink Man\\Hit.png"),
        loadImage("Assets\\Players\\Pink Man\\Jump.png"),
        loadImage("Assets\\Players\\Pink Man\\Run.png"),
        loadImage("Assets\\Players\\Pink Man\\Wall Jump.png"),
        loadImage("Assets\\Players\\Virtual Guy\\Idle.png"),
        loadImage("Assets\\Players\\Virtual Guy\\Double Jump.png"),
        loadImage("Assets\\Players\\Virtual Guy\\Fall.png"),
        loadImage("Assets\\Players\\Virtual Guy\\Hit.png"),
        loadImage("Assets\\Players\\Virtual Guy\\Jump.png"),
        loadImage("Assets\\Players\\Virtual Guy\\Run.png"),
        loadImage("Assets\\Players\\Virtual Guy\\Wall Jump.png"),
        loadImage("Assets\\Players\\Appearing.png"),
        loadImage("Assets\\Players\\Disappearing.png")
    };
    mushrooms = new PImage[]{ //load all of the sprite sheets
        loadImage("Assets\\Enemies\\Mushroom\\Idle.png"),
        loadImage("Assets\\Enemies\\Mushroom\\Run.png"),
        loadImage("Assets\\Enemies\\Mushroom\\Hit.png")
    };
    fruits = new PImage[]{
        loadImage("Assets\\Items\\Fruits\\Apple.png"),
        loadImage("Assets\\Items\\Fruits\\Bananas.png"),
        loadImage("Assets\\Items\\Fruits\\Cherries.png"),
        loadImage("Assets\\Items\\Fruits\\Kiwi.png"),
        loadImage("Assets\\Items\\Fruits\\Melon.png"),
        loadImage("Assets\\Items\\Fruits\\Orange.png"),
        loadImage("Assets\\Items\\Fruits\\Pineapple.png"),
        loadImage("Assets\\Items\\Fruits\\Strawberry.png")
    };
    collectedSprite = loadImage("Assets\\Items\\Fruits\\Collected.png");
    terrain = loadImage("Assets\\Terrain\\Terrain.png");
    titleFont = createFont("Assets\\Menu\\Text\\Title.ttf", 42); //load the font for the menu title
    bigFont = createFont("Assets\\Menu\\Text\\Options.ttf", 25); //load the font for the menu options
    mediumFont = createFont("Assets\\Menu\\Text\\Options.ttf", 15); //load the font for the small text
    smallFont = createFont("Assets\\Menu\\Text\\Options.ttf", 10); //load the font for the small text
    indicatorSprite = loadImage("Assets\\Menu\\Strawberry.png");
    indicator = new Indicator();
    indicator.move(baseWidth * 0.35, baseHeight * 0.25);
    option = 0;
    optionMax = 3;
    player = new Player(); //initialize the player variable
    if (!muteMusic) {
        ambient.loop(); //play/loop the menu music once all assets have loaded
    }
}

void keyPressed() {
    //ignore key presses if this is the main menu
    if (currentLevel <= 0 || player.spawning) {
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

void keyReleased() {
    if (currentLevel <= 0) { //if on the menu, check to see if the option selected should be updated or has been chosen
        boolean confirmed = false;
        switch (keyCode) {
            case UP: //if the up key was pressed, decrement the option
                option--;
                if (option < 0) { //if the option is negative, wrap it back around to the lowest option
                    option = optionMax;
                }
                playSound(Sound.SELECT, false); //play the option select sound effect
                break;
            case DOWN: //if the down key was pressed, increment the option
                option++;
                if (option > optionMax) { //if the option is too large, wrap it back around to the highest option
                    option = 0;
                }
                playSound(Sound.SELECT, false); //play the option select sound effect
                break;
            case ENTER: //if the player presses the confirm key (enter), play the confirm sound effect
                playSound(Sound.CONFIRM, false);
                confirmed = true;
                break;
        }
        switch (option) {
            case 0:
                if (currentLevel == 0) {
                    indicator.move(baseWidth * 0.35, baseHeight * 0.25);
                    if (confirmed) {
                        currentLevel++;
                        if (!muteMusic) { //if the music is playing (ie hasnt been disabled)
                            ambient.pause(); //stop playing the menu theme
                            ambient = minim.loadFile("Assets\\Sound\\Game Theme.mp3"); //technically should avoid loading files outside of setup() but shouldnt be a big deal
                            ambient.setGain(-10); //set gain to -10db again since loading a new track resets the gain
                            ambient.loop(); //loop the game music
                        }
                        times.clear();
                        gameStart = millis();
                        player.die(); //kill the player to load the next level
                    }
                } else if (currentLevel == -1) {
                    indicator.move(baseWidth * 0.245, baseHeight * 0.25);
                    if (confirmed) {
                        if (muteMusic) {
                            muteMusic = false;
                            ambient.loop();
                        } else {
                            muteMusic = true;
                            ambient.pause();
                        }
                    }
                }
                break;
            case 1:
                if (currentLevel == 0) {
                    indicator.move(baseWidth * 0.285, baseHeight * 0.36);
                    if (confirmed) {
                        currentLevel = -1;
                        option = 0;
                        indicator.move(baseWidth * 0.245, baseHeight * 0.25);
                    }
                } else if (currentLevel == -1) {
                    indicator.move(baseWidth * 0.2, baseHeight * 0.36);
                    if (confirmed) {
                        muteSFX = !muteSFX;
                    }
                }
                break;
            case 2:
                if (currentLevel == 0) {
                    indicator.move(baseWidth * 0.305, baseHeight * 0.47);
                    if (confirmed) {
                        currentLevel = -2;
                        option = 0;
                        optionMax = 1;
                        indicator.move(baseWidth * 0.245, baseHeight * 0.25);
                    }
                } else if (currentLevel == -1) {
                    indicator.move(baseWidth * 0.26, baseHeight * 0.47);
                    if (confirmed) {
                        showFPS = !showFPS;
                    }
                }
                break;
            default:
                if (currentLevel == 0) {
                    indicator.move(baseWidth * 0.35, baseHeight * 0.58);
                    if (confirmed) {
                        exit();
                    }
                } else if (currentLevel == -1) {
                    indicator.move(baseWidth * 0.35, baseHeight * 0.58);
                    if (confirmed) {
                        settings[1] = "" + muteMusic;
                        settings[4] = "" + muteSFX;
                        settings[7] = "" + showFPS;
                        saveStrings(settingsFile, settings);
                        currentLevel = 0;
                        option = 0;
                        indicator.move(baseWidth * 0.35, baseHeight * 0.25);
                    }
                }
                break;
        }
    } else { //otherwise, check if the player movement flags need to be updated
        if (player.spawning) {
            return;
        }
        switch (keyCode) {
            case LEFT:
                player.movingLeft = false; //update the player's movingLeft flag
                //if the player is still holding down the right key, dont flip the sprites so the player faces right
                if (player.movingRight) {
                    player.flipped = false;
                }
                //set the player back to the idle animation once they release the left key
                player.changeAnimation(Animation.IDLE);
                break;
            case RIGHT:
                player.movingRight = false; //update the player's movingRight flag
                //if the player is still holding down the left key, flip the sprites so the player faces left
                if (player.movingLeft) {
                    player.flipped = true;
                }
                //set the player back to the idle animation once they release the right key
                player.changeAnimation(Animation.IDLE);
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
int winDelay;
void draw() {
    //scale(float(width)/baseWidth, float(height)/baseHeight);
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
        columns = baseWidth / background.width; //calculate the number of columns needed
        rows = baseHeight / background.height; //calculate the number of rows needed
        if (baseWidth % background.width > 0) { //if there is a bit of width remaining (not an exact fit)
            columns++; //then increase the columns by 1
        }
        if (baseHeight % background.height > 0) { //if there is a bit of height remaining (not an exact fit)
            rows++; //then increase the rows by 1
        }
        offset = 0; //set the offset to 0 so that the tiles start at the top
        winDelay = 0;
        loadLevel(); //load the level (corresponding to currentLevel)
    }
    
    //these nested for loops display the grid of background tiles
    int skipFrames = 1;
    if (currentLevel <= 0) {
        skipFrames = 2;
    }
    if (frameCount % skipFrames == 0) {
        if (offset >= background.height) {
            offset = 0;
        } else {
            offset += 0.32;
        }
    }
    for (int x = 0; x < columns; x++) {
        for (int y = 0; y < rows; y++) {
            image(background, x * background.width, y * background.height + offset);
        }
        //this part ensures that the gap at the top created by offsetting the y axis is filled
        image(background, x * background.width, offset - background.height);
    }

    //redraw all of the level objects so that they appear in front of the background
    for (Object obj : objects) {
        obj.redraw();
    }
    
    //move all of the entities however much they should be moved,
    //  then redraw all of the level entities so that they appear in front of the background
    boolean levelComplete = !entities.isEmpty();
    for (Entity ent : entities) {
        ent.move();
        ent.redraw();
        if (levelComplete && !ent.died) {
            levelComplete = false;
            playSound(Sound.SUCCESS, false);
        }
    }
    
    if (levelComplete) {
        if (winDelay == 90) {
            times.add(millis() - gameStart);
            currentLevel++;
            if (currentLevel == 3) {
                currentLevel = 0;
            }
            //player.changeAnimation(Animation.DISAPPEAR);
            player.die();
        } else {
            winDelay++;
        }
    }
    
    //lastly, move the player, check player collisions and draw the player separately to the rest of the entities
    if (!player.spawning) {
        player.move();
        player.checkCollisions();
    }
    player.redraw();
    
    switch (currentLevel) {
        case -2:
            fill(0, 50);
            rect(0,0, width,height);
            displayText("FRUIT RUNNERS", titleFont, baseWidth/2, baseHeight * 0.05);
            displayText("BACK", bigFont, baseWidth/2, baseHeight * 0.58);
            indicator.redraw();
            displayText("UP/DOWN TO SELECT", smallFont, baseWidth/2, baseHeight * 0.895);
            displayText("ENTER TO CONFIRM", smallFont, baseWidth/2 - 1, baseHeight * 0.895 + 12);
            if (showFPS) {
                displayText(int(frameRate) + " FPS", smallFont, 28, 2);
            }
            break;
        case -1:
            fill(0, 50);
            rect(0,0, width,height);
            displayText("FRUIT RUNNERS", titleFont, baseWidth/2, baseHeight * 0.05);
            if (muteMusic) {
                displayText("MUSIC ON", bigFont, baseWidth/2, baseHeight * 0.25);
            } else {
                displayText("MUSIC OFF", bigFont, baseWidth/2, baseHeight * 0.25);
            }
            if (muteSFX) {
                displayText("EFFECTS ON", bigFont, baseWidth/2, baseHeight * 0.36);
            } else {
                displayText("EFFECTS OFF", bigFont, baseWidth/2, baseHeight * 0.36);
            }
            if (showFPS) {
                displayText("HIDE FPS", bigFont, baseWidth/2, baseHeight * 0.47);
            } else {
                displayText("SHOW FPS", bigFont, baseWidth/2, baseHeight * 0.47);
            }
            displayText("BACK", bigFont, baseWidth/2, baseHeight * 0.58);
            indicator.redraw();
            displayText("UP/DOWN TO SELECT", smallFont, baseWidth/2, baseHeight * 0.895);
            displayText("ENTER TO CONFIRM", smallFont, baseWidth/2 - 1, baseHeight * 0.895 + 12);
            if (showFPS) {
                displayText(int(frameRate) + " FPS", smallFont, 28, 2);
            }
            break;
        case 0:
            displayText("FRUIT RUNNERS", titleFont, baseWidth/2, baseHeight * 0.05);
            displayText("PLAY", bigFont, baseWidth/2, baseHeight * 0.25);
            displayText("OPTIONS", bigFont, baseWidth/2, baseHeight * 0.36);
            displayText("HONORS", bigFont, baseWidth/2, baseHeight * 0.47);
            displayText("QUIT", bigFont, baseWidth/2, baseHeight * 0.58);
            indicator.redraw();
            displayText("UP/DOWN TO SELECT", smallFont, baseWidth/2, baseHeight * 0.895);
            displayText("ENTER TO CONFIRM", smallFont, baseWidth/2 - 1, baseHeight * 0.895 + 12);
            if (showFPS) {
                displayText(int(frameRate) + " FPS", smallFont, 28, 2);
            }
            break;
        default:
            int playTime = millis() - gameStart;
            int seconds = playTime / 1000;
            int milliseconds = (playTime % 1000)/10;
            int minutes = seconds / 60;
            if (minutes > 0) {
                seconds = seconds % minutes;
            }
            displayText(nf(minutes, 2), mediumFont, 18, 2);
            displayText(":", mediumFont, 34, 4);
            displayText(nf(seconds, 2), mediumFont, 50, 2);
            displayText(":", smallFont, 65, 5);
            displayText(nf(milliseconds, 2), smallFont, 76, 4);
            if (showFPS) {
                displayText(int(frameRate) + " FPS", smallFont, 30, 20);
            }
            break;
    }
}

//this function is used for displaying the text on the menu (with an outline)
private void displayText(String text, PFont font, float x, float y) {
    textFont(font); //set the font
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
        case 1: //FIRST LEVEL
            if (lastLevelLoaded != currentLevel) {
                objects = new Object[]{ // Terrain creation
                    //Border
                    new Terrain(TerrainType.BRICK, -46,0, 1,15),
                    new Terrain(TerrainType.BRICK, baseWidth-2,0, 1,15),
                    new Terrain(TerrainType.BRICK, 0,-46, 15,1),
                    //Level Terrain
                    new Terrain(TerrainType.COTTONCANDY, 0,255, 1, 1),
                    new Terrain(TerrainType.BRICK, 48,295, 4,1),
                    new Terrain(TerrainType.CARAMEL, 405,95, 3,7),
                    new Terrain(TerrainType.CARAMEL, 405-47,95+45, 1,6),
                    new Terrain(TerrainType.CARAMEL, 405-47*2,95+45*2, 1,5),
                    new Terrain(TerrainType.CARAMEL, 405-47*3,95+45*3, 1,4),
                    new Terrain(TerrainType.CARAMEL, 405-47*4,95+45*4, 1,3),
                };
                entities = new ArrayList<Entity>(){{ //Mushroom spawn
                    add(new Mushroom(180,263, 130,0));
                    add(new Mushroom(225,243, 0,0));
                    add(new Mushroom(270,198, 0,0));
                    add(new Mushroom(320,153, 0,0));
                    add(new Mushroom(367,108, 0,0));
                    add(new Mushroom(410,63, 0,50));
         
                }};
                //Fruit Spawn
                placeFruit(5,140, FruitSprite.ORANGE, 1,3, 20);
                placeFruit(55,240, FruitSprite.APPLE, 6,1, 25);
                placeFruit(225,220, FruitSprite.BANANAS, 1,1, 1);
                placeFruit(270,170, FruitSprite.CHERRIES, 1,1, 1);
                placeFruit(320,130, FruitSprite.KIWI, 1,1, 1);
                placeFruit(367,85, FruitSprite.MELON, 1,1, 1);
                placeFruit(410,37, FruitSprite.PINEAPPLE, 3,1, 30);
                
            }
            for (Entity entity : entities) {
                entity.spawn();
            }
            player.spawn(5-32,207-32);
            break;
        case 2: //SECOND LEVEL
            //if the level HAS changed, load all of the objects for this level
            if (lastLevelLoaded != currentLevel) {
                objects = new Object[]{
                    //Border
                    new Terrain(TerrainType.BRICK, -46,0, 1,15),
                    new Terrain(TerrainType.BRICK, baseWidth-2,0, 1,15),
                    new Terrain(TerrainType.BRICK, 0,-46, 15,1),
                    //Level Terrain
                    new Terrain(TerrainType.GRASS, 0,140, 3,6),
                    new Terrain(TerrainType.COTTONCANDY, 133,285, 9,1),
                    new Terrain(TerrainType.BRICK, 225,195, 7,1),
                    new Terrain(TerrainType.BRICK, 250,70, 6,1)
                    
                };
                entities = new ArrayList<Entity>(){{
                    add(new Mushroom(150,253, 0,200));
                    add(new Mushroom(280,163, 60,190));
                    add(new Mushroom(420,163, 175,30));
                    add(new Mushroom(420,38, 155,30));
                    add(new Mushroom(280,38, 30,165));
                    add(new Mushroom(15,108, 17,70));
                }};
                placeFruit(230,250, FruitSprite.STRAWBERRY, 6,1, 40);
                placeFruit(250,140, FruitSprite.PINEAPPLE, 6,1, 40);
                placeFruit(285,15, FruitSprite.CHERRIES, 5,1, 40);
                placeFruit(5,85, FruitSprite.ORANGE, 3,1, 40);
            }
            //spawn the entities
            for (Entity entity : entities) {
                entity.spawn();
            }
            //spawn the player
            player.spawn(460-32,250-32);
            break;
        default: //MENU levels
            //if the level HAS changed, initialise all of the objects for this level
            if (lastLevelLoaded != currentLevel) {
                objects = new Object[]{
                    new Terrain(TerrainType.GRASS, -player.Width, baseHeight - 48, 13, 1)
                };
                entities = new ArrayList<Entity>();
            }
            //spawn the character just offscreen
            player.spawn(-player.Width, baseHeight - (48 + player.Height));
            player.movingRight = true; //set the player to be permanently moving to the right
            player.flipped = false;
            break;
    }
    lastLevelLoaded = currentLevel; //update the value of the last level loaded to be the current level
}

//the following 2 functions and enumerator are used for playing and stopping sound effects
public void playSound(Sound sound, boolean loop) {
    if (muteSFX || (currentLevel <= 0 && !(sound == Sound.SELECT || sound == Sound.CONFIRM || sound == Sound.HURT))) { //dont play sound effects on main menu unless its a menu or death sound
        return;
    }
    int effect = 0;
    int gain = -10;
    switch (sound) {
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
        case COLLECT:
            effect = 6;
            gain = 0;
            break;
        case KILL:
            effect = 7;
            break;
        case SUCCESS:
            effect = 8;
            gain = 10;
            break;
        default:
            break;
    }
    soundEffects[effect].setGain(gain); //set the gain to -10db before playing it
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
        case COLLECT:
            effect = 6;
            break;
        case KILL:
            effect = 7;
            break;
        case SUCCESS:
            effect = 8;
            break;
        default:
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
    HURT,
    COLLECT,
    KILL,
    SUCCESS
}

class Indicator {
    float xPosition;
    float yPosition;
    public void move(float x, float y) {
        xPosition = x;
        yPosition = y;
    }
    public void redraw() {
        image(indicatorSprite, xPosition,yPosition);
    }
}
