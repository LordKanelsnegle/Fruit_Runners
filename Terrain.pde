public class Terrain extends Object {
    int columns;
    int rows;
    Boolean isPillar;
    public Terrain(TerrainType terrainType, float x, float y, int w, int h) {
        xPosition = x;
        yPosition = y;
        Width = w;
        Height = h;
        //isPillar = pillar;
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
        columns = Width / spriteSheet.width; //calculate the number of columns needed
        rows = Height / spriteSheet.height; //calculate the number of rows needed
    }
    
    //bottom tiles are 33 tall (trim 13 from top), assuming no sides trimmed
    //trim 2 pixels on any side that has another tile near it
    public void redraw() {
        
        for (int x = 0; x < columns; x++) { //if first of row, keep left wall, if last of row, keep right wall, if first row, keep top wall, if last row, keep bottom wall
            for (int y = 0; y < rows; y++) {
                /*if (x == 0) {
                    if (y == 0) {
                        image(spriteSheet.get(0,0,46,46), xPosition, yPosition);
                    } else if (y == columns) {
                        image(spriteSheet.get(2,0,46,46), xPosition, yPosition);
                    } else {
                        image(spriteSheet.get(2,0,44,46), xPosition, yPosition);
                    }
                } else {
                    if (y == 0) {
                        image(spriteSheet.get(0,2,46,44), xPosition, yPosition);
                    } else if (y == columns) {
                        image(spriteSheet.get(2,2,46,44), xPosition, yPosition);
                    } else {
                        image(spriteSheet.get(2,2,44,44), xPosition, yPosition);
                    }
                }*/
                image(spriteSheet, xPosition + x * spriteSheet.width, yPosition + y * spriteSheet.height);
                //image(spriteSheet, xPosition + Width - 48, yPosition + y * spriteSheet.height);
            }
            //image(spriteSheet, xPosition + x * spriteSheet.width, yPosition + Height - 48);
        }
    }
}

public enum TerrainType {
    GRASS,
    CARAMEL,
    COTTONCANDY
}
