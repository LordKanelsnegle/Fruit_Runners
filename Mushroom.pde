public class Mushroom extends Object {
    public Mushroom() {
        objects.add(this);
    }
    
    public void redraw() {
      
    }
    
    public void checkCollisions() { //collisions will be detected by seeing if player x and y are within this class's x and y
        //if PLAYER above, call player.jump() and kill self
        //if PLAYER on either side, call player.die()
    }
}
