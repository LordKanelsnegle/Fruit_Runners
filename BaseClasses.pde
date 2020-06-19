//This is a base class for everything in the level as the player, enemies, obstacles and terrain will
//  all need the following properties and function (since they all need to be redrawable to appear in
//  front of the background and they all have position and dimension properties)
public class Object {
    PImage spriteSheet;
    public float xPosition;
    public float yPosition;
    public int Width;
    public int Height;
    public void redraw(){}
}

public class Entity {
    PImage[] spriteSheets; //this is an array of the available character spritesheets
    PImage spriteSheet;
    int sprite = 0; //an index for keeping track of the currently used character
    int frame = 0; //a frame counter for animations
    int maxFrame = 0; //the maximum frame for a given animation (to know when to reset the frame variable)
    public float xPosition, yPosition;
    public int Width, Height;
    public Boolean flipped;
    public Boolean died = false;
    //this function draws the entity, using get() to select the required sprite from the sprite sheet
    //most of the entity assets used are designed to run at 20 fps but the game itself should run at 60 to be smooth, so this variable
    //  counts the number of frames which have passed so that the necessary assets are only drawn 1/3rd of the time (20 fps)
    int framesPassed = 0;
    public void redraw() {
        //none of the sprite sheets have multiple lines so the y variable is always 0, but the x variable depends on the frame.
        //  also, if the sprite is facing right (needs to be flipped), the sprite is scaled and position is inverted
        if (flipped) {
            pushMatrix();
            scale(-1, 1);
            image(spriteSheet.get(frame * Width, 0, Width, Height), -xPosition - Width, yPosition);
            popMatrix();
        } else {
            image(spriteSheet.get(frame * Width, 0, Width, Height), xPosition, yPosition);
        }
        
        framesPassed++; //increment the frame counter
        if (framesPassed == 3) { //if 3 frames have passed, allow the next animation frame to be drawn
            frame++; //increment the frame
            if (frame == maxFrame) {
                if (!died) { //only reset the frame counter if the entity hasnt died, so that the death animation doesnt loop
                    frame = 0; //if the frame is at the maximum, reset it to the first one
                }
            }
            framesPassed = 0; //reset the frames counter
        }
    }
    public void move(){}
    public void die(){}
}
