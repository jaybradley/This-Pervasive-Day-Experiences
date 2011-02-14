package identity;


import java.awt.Rectangle;
import java.awt.geom.Point2D;


import processing.core.*;
import de.looksgood.ani.*;

public class BrownianText {
	
	PApplet parent;
	public Point2D.Float position = new Point2D.Float();
	Rectangle bounds = new Rectangle();
	AniSequence brownian = null;
	AniSequence flicker = null;
	PFont font = null;
	float alpha = 240.0f;
	
	public BrownianText(PApplet parent, float xPos, float yPos) {
		this.parent = parent;
		position.x = (float)xPos;
		position.y = (float)yPos;
		bounds.x = (int)position.x - 4;
		bounds.y = (int)position.y - 4;
		bounds.width = 8;
		bounds.height = 8;
		
		//font = parent.loadFont("DejaVuSansCondensed-Bold-48.vlw");
	    font = parent.loadFont("DejaVuSansCondensed-18.vlw");
	    font = parent.loadFont("DistroMix-32.vlw");
	    
	    parent.textFont(font);
		
		setNewBrownianTarget();
		setNewFlicker();
	}
	
	public void setNewBrownianTarget() {
		PApplet.println("setNewBrownianTarget");
		brownian = new AniSequence(parent);
		
		float newX = PApplet.min(PApplet.max(parent.random(position.x - 50, position.x + 50), parent.width * 0.2f), parent.width * 0.8f);
		float newY = PApplet.min(PApplet.max(parent.random(position.y - 10, position.y + 10), parent.height * 0.2f), parent.height * 0.8f);
		
		
		brownian.beginSequence();
		
		brownian.beginStep();
		brownian.add(Ani.to(position, 0.5f, "x", newX, Ani.EXPO_IN));
		brownian.add(Ani.to(position, 0.5f, "y", newY, Ani.LINEAR));
		brownian.endStep();
		brownian.endSequence();
		
		brownian.start();
		
		
	}
	
	private void setNewFlicker() {
		flicker = new AniSequence(parent);
		
		flicker.beginSequence();
		
		flicker.beginStep(); // go low
		flicker.add(Ani.to(this, parent.random(0.0001f, 0.15f), "alpha", parent.random(40, 150), Ani.LINEAR));
		flicker.endStep();
		
		flicker.beginStep(); // go high
		flicker.add(Ani.to(this, parent.random(0.0001f, 0.15f), "alpha", parent.random(200, 255), Ani.LINEAR));
		flicker.endStep();

		flicker.endSequence();
		
		flicker.start();
		
	}
	
	public void draw() {
		
		if(brownian.isEnded()) {
			setNewBrownianTarget();
		}
		
		if(flicker.isEnded()) {
			setNewFlicker();
		}
		
		// translations
		//parent.pushMatrix();
		//parent.popMatrix();
		
		// draw text
		//alpha -= 1;
		parent.textFont(font);
		parent.fill(255, 255, 255, alpha);
	    parent.text("Identity", position.x, position.y);
	}
	


}