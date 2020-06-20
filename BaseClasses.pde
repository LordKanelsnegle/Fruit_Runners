//this is the base class for all terrain and platforms in the level as they will all need the following
//  properties and function (since they need to be redrawable to appear in front of the background)
public class Object {
    PImage spriteSheet; //the sprite sheet in use at any given time
    public float xPosition, yPosition; //position properties
    public int Width, Height; //dimension properties
    public void redraw(){} //function for redrawing the object
}

//this is the base class for the player, enemies, items and traps in the level as they will all need the following
//  properties and functions (since they need to be redrawable (animated), able to move and able to die)
public class Entity {
    Boolean disabled = false;
    PImage[] spriteSheets; //this is an array of the available character spritesheets
    PImage spriteSheet; //the sprite sheet in use at any given time
    int frame = 0; //a frame counter for animations
    int maxFrame = 0; //the maximum frame for a given animation (to know when to reset the frame variable)
    public float xPosition, yPosition; //position properties
    public int Width, Height; //dimension properties
    public Boolean flipped = false; //direction properties
    public Boolean died = false; //death flag
    
    //this function draws the entity, using get() to select the required sprite from the sprite sheet
    //most of the entity assets used are designed to run at 20 fps but the game itself should run at 60 to be smooth, so this variable
    //  counts the number of frames which have passed so that the necessary assets are only drawn 1/3rd of the time (20 fps)
    public void redraw() {
        if (disabled) {
            return;
        }
        //none of the sprite sheets have multiple lines so the y variable is always 0, but the x variable depends on the frame.
        //  also, if the sprite is facing right (needs to be flipped), the sprite is scaled and position is inverted
        int framePosition = frame * Width;
        pushMatrix();
        if (flipped) {
            scale(-1, 1);
            beginShape();
            texture(spriteSheet);
            vertex(-xPosition-Width,yPosition, framePosition,0);
            vertex(-xPosition,yPosition, framePosition+Width,0);
            vertex(-xPosition,yPosition+Height, framePosition+Width,Height);
            vertex(-xPosition-Width,yPosition+Height, framePosition,Height);
            endShape();
        } else {
            beginShape();
            texture(spriteSheet);
            vertex(xPosition,yPosition, framePosition,0);
            vertex(xPosition+Width,yPosition, framePosition+Width,0);
            vertex(xPosition+Width,yPosition+Height, framePosition+Width,Height);
            vertex(xPosition,yPosition+Height, framePosition,Height);
            endShape();
        }
        popMatrix();
        int skipFrames = 3;
        if (currentLevel == 0) {
            skipFrames *= 2;
        }
        if (frameCount % skipFrames == 0) { //if 3 (or 6 if menu) frames have passed, allow the next animation frame to be drawn
            frame++; //increment the frame
            if (frame == maxFrame) { //if the frame is at the maximum, reset it to the first one
                if (died) {
                    disabled = true;
                }
                frame = 0; //only reset the frame counter if the entity hasnt died, so that the death animation doesnt loop
            }
        }
    }
    //functions for entity spawning, movement and death
    public void spawn(){}
    public void move(){}
    public void die(){}
}
