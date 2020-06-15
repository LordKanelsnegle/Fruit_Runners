//This is the Player class, which controls the animations/movements/spawning for the player.
//  It extends the Object class and thus inherits the necessary properties by default.
public class Player extends Object {
    String[] players = new String[] { "Mask Dude\\", "Ninja Frog\\", "Pink Man\\", "Virtual Guy\\" }; //this is an array of the available character folders
    int index = 0; //an index for keeping track of the currently used character
    int frame = 0; //a frame counter for animations
    int maxFrame = 0; //the maximum frame for a given animation (to know when to reset the frame variable)
    public Player() {
        //on initialization, set the width and height properties to 32 since all of the player characters are 32x32
        Width = 32;
        Height = 32;
    }
    
    //This is the function that actually draws the player, using get() to select the required sprite from the sprite sheet
    public void redraw() {
        //None of the sprite sheets have multiple lines so the y variable is always 0, but the x variable depends on the frame
        image(spriteSheet.get(frame * Width, 0, Width, Height), xPosition, yPosition);
        frame++; //after getting the sprite, increment the frame
        if (frame == maxFrame) {
            frame = 0; //if the frame is at the maximum, reset it to the first one
        }
    }
    
    //This function controls the horizontal movement of the player
    public void move(Boolean left) {
        if (left) {
            //face left
            //move left
        } else {
            //face right
            //move right
        }
        //IF ON THE GROUND play move animation
    }
    
    //This function controls the vertical movement of the player
    public void jump(Boolean doubleJump) { //might not need this boolean, could just check if jump button pressed
        float jumpDistance = 20;           //  while in the air and haven't already double jumped
        if (doubleJump) {
            //play double jump animation
            //halve the jump distance
        } else {
            //play jump animation
        }
        //move upwards by the jump distance
    }
    
    //This function allows the player to be spawned at a given point
    public void spawn(float x, float y) {
        xPosition = x; //set the player's x coordinate
        yPosition = y; //set the player's y coordinate
        changeAnimation(Animation.IDLE); //set the animation to be idle initially
        index++; //increment the index so that the next character is used on subsequent spawn
        if (index == players.length) {
            index = 0; //if the index has reached its max, reset it to 0
        }
    }
    
    //This function controls the animation being displayed
    private void changeAnimation(Animation animation) {
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

//This enum is just for simplifying which animation to play
enum Animation {
    DOUBLEJUMP,
    FALL,
    HIT,
    IDLE,
    JUMP,
    RUN,
    WALLJUMP
}
