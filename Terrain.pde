public class Terrain extends Object {
    int columns;
    int rows;
    public Terrain(TerrainType terrainType, float x, float y, int w, int h) {
        xPosition = x;
        yPosition = y;
        Width = w;
        Height = h;
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
    
    public void redraw() {
        for (int x = 0; x < columns; x++) {
            for (int y = 0; y < rows; y++) {
                image(spriteSheet, xPosition + x * spriteSheet.width, yPosition + y * spriteSheet.height);
                //image(spriteSheet, xPosition + Width - 48, yPosition + y * spriteSheet.height);
            }
            //image(spriteSheet, xPosition + x * spriteSheet.width, yPosition + Height - 48);
        }
    }
    
    public void checkCollisions() {
        if ((player.xPosition > xPosition - 0.75 * player.Width && player.xPosition + 0.35 * player.Width <= xPosition + Width) && (player.yPosition + player.Height > yPosition && player.yPosition + player.Height < yPosition + Height)) {
            player.yPosition = yPosition - player.Height;
        }
    }
}

public enum TerrainType {
    GRASS,
    CARAMEL,
    COTTONCANDY
}
