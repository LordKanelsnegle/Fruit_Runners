public class Terrain extends Object {
    int horizontal;
    int vertical;
    public Terrain(TerrainType terrainType, float x, float y, int w, int h) {
        xPosition = x;
        yPosition = y;
        horizontal = w;
        vertical = h;
        spriteSheet = loadImage("Assets\\Terrain\\Terrain.png"); //update the file that spriteSheet points to
        int sprite = 0; //set to the grass terrain by default
        switch (terrainType) { //check which sprite it actually needs to be set to
            case CARAMEL:
                sprite = 1;
                break;
            case COTTONCANDY:
                sprite = 2;
                break;
            case BRICK:
                sprite = 3;
            default:
                break;
        }
        spriteSheet = spriteSheet.get(sprite * 48, 0, 48, 48);
    }
    
    public void redraw() {
        int totalWidth = 0;
        int totalHeight = 0;
        for (int y = 0; y < vertical; y++) {
            for (int x = 0; x < horizontal; x++) {
                if (y == 0) {
                    int spriteWidth = 48;
                    if (x == 0) {
                        image(spriteSheet.get(0,0,48,48), xPosition + x * spriteSheet.width, yPosition + y * spriteSheet.height);
                        totalHeight += 48;
                    } else {
                        image(spriteSheet.get(2,0,46,48), xPosition + x * (spriteSheet.width - 4), yPosition + y * spriteSheet.height);
                        spriteWidth = 44;
                    }
                    totalWidth += spriteWidth;
                } else {
                    if (x == 0) {
                        image(spriteSheet.get(0,15,48,33), xPosition + x * spriteSheet.width, yPosition + y * (spriteSheet.height - 17));
                        totalHeight += 31;
                    } else {
                        image(spriteSheet.get(2,15,46,33), xPosition + x * (spriteSheet.width - 4), yPosition + y * (spriteSheet.height - 17));
                    }
                }
            }
        }
        Width = totalWidth;
        Height = totalHeight;
    }
}

public enum TerrainType {
    GRASS,
    CARAMEL,
    COTTONCANDY,
    BRICK
}
