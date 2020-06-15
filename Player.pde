public class Player extends Object {
    String[] players = new String[] { "Mask Dude\\", "Ninja Frog\\", "Pink Man\\", "Virtual Guy\\" };
    int index = 0;
    int frame = 0;
    int maxFrame = 0;
    public Player() {
        Width = 32;
        Height = 32;
        changeAnimation(Animation.IDLE);
    }
    
    public void redraw() {
        image(sprite.get(frame * Width, 0, Width, Height), xPosition, yPosition);
        frame++;
        if (frame == maxFrame) {
            frame = 0;
        }
    }
    
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
    
    public void respawn(float x, float y) {
        xPosition = x;
        yPosition = y;
        index++;
        if (index == players.length) {
            index = 0;
        }
    }
    
    private void changeAnimation(Animation animation) {
        String file = "Idle.png";
        switch (animation) {
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
        sprite = loadImage("Assets\\Players\\" + players[index] + file);
        frame = 0;
        maxFrame = sprite.width / Width;
    }
}

enum Animation {
    DOUBLEJUMP,
    FALL,
    HIT,
    IDLE,
    JUMP,
    RUN,
    WALLJUMP
}
