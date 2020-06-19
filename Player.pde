//This is the Player class, which controls the animations/movements/spawning for the player.
//  It extends the Entity class and thus inherits most necessary properties by default.
public class Player extends Entity {
    int sprite = 0; //an index for keeping track of the currently used character
    Boolean jumping, doubleJumped, falling; //movement flags for tracking how to move the player
    public Animation animationState; //a variable for tracking the currently playing animation
    public Boolean movingRight, movingLeft; //more movement flags but these are public so they
                                            //  can be edited from Fruit_Runners functions
    public Player() {
        //on initialization, set the width and height properties to 32 since all of the player sprites are 32x32
        Width = 32;
        Height = 32;
        spriteSheets = new PImage[]{
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
            loadImage("Assets\\Players\\Virtual Guy\\Wall Jump.png")
        };
    }
    
    final float gravity = 1.03;
    float fallSpeed = 0;
    int fallSpeedCap = 10;
    public void checkCollisions() {
        Boolean supported = false;
        float rightFootPosition = xPosition + 0.7 * Width;
        float leftFootPosition = xPosition + 0.3 * Width;
        float feetPosition = yPosition + Height;
        float headPosition = yPosition + Height * 0.5;
        for (Entity ent : entities) {
            if (headPosition >= ent.yPosition && feetPosition <= ent.yPosition + ent.Height) { //if standing within vertical bounds of entity
                //collisions on either side of player
                if (leftFootPosition < ent.xPosition + ent.Width && leftFootPosition > ent.xPosition || (rightFootPosition > ent.xPosition && rightFootPosition < ent.xPosition + ent.Width)) {
                    if (ent instanceof Fruit) {
                        ent.die(); //collect it
                    } else { //otherwise, must be an enemy
                        die();
                    }
                }
            } else if (rightFootPosition >= ent.xPosition && leftFootPosition <= ent.xPosition + ent.Width) { //else if standing within horizontal bounds of the object
                //collisions below player
                if (feetPosition >= ent.yPosition && feetPosition <= ent.yPosition + ent.Height) {
                    ent.die(); //whether enemy or fruit, kill it
                }
                //collisions above player
                else if (headPosition < ent.yPosition + ent.Height && headPosition > ent.yPosition) {
                    if (ent instanceof Fruit) {
                        ent.die(); //collect it
                    } else { //otherwise, must be an enemy
                        die();
                    }
                }
            }
        }
        for (Object obj : objects) {
            if (headPosition >= obj.yPosition && feetPosition <= obj.yPosition + obj.Height) { //if standing within vertical bounds of object
                //collisions on left of player
                if (leftFootPosition < obj.xPosition + obj.Width && leftFootPosition > obj.xPosition) { //if left foot is within horizontal bounds of object,
                    xPosition += obj.xPosition + obj.Width - leftFootPosition;                          //  then its safe to assume the player is colliding with
                    doubleJumped = false;                                                               //  the object from the left (ie the RIGHT side of the object)
                    changeAnimation(Animation.WALLJUMP);                                                //  and should be placed beside it then switched to walljumping
                }
                //collisions on right of player
                else if (rightFootPosition > obj.xPosition && rightFootPosition < obj.xPosition + obj.Width) { //if right foot is within horizontal bounds of object,
                    xPosition += obj.xPosition - rightFootPosition;                                            //  then its safe to assume the player is colliding with
                    doubleJumped = false;                                                                      //  the object from the right (ie the LEFT side of the object)
                    changeAnimation(Animation.WALLJUMP);                                                       //  and should be placed beside it then switched to walljumping
                }
            } else if (rightFootPosition >= obj.xPosition && leftFootPosition <= obj.xPosition + obj.Width) { //else if standing within horizontal bounds of the object
                //collisions below player
                if (feetPosition >= obj.yPosition && feetPosition <= obj.yPosition + obj.Height) { //if feet position is within vertical bounds of object then the object
                    yPosition += obj.yPosition - feetPosition;                                     //  must be below the player (ie the TOP side of the object) and thus the
                    supported = true;                                                              //  player is supported by an object and should be placed ontop of it
                }
                //collisions above player
                else if (headPosition < obj.yPosition + obj.Height && headPosition > obj.yPosition) { //if head position is within vertical bounds of object then the object
                    yPosition += obj.yPosition + obj.Height - headPosition;                           //  must be above the player (ie the BOTTOM side of the object) and thus
                    jumping = false;                                                                  //  the player should bump his head/cancel jump and be placed below it
                }
            }
        }
        if (supported) {
            if (falling) {
                playSound(Sound.LAND, false);
                falling = false;
                fallSpeed = 0;
                doubleJumped = false;
                jumping = false;
                jumpSpeed = 0;
                changeAnimation(Animation.IDLE); //reset the player to the idle animation if theyre still set to falling
            }
        } else {
            if (!falling) {
                falling = true;
                fallSpeed = 4;
            }
        }
        //kill the player if they go off screen
        if (xPosition + Width <= 0 || xPosition >= width || yPosition <= -Height || yPosition >= height) {
            die();
        }
    }

    //this function controls the movement of the player
    final float jumpAcceleration = 0.98;
    float jumpSpeed = 0;
    final float acceleration = 1.6;
    float speed = 0;
    final float speedCap = 2.4;
    public void move() {
        if (falling) {
            if (fallSpeed < fallSpeedCap) {
                fallSpeed *= gravity;
            } else {
                fallSpeed = fallSpeedCap;
            }
            yPosition += fallSpeed;
            if (!jumping) {
                changeAnimation(Animation.FALL);
            }
        }
        
        if (currentLevel > 0 && animationState == Animation.RUN) {
            playSound(Sound.RUN, true);
        } else {
            stopSound(Sound.RUN);
        }
        
        jumpSpeed *= jumpAcceleration;
        if (jumping) {
            yPosition -= jumpSpeed;
        }
        if (speed < speedCap) {
            speed *= acceleration;
        } else {
            speed = speedCap;
        }
        int direction = int(movingRight) - int(movingLeft);
        if (direction == 0) {
            speed = 0;
        } else {
            if (speed == 0) {
                speed = 0.5;
            }
            xPosition += speed * direction;
            if (animationState == Animation.IDLE) {
                changeAnimation(Animation.RUN);
            }
        }
    }
    
    //this function controls the vertical movement of the player
    public void jump() {
        if (falling) {
            if (!doubleJumped) {
                doubleJumped = true;
                jumpSpeed = 7;
                jumping = true;
                playSound(Sound.JUMP, false);
                fallSpeed = 3;
                changeAnimation(Animation.DOUBLEJUMP);
            }
        } else {
            jumpSpeed = 9;
            jumping = true;
            if (animationState == Animation.WALLJUMP) {
                jumpSpeed = 7;
                xPosition -= 20;
                if (flipped) {
                    xPosition += 40;
                }
            }
            changeAnimation(Animation.JUMP);
            playSound(Sound.JUMP, false);
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
        if (!died) {
            sprite++; //increment the index so that the next character is used on spawn
            if (sprite == 4) {
                sprite = 0; //if the index has reached its max, reset it to 0
            }
            changeAnimation(Animation.HIT);
            //knock upwards (half jump) and backwards, tilting at 45 degree angle upwards
            //apply light screen shake and flare (low opacity flash)
            died = true;
            playSound(Sound.HURT, false);
        }
    }
    
    //this function controls the animation being displayed
    private void changeAnimation(Animation animation) {
        if (animationState == animation) { //if the animation is already playing, return so it isnt played again
            return;
        }
        animationState = animation; //update the animation state to reflect the new animation
        int index = 0;
        switch (animation) { //check which animation it actually needs to be set to
            case DOUBLEJUMP:
                index = 1;
                break;
            case FALL:
                index = 2;
                break;
            case HIT:
                index = 3;
                break;
            case JUMP:
                index = 4;
                break;
            case RUN:
                index = 5;
                break;
            case WALLJUMP:
                index = 6;
                break;
            default:
                break;
        }
        spriteSheet = spriteSheets[sprite * 7 + index]; //update the file that spriteSheet points to
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
