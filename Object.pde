//This is a base class for everything in the level as the player, enemies, obstacles and terrain will
//  all need the following properties and function (since they all need to be redrawable to appear in
//  front of the background and they all have position and dimension properties)
public class Object {
    float xPosition;
    float yPosition;
    PImage spriteSheet;
    public int Width;
    public int Height;
    public void redraw(){}
    public void checkCollisions(){}
}
