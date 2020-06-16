public class Terrain extends Object {
   public Terrain() {
       objects.add(this);
   }
   
   public void redraw() {
     
   }
   
   public void checkCollisions() {
       //if player on this class, set player.doubleJumped = false and player.falling = false, otherwise set player.falling to true
       //if player beside this class, set player.movingLeft/movingRight to false (ignore wall holding for now)
   }
}
