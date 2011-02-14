package identity;

import java.awt.Rectangle;
import java.awt.geom.Point2D;

import processing.core.PApplet;
import processing.core.PFont;
import de.looksgood.ani.AniSequence;

public class ExplanationText {
	PApplet parent;
	public Point2D.Float position = new Point2D.Float();
	AniSequence animation = null;
	PFont font = null;
	public int alpha = 0;
	String content = "Not set";
	String fontName = "DistroMix-32.vlw";
		
	public ExplanationText(PApplet parent, String content, float xPos, float yPos, String fontName) {
		this.parent = parent;
		position.x = (float)xPos;
		position.y = (float)yPos;
		this.content = content;
		this.fontName = fontName;
		
		font = parent.loadFont(fontName);
		//font = parent.loadFont("DejaVuSansCondensed-Bold-48.vlw");
	    //font = parent.loadFont("DejaVuSansCondensed-18.vlw");
	    parent.textFont(font);
	}
	
public void draw() {
		// draw text
		parent.textFont(font);
		parent.fill(255, 255, 255, alpha);
	    parent.text(content, position.x, position.y);
	}
}
