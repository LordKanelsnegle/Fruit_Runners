public class Terrain extends Object {
    int horizontal;
    int vertical;
    public Terrain(TerrainType terrainType, float x, float y, int w, int h) {
        xPosition = x;
        yPosition = y;
        horizontal = w;
        vertical = h;
        spriteSheet = loadImage("Assets\\Terrain\\Terrain.png"); //update the file that spriteSheet points to
        int frame = 0; //set to the grass terrain by default
        switch (terrainType) { //check which animation it actually needs to be set to
            case CARAMEL:
                frame = 1;
                break;
            case COTTONCANDY:
                frame = 2;
                break;
            default:
                break;
        }
        spriteSheet = spriteSheet.get(frame * 48, 0, 48, 48);
    }
    
    //bottom tiles are 33 tall (trim 13 from top), assuming no sides trimmed
    //trim 2 pixels on any side that has another tile near it
    public void redraw() {
        int totalWidth = 0;
        int totalHeight = 0;
        for (int y = 0; y < vertical; y++) { //if first of row, keep left wall, if last of row, keep right wall, if first row, keep top wall, if last row, keep bottom wall
            for (int x = 0; x < horizontal; x++) {
                if (y == 0) {
                    if (x == 0) {
                        image(spriteSheet.get(0,0,48,48), xPosition + x * spriteSheet.width, yPosition + y * spriteSheet.height);
                        totalWidth += 48;
                        totalHeight += 48;
                    } else {
                        image(spriteSheet.get(2,0,46,48), xPosition + x * (spriteSheet.width - 4), yPosition + y * spriteSheet.height);
                        totalWidth += 44;
                        totalHeight += 48;
                    }
                } else {
                    if (x == 0) {
                        image(spriteSheet.get(0,15,48,33), xPosition + x * spriteSheet.width, yPosition + y * (spriteSheet.height - 17));
                        totalWidth += 48;
                        totalHeight += 31;
                    } else {
                        image(spriteSheet.get(2,15,46,33), xPosition + x * (spriteSheet.width - 4), yPosition + y * (spriteSheet.height - 17));
                        totalWidth += 44;
                        totalHeight += 31;
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
    COTTONCANDY
}
