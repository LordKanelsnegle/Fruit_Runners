public class Fruit extends Entity {
    PImage collectedSprite;
    public Boolean collected;
    public Fruit(float x, float y, PImage sprite) {
        xPosition = x;
        yPosition = y;
        Width = 32;
        Height = 32;
        spriteSheet = sprite;
        collectedSprite = loadImage("Assets\\Items\\Fruits\\Collected.png");
    }
    
    public void redraw() {
        if (died) {
            return;
        }
        image(spriteSheet.get(frame * Width, 0, Width, Height), xPosition, yPosition);
        framesPassed++; //increment the frame counter
        if (framesPassed == 3) { //if 3 frames have passed, allow the next animation frame to be drawn
            frame++; //increment the frame
            if (frame == maxFrame) { //if the frame is at the maximum, reset it to the first one unless the item has been collected
                if (collected) {
                    died = true;
                }
                frame = 0;
            }
            framesPassed = 0; //reset the frames counter
        }
    }
    
    public void spawn() {
        frame = 0; //reset the frame to 0
        maxFrame = spriteSheet.width / Width; //reset the maximum number of frames
        collected = false;
        died = false;
    }
    
    public void collect() {
        spriteSheet = collectedSprite;
        collected = true;
    }
}

private void placeFruit(float xPosition, float yPosition, FruitSprite fruit, int w, int h, int spacing) {
    int index = 0;
    switch (fruit) { //check which animation it actually needs to be set to
        case BANANAS:
            index = 1;
            break;
        case CHERRIES:
            index = 2;
            break;
        case KIWI:
            index = 3;
            break;
        case MELON:
            index = 4;
            break;
        case ORANGE:
            index = 5;
            break;
        case PINEAPPLE:
            index = 6;
            break;
        case STRAWBERRY:
           index = 7;
           break;
        default:
           break;
    }
    for (int x = 0; x < w; x++) {
       for (int y = 0; y < h; y++) {
           Fruit f = new Fruit(xPosition + x * spacing, yPosition + y * spacing, fruits[index]);
           entities.add(f);
       }
    }
}

public enum FruitSprite {
    APPLE,
    BANANAS,
    CHERRIES,
    KIWI,
    MELON,
    ORANGE,
    PINEAPPLE,
    STRAWBERRY
}
