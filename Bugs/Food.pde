class Food {
 
  float x, y, amount;
  
  public Food() {
    
  }
  
  public Food(float x, float y, float amount) {
   this.x = x;
   this.y = y;
   this.amount = amount;
  }
  
  void show(float scale) {
   stroke(0);
   strokeWeight(amount / 15.0 * scale);
   fill(200, 50, 150);
   ellipseMode(CENTER);
   ellipse(this.x, this.y, this.amount * scale, this.amount * scale);
  }
  
}