//This is the Mushroom class, which controls the animations/movements/spawning for the Mushroom enemy.
//  It extends the Entity class and thus inherits most necessary properties by default.
public class Mushroom extends Entity {
    float initialX, initialY;
    float patrolOne, patrolTwo;
    MushroomAnimation animationState; //a variable for tracking the currently playing animation
    Boolean movingRight, movingLeft;
    public Mushroom(float x, float y, float pOne, float pTwo) {
        //on initialization, set the width and height properties to 32 since all of the mushroom sprites are 32x32
        Width = 32;
        Height = 32;
        spriteSheets = new PImage[]{ //load all of the sprite sheets
            loadImage("Assets\\Enemies\\Mushroom\\Idle.png"),
            loadImage("Assets\\Enemies\\Mushroom\\Run.png"),
            loadImage("Assets\\Enemies\\Mushroom\\Hit.png")
        };
        initialX = x; //set the mushroom's x spawnpoint
        initialY = y; //set the mushroom's y spawnpoint
        patrolOne = pOne; //set the first patrol point
        patrolTwo = pTwo; //set the second patrol point
    }
    
    final float acceleration = 1.1;
    float speed = 0;
    final float speedCap = 1;
    int delay = 0;
    public void move() {
        if (died || (patrolOne == 0 && patrolTwo == 0)) {
            return;
        }
        if (speed < speedCap) {
            speed *= acceleration;
        } else {
            speed = speedCap;
        }
        if (movingRight) {
            flipped = true;
            if (speed == 0) {
                speed = 0.5;
                changeAnimation(MushroomAnimation.RUN);
            }
            xPosition += speed;
            if (xPosition >= initialX + patrolTwo) {
                xPosition = initialX + patrolTwo;
                movingRight = false;
            }
        } else if (movingLeft) {
            flipped = false;
            if (speed == 0) {
                speed = 0.5;
                changeAnimation(MushroomAnimation.RUN);
            }
            xPosition -= speed;
            if (xPosition <= initialX - patrolOne) {
                xPosition = initialX - patrolOne;
                movingLeft = false;
            }
        } else {
            speed = 0;
            changeAnimation(MushroomAnimation.IDLE);
            if (delay == 60) {
                delay = 0;
                if (xPosition == initialX + patrolTwo) {
                    movingLeft = true;
                } else {
                    movingRight = true;
                }
            } else {
                delay++;
            }
        }
    }
    
    //this function allows the mushroom to be spawned at a given point
    public void spawn() {
        xPosition = initialX; //set the mushroom's x coordinate
        yPosition = initialY; //set the mushroom's y coordinate
        changeAnimation(MushroomAnimation.IDLE); //set the animation to be idle initially
        died = false; //reset the death flag
        disabled = false;
        movingRight = true;
        movingLeft = true;
    }
    
    public void die() {
        if (!died) {
            died = true;
            changeAnimation(MushroomAnimation.HIT);
            player.falling = false;
            player.jump(true);
        }
    }
    
    //this function controls the animation being displayed
    private void changeAnimation(MushroomAnimation animation) {
        if (animationState == animation) { //if the animation is already playing, return so it isnt played again
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
