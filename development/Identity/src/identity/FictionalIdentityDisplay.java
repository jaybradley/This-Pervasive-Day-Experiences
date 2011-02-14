package identity;

import java.awt.geom.Point2D;
import java.text.DateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Random;
import java.util.UUID;

import processing.core.PApplet;
import processing.core.PFont;
import de.looksgood.ani.AniSequence;

public class FictionalIdentityDisplay {
	PApplet parent;
	public Point2D.Float position = new Point2D.Float();
	PFont font = null;
	public float alpha = 0;
	private float lineHeight = 0;
	private float rightColumnOffset = 50;//240;
	private int nameberLength = 9;
	  
	private String[] occupationsStart = {"Manual", "Systems", "Infrastructure", "Public", "Enterprise", "Hygiene", "Strategic", "Database", "Information", "Domestic"};
	private String[] occupationsMiddle = {"security", "handling", "support", "resource", "project", "logistics", "biology", "systems", "finance", "inventory", "surveillance"};
	private String[] occupationsEnd = {"operative", "operator", "officer", "assistant", "supervisor", "analyst", "administrator", "manager", "controller", "engineer", "technologist"};
	private String occupation = "Not set";
	
	private String nameber = "Not set";
	private String dateOfDeath = "Not set";
	
	public FictionalIdentityDisplay(PApplet parent) {
		this.parent = parent;
		position.x = (float)parent.width * 0.4f;
		position.y = (float)parent.height * 0.4f;
		
		UUID uuid = UUID.randomUUID();
		nameber = uuid.toString().substring(0, nameberLength);
		occupation = occupationsStart[(int)parent.random(0, occupationsStart.length)] + " " + occupationsMiddle[(int)parent.random(0, occupationsMiddle.length)] + " " + occupationsEnd[(int)parent.random(0, occupationsEnd.length)] ;
		
		dateOfDeath = getRandomFutureDate();
		
		//font = parent.loadFont("Abstract-20.vlw"); rubbish
		font = parent.loadFont("RetroVilleNC-20.vlw");
		//font = parent.loadFont("DejaVuSansCondensed-Bold-48.vlw");
	    //font = parent.loadFont("DejaVuSansCondensed-18.vlw");
		
	    parent.textFont(font);
	    lineHeight = (parent.textAscent() + parent.textDescent()) * 1.2f; // plus extra spacing
	}
	
	private String getRandomFutureDate() {
		Calendar cdr = Calendar.getInstance();
		//cdr.set(Calendar.HOUR_OF_DAY, 6);
		//cdr.set(Calendar.MINUTE, 0);
		//cdr.set(Calendar.SECOND, 0);
		cdr.set(Calendar.YEAR, 2030);
		
		long val1=cdr.getTimeInMillis();

		//cdr.set(Calendar.HOUR_OF_DAY, 20);
		//cdr.set(Calendar.MINUTE, 0);
		//cdr.set(Calendar.SECOND, 0);
		cdr.set(Calendar.YEAR, 2100);
		long val2 = cdr.getTimeInMillis();

		Random r = new Random();
		long randomTS = (long)(r.nextDouble()*(val2-val1))+val1;
		Date randomDate = new Date(randomTS);
		
		//System.out.println(d.toString());
		//return "12th August 2063";
		DateFormat df = DateFormat.getDateInstance(DateFormat.LONG);
		
		
		return df.format(randomDate);
	}
	
	public void draw() {
		// draw text
		parent.textFont(font);
		//PApplet.println("alpha is " + alpha);
		parent.fill(255, 255, 255, alpha);
	    /*parent.text("Your identity", position.x, position.y - (lineHeight * 2));
	    parent.text("Nameber", position.x, position.y);
	    parent.text(nameber, position.x + rightColumnOffset, position.y);
	    parent.text("Occupation", position.x, position.y + lineHeight);
	    parent.text(occupation, position.x + rightColumnOffset, position.y + lineHeight);
	    parent.text("Date of death", position.x, position.y + (lineHeight * 2));
	    parent.text(dateOfDeath, position.x + rightColumnOffset, position.y + (lineHeight * 2));*/
		//parent.text("Your identity", position.x, position.y - (lineHeight * 2));
	    parent.text("Nameber", position.x, position.y);
	    parent.text(nameber, position.x + rightColumnOffset, position.y + lineHeight);
	    parent.text("Occupation", position.x, position.y +  + (lineHeight * 2));
	    parent.text(occupation, position.x + rightColumnOffset, position.y  + (lineHeight * 3));
	    parent.text("Date of death", position.x, position.y  + (lineHeight * 4));
	    parent.text(dateOfDeath, position.x + rightColumnOffset, position.y + (lineHeight * 5));
	}
}
