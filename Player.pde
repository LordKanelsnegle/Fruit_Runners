//TODO: Complete die() function after finishing checkCollisions() and jump()

//This is the Player class, which controls the animations/movements/spawning for the player.
//  It extends the Object class and thus inherits the necessary properties by default.
public class Player extends Object {
    String[] players = new String[] { "Mask Dude\\", "Ninja Frog\\", "Pink Man\\", "Virtual Guy\\" }; //this is an array of the available character folders
    int index = 0; //an index for keeping track of the currently used character
    int frame = 0; //a frame counter for animations
    int maxFrame = 0; //the maximum frame for a given animation (to know when to reset the frame variable)
    Boolean jumping, doubleJumped, falling;
    public Boolean movingRight, movingLeft, flipped = false;
    public Boolean died = false;
    public Animation animationState; //a variable for tracking the currently playing animation
    public Player() {
        //on initialization, set the width and height properties to 32 since all of the player characters are 32x32
        Width = 32;
        Height = 32;
    }
    
    //this is the function that actually draws the player, using get() to select the required sprite from the sprite sheet
    //most of the player assets used are designed to run at 20 fps but the game itself should run at 60 to be smooth, so this variable
    //  counts the number of frames which have passed so that the necessary assets are only drawn 1/3rd of the time (20 fps)
    int frames = 0;
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
        
        frames++; //increment the frame counter
        if (frames == 3) { //if 3 frames have passed, allow the next animation frame to be drawn
            frame++; //after getting the sprite, increment the frame
            if (frame == maxFrame) {
                if (!died) { //only reset the frame counter if the player hasnt died, so that the death animation doesnt loop
                    frame = 0; //if the frame is at the maximum, reset it to the first one
                }
            }
            frames = 0; //reset the frames counter
        }
    }
    
    public void checkCollisions() {
        Boolean supported = false;
        for (Object obj : objects) {
            float rightFootPosition = 0.7 * Width;
            float leftFootPosition = 0.3 * Width;
            float feetPosition = yPosition + Height;
            if ((xPosition + leftFootPosition > obj.xPosition && xPosition + rightFootPosition <= obj.xPosition + obj.Width) && (feetPosition == obj.yPosition)) {
                yPosition = obj.yPosition - Height;
                supported = true;
            }
        }
        if (supported) {
            falling = false;
            doubleJumped = false;
            if (player.animationState == Animation.FALL) {
                player.changeAnimation(Animation.IDLE); //reset the player to the idle animation if theyre still set to falling
            }
        } else {
            falling = true;
        }
    }

    //this function controls the movement of the player
    float jumpMaxDistance = 0;
    float jumpDistance = 0;
    public void move() {
        if (!jumping) {
            if (falling) {
                changeAnimation(Animation.FALL);
                yPosition += 4;
            }
        } else {
            yPosition -= 4;
            jumpDistance += 4;
            if (jumpDistance == jumpMaxDistance) {
                jumping = false;
                jumpDistance = 0;
            }
        }
        float distance = 2 * (int(movingRight) - int(movingLeft));
        //if xPosition + distance wont collide with a wall, increment xPosition
        xPosition += distance;
        if (distance != 0 && animationState == Animation.IDLE) {
            changeAnimation(Animation.RUN);
        }
    }
    
    //this function controls the vertical movement of the player
    public void jump() {
        if (animationState == Animation.FALL) {
            if (!doubleJumped) {
                doubleJumped = true;
                changeAnimation(Animation.DOUBLEJUMP);
                jumpMaxDistance = 52;
                jumping = true;
            }
        } else {
            jumpMaxDistance = 60;
            if (animationState == Animation.WALLJUMP) {
                jumpMaxDistance = 40;
            }
            changeAnimation(Animation.JUMP);
            jumping = true;
        }
    }
    
    //this function allows the player to be spawned at a given point
    public void spawn(float x, float y) {
        xPosition = x; //set the player's x coordinate
        yPosition = y; //set the player's y coordinate
        changeAnimation(Animation.IDLE); //set the animation to be idle initially
        died = false; //reset the death flag
        movingRight = false;
        movingLeft = false;
        falling = false;
        jumping = false;
        doubleJumped = false;
    }
    
    public void die() {
        if (!player.died) {
            index++; //increment the index so that the next character is used on spawn
            if (index == players.length) {
                index = 0; //if the index has reached its max, reset it to 0
            }
            changeAnimation(Animation.HIT);
            //knock upwards (half jump) and backwards, tilting at 45 degree angle upwards
            //apply light screen shake and flare (low opacity flash)
            player.died = true;
        }
    }
    
    //this function controls the animation being displayed
    private void changeAnimation(Animation animation) {
        animationState = animation; //update the animation state to reflect the new animation
        String file = "Idle.png"; //set to the idle animation by default
        switch (animation) { //check which animation it actually needs to be set to
            case DOUBLEJUMP:
                file = "Double Jump.png";
                break;
            case FALL:
                file = "Fall.png";
                break;
            case HIT:
                file = "Hit.png";
                break;
            case JUMP:
                file = "Jump.png";
                break;
            case RUN:
                file = "Run.png";
                break;
            case WALLJUMP:
                file = "Wall Jump.png";
                break;
            default:
                break;
        }
        spriteSheet = loadImage("Assets\\Players\\" + players[index] + file); //update the file that spriteSheet points to
        frame = 0; //reset the frame to 0
        maxFrame = spriteSheet.width / Width; //reset the maximum number of frames
    }
}

//this enum is just for simplifying which animation to play
public enum Animation {
    DOUBLEJUMP,
    FALL,
    HIT,
    IDLE,
    JUMP,
    RUN,
    WALLJUMP
}
