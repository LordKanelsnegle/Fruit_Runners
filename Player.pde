//This is the Player class, which controls the animations/movements/spawning for the player.
//  It extends the Entity class and thus inherits most necessary properties by default.
public class Player extends Entity {
    int sprite = 0; //an index for keeping track of the currently used character
    boolean jumping, doubleJumped, wallJumping, falling, justKilled; //movement flags for tracking how to move the player
    public Animation animationState; //a variable for tracking the currently playing animation
    public boolean movingRight, movingLeft, spawning = false; //more movement flags but these are public so they
                                            //  can be edited from Fruit_Runners functions
    public Player() {
        //on initialization, set the width and height properties to 32 since all of the player sprites are 32x32
        Width = 32;
        Height = 32;
        spriteSheets = players;
    }
    
    final float gravity = 1.03;
    float fallSpeed = 0;
    int fallSpeedCap = 10;
    public void checkCollisions() {
        boolean supported = false;
        float rightFootPosition = xPosition + 0.7 * Width;
        float leftFootPosition = xPosition + 0.3 * Width;
        float feetPosition = yPosition + Height;
        float headPosition = yPosition + Height * 0.1;
        for (Entity ent : entities) {
            if (ent.died) {
                continue; //skip dead entities
            }
            float entityLeft = ent.xPosition + 7;
            float entityRight = ent.xPosition + ent.Width - 7;
            float entityTop = ent.yPosition + 7;
            float entityBottom = ent.yPosition + ent.Height - 7;
            if (ent instanceof Mushroom) {
                entityTop = ent.yPosition + 12;
                entityLeft = ent.xPosition + 2;
                entityRight = ent.xPosition + ent.Width - 2;
            }
            if (headPosition <= entityTop && feetPosition >= entityBottom) { //if entity standing within vertical bounds of player
                //collisions on either side of player
                if ((leftFootPosition < entityRight && leftFootPosition > entityLeft) || (rightFootPosition > entityLeft && rightFootPosition < entityRight)) {
                    if (ent instanceof Fruit) {
                        ent.die(); //collect it
                    } else { //otherwise, must be an enemy
                        die();
                    }
                }
            } else if (rightFootPosition >= entityLeft && leftFootPosition <= entityRight) { //else if standing within horizontal bounds of the object
                //collisions below player
                if (feetPosition >= entityTop && feetPosition <= entityBottom) {
                    //ent.die(); //whether enemy or fruit, kill it
                    if (ent instanceof Fruit) {
                        ent.die(); //collect it
                    } else { //otherwise, must be an enemy
                        if (animationState == Animation.FALL) {
                            justKilled = true;
                            ent.die();
                        } else if (!justKilled) {
                            die();
                        }
                    }
                }
                //collisions above player
                else if (headPosition < entityBottom && headPosition > entityTop) {
                    if (ent instanceof Fruit) {
                        ent.die(); //collect it
                    } else { //otherwise, must be an enemy
                        die();
                    }
                }
            }
        }
        for (Object obj : objects) {
            //VERTICAL COLLISIONS - check if standing within horizontal bounds of the object
            if (rightFootPosition >= obj.xPosition && leftFootPosition <= obj.xPosition + obj.Width) {
                //collisions below player
                if (feetPosition >= obj.yPosition && feetPosition <= obj.yPosition + fallSpeed) {
                    yPosition = obj.yPosition - Height; //using = method instead of += method to prevent weird spazzing
                    supported = true;
                }
                //collisions above player
                else if (headPosition <= obj.yPosition + obj.Height && headPosition >= obj.yPosition + obj.Height - jumpSpeed) {
                    yPosition += obj.yPosition + obj.Height - headPosition;
                    jumping = false;
                }
            }
            //HORIZONTAL COLLISIONS - check if standing within vertical bounds of object
            if (feetPosition-2 >= obj.yPosition && headPosition <= obj.yPosition + obj.Height) {
                //collisions on left of player
                if (leftFootPosition - 4 <= obj.xPosition + obj.Width && leftFootPosition - 4 >= obj.xPosition + obj.Width - 4 - speed) {
                    xPosition += obj.xPosition + obj.Width - (leftFootPosition - 4);
                    if (falling) {
                        if (jumpSpeed <= fallSpeed && headPosition >= obj.yPosition) {
                            wallJumping = true;
                            doubleJumped = false;
                            flipped = true;
                            changeAnimation(Animation.WALLJUMP);
                            xPosition -= 3;
                            jumpSpeed = 0;
                        }
                    } else {
                        changeAnimation(Animation.IDLE);
                    }
                }
                //collisions on right of player
                else if (rightFootPosition + 4 >= obj.xPosition && rightFootPosition <= obj.xPosition + 4 + speed) {
                    xPosition += obj.xPosition - (rightFootPosition + 4);
                    if (falling) {
                        if (jumpSpeed <= fallSpeed && headPosition >= obj.yPosition) {
                            wallJumping = true;
                            doubleJumped = false;
                            flipped = false;
                            changeAnimation(Animation.WALLJUMP);
                            xPosition += 3;
                            jumpSpeed = 0;
                        }
                    } else {
                        changeAnimation(Animation.IDLE);
                    }
                } else {
                    wallJumping = false;
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
        if (xPosition + Width <= 0 || xPosition >= baseWidth || yPosition <= -Height || yPosition >= baseHeight) {
            die();
        }
    }

    //this function controls the movement of the player
    final float jumpAcceleration = 0.98;
    float jumpSpeed = 0;
    final float acceleration = 1.6;
    float speed = 0;
    float speedCap = 2.4;
    public void move() {
        if (animationState == Animation.WALLJUMP) {
            fallSpeedCap = 2;
        } else {
            fallSpeedCap = 10;
            if (fallSpeed == 2) {
                fallSpeed = 4;
            }
        }
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
        
        if (currentLevel > 0) {
            speedCap = 2.4;
            if (animationState == Animation.RUN) {
                playSound(Sound.RUN, true);
            } else {
                stopSound(Sound.RUN);
            }
        } else {
            speedCap = 1.2;
            stopSound(Sound.RUN);
        }
        
        jumpSpeed *= jumpAcceleration;
        if (jumping && !wallJumping) {
            yPosition -= jumpSpeed;
            if (jumpSpeed < fallSpeed) {
                changeAnimation(Animation.FALL);
            }
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
            if (!wallJumping && animationState == Animation.IDLE) {
                changeAnimation(Animation.RUN);
            }
        }
    }
    
    //this function controls the vertical movement of the player
    public void jump() {
        if (falling && !wallJumping) {
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
            if (wallJumping) {
                doubleJumped = false;
            }
            changeAnimation(Animation.JUMP);
            Sound jump = Sound.JUMP;
            if (justKilled) {
                jump = Sound.KILL;
                doubleJumped = false;
                justKilled = false;
            }
            playSound(jump, false);
        }
    }
    
    //this function allows the player to be spawned at a given point
    public void spawn(float x, float y) {
        xPosition = x; //set the player's x coordinate
        yPosition = y; //set the player's y coordinate
        died = false; //reset the death flag
        disabled = false; //reset the disabled flag
        movingRight = false;
        movingLeft = false;
        falling = false;
        jumping = false;
        doubleJumped = false;
        wallJumping = false;
        justKilled = false;
        if (currentLevel <= 0) {
            changeAnimation(Animation.IDLE);
        } else {
            changeAnimation(Animation.APPEAR);
            spawning = true;
        }
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
    public void changeAnimation(Animation animation) {
        if (animationState == animation || (falling && (animation == Animation.RUN || animation == Animation.IDLE))) { //if the animation is already playing, return so it isnt played again
            return;
        }
        if (animationState == Animation.WALLJUMP) { //if about to change from walljumping (ie walljump has ended), revert flipped
            if (flipped) {
                if (!movingLeft) {
                    flipped = false;
                }
            } else {
                if (!movingRight) {
                    flipped = true;
                }
            }
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
            case APPEAR:
                index = 7;
                break;
            case DISAPPEAR:
                index = 8;
                break;
            default:
                break;
        }
        if (index < 7) {
            spriteSheet = spriteSheets[sprite * 7 + index]; //update the file that spriteSheet points to
        } else {
            spriteSheet = spriteSheets[spriteSheets.length - (9-index)]; //update the file that spriteSheet points to
            Width = 96;
            Height = 96;
        }
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
    WALLJUMP,
    APPEAR,
    DISAPPEAR
}
