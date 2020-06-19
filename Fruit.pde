PImage collectedSprite;
public class Fruit extends Entity {
    PImage baseSprite;
    public Fruit(float x, float y, PImage sprite) {
        xPosition = x;
        yPosition = y;
        Width = 32;
        Height = 32;
        baseSprite = sprite;
    }
    
    public void spawn() {
        spriteSheet = baseSprite;
        frame = 0; //reset the frame to 0
        maxFrame = spriteSheet.width / Width; //reset the maximum number of frames
        died = false;
        disabled = false;
    }
    
    public void die() {
        if (!died) {
            spriteSheet = collectedSprite;
            frame = 0;
            died = true;
            playSound(Sound.COLLECT, false);
        }
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
