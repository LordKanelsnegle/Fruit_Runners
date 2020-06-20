public class Terrain extends Object {
    int horizontal;
    int vertical;
    public Terrain(TerrainType terrainType, float x, float y, int w, int h) {
        xPosition = x;
        yPosition = y;
        horizontal = w;
        vertical = h;
        spriteSheet = terrain; //update the file that spriteSheet points to
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
        pushMatrix();
        for (int y = 0; y < vertical; y++) {
            for (int x = 0; x < horizontal; x++) {
                int xOffset = 0;
                int yOffset = 15;
                int spriteWidth = spriteSheet.width;
                int spriteHeight = spriteSheet.height;
                if (y == 0) {
                    if (x == 0) {
                        totalHeight += spriteHeight;
                    } else {
                        xOffset = 2;
                        spriteWidth -= 2 + xOffset;
                    }
                    totalWidth += spriteWidth;
                    float xPos = xPosition + x * spriteWidth;
                    beginShape();
                    texture(spriteSheet);
                    vertex(xPos,yPosition, xOffset,0);
                    vertex(xPos+spriteSheet.width-xOffset,yPosition, spriteSheet.width,0);
                    vertex(xPos+spriteSheet.width-xOffset,yPosition+spriteSheet.height, spriteSheet.width,spriteSheet.height);
                    vertex(xPos,yPosition+spriteSheet.height, xOffset,spriteSheet.height);
                    endShape();
                } else {
                    if (x == 0) {
                        spriteHeight -= 2 + yOffset;
                        totalHeight += spriteHeight;
                    } else {
                        xOffset = 2;
                        spriteWidth -= 2 + xOffset;
                        spriteHeight -= 2 + yOffset;
                    }
                    float xPos = xPosition + x * spriteWidth;
                    float yPos = yPosition + y * spriteHeight;
                    beginShape();
                    texture(spriteSheet);
                    vertex(xPos,yPos, xOffset,yOffset);
                    vertex(xPos+spriteSheet.width-xOffset,yPos, spriteSheet.width,yOffset);
                    vertex(xPos+spriteSheet.width-xOffset,yPos+spriteSheet.height-yOffset, spriteSheet.width,spriteSheet.height);
                    vertex(xPos,yPos+spriteSheet.height-yOffset, xOffset,spriteSheet.height);
                    endShape();
                }
            }
        }
        popMatrix();
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
