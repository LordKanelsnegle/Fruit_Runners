//This is the Mushroom class, which controls the animations/movements/spawning for the Mushroom enemy.
//  It extends the Entity class and thus inherits most necessary properties by default.
public class Mushroom extends Entity {
    MushroomAnimation animationState; //a variable for tracking the currently playing animation
    public Mushroom(float x, float y) {
        //on initialization, set the width and height properties to 32 since all of the mushroom sprites are 32x32
        Width = 32;
        Height = 32;
        spriteSheets = new PImage[]{ //load all of the sprite sheets
            loadImage("Assets\\Enemies\\Mushroom\\Idle.png"),
            loadImage("Assets\\Enemies\\Mushroom\\Run.png"),
            loadImage("Assets\\Enemies\\Mushroom\\Hit.png")
        };
        xPosition = x; //set the mushroom's x coordinate
        yPosition = y; //set the mushroom's y coordinate
        changeAnimation(MushroomAnimation.IDLE); //set the animation to be idle initially
    }
    
    //this function controls the animation being displayed
    private void changeAnimation(MushroomAnimation animation) {
        if (animationState == animation) { //if the animation is already playing, return so it isnt loaded again
            return;
        }
        animationState = animation; //update the animation state to reflect the new animation
        int index = 0;
        switch (animation) { //check which animation it actually needs to be set to
            case RUN:
                index = 1;
                break;
            case HIT:
                index = 2;
                break;
            default:
                break;
        }
        spriteSheet = spriteSheets[index]; //update the file that spriteSheet points to
        frame = 0; //reset the frame to 0
        maxFrame = spriteSheet.width / Width; //reset the maximum number of frames
    }
}

//this enum is just for simplifying which animation to play
public enum MushroomAnimation {
    IDLE,
    RUN,
    HIT
}
