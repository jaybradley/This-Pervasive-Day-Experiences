package identity;

import processing.core.PApplet;
import hypermedia.video.*;
import java.awt.Rectangle;
import processing.core.PImage;

import de.looksgood.ani.*;


public class ThisPervasiveDayIdentity extends PApplet {

	OpenCV opencv;

	DetectedFace face = null;
		
	PImage bodyImage;
	BrownianText idleMessage;
	
	int usedForDetectingEndOfAnimation = 0;
	
	// informational animations
	AniSequence faceAnimation = null;
	AniSequence informationAnimation = null;
	AniSequence openingStatementAnimation = null;
	AniSequence closingStatementAnimation = null;
	AniSequence fictionalIdentityAnimation = null;
	
	ExplanationText openingStatement = null;
	ExplanationText closingStatement = null;
	FictionalIdentityDisplay fictionalIdentity = null;
	
	PImage background;
	PImage screenShot;
	
	CellEffect cellEffect;
	
	SaveToWeb saveToWeb = null;
	boolean saveFrameNow = false;
	
	public void setup() {
		
		frameRate(30); // can be left out
	    //size( 920, 540, OPENGL);
	    size(1920, 1080, OPENGL);
		

		smooth();
		noStroke();
		imageMode(CENTER);
		//textMode(CENTER); otherwise it's the top-left corner
		Ani.init(this);
		Ani.noAutostart();
		
	    opencv = new OpenCV( this );
	    opencv.capture( width / 2, height /2); // open video stream
	    
	    opencv.read();
	    opencv.flip(OpenCV.FLIP_HORIZONTAL);
	    
	    // Maybe able to speed things up by cutting out the edges of the frame
	    //opencv.ROI((int)(width * 0.1), (int)(height * 0.1), (int)(width * 0.9), (int)(height * 0.9));

	    //opencv.cascade( OpenCV.CASCADE_FRONTALFACE_ALT );  // load detection description, here-> front face detection : "haarcascade_frontalface_alt.xml"
	    //opencv.cascade( OpenCV.CASCADE_PROFILEFACE);
	    opencv.cascade(OpenCV.CASCADE_FRONTALFACE_DEFAULT);
	    	    
	    idleMessage = new BrownianText(this, width / 2, height * 0.2f);
	    //openingStatement = new ExplanationText(this, "Have we thought through\nthe implications of the\ntechnologies we are\ndeploying?", width * 0.1f, height * 0.2f, "DistroMix-62.vlw");
	    openingStatement = new ExplanationText(this, "You have been\nrecognised and your\nidentity has been\nassigned ...", width * 0.55f, height * 0.3f, "Distro-82.vlw");
	    String closingStatementText = "The system is always on and ever present.";
	    closingStatement = new ExplanationText(this, closingStatementText, width * 0.25f, height * 0.95f, "Distro-82.vlw");
	    
	    //background = loadImage("10.png");
	    background = loadImage("FaceDetectionBackground1.jpg");
	    screenShot = createImage(width, height, RGB);
	    
	    saveToWeb = new SaveToWeb(this, "http://companions.napier.ac.uk/idoc/fictional_identity");
	    								 
	    
	    cellEffect = new CellEffect(this);
	}

	public void draw() {
		//println();
		//println("Frame rate is " + frameRate);
		
		// grab a new frame
	    // or grab a frame only every other frame
		//if(frameCount % 10 == 0) {

		if(face == null) {
			//PApplet.println("Looking for faces");
			
			opencv.read();
		    opencv.flip(OpenCV.FLIP_HORIZONTAL);
		    // detects faces on the last read frame
		    //Rectangle[] faces = opencv.detect(1.6f, 8, OpenCV.HAAR_DO_CANNY_PRUNING | OpenCV.HAAR_FIND_BIGGEST_OBJECT, 50, 200);
		    Rectangle[] faces = opencv.detect(1.4f, 4, OpenCV.HAAR_DO_CANNY_PRUNING | OpenCV.HAAR_FIND_BIGGEST_OBJECT, 20, 20);

		    //println("Number of faces: " + faces.length);
	    	
		    if(faces.length > 0){
		    	println("New face");
		    	face = new DetectedFace(this, faces[0], frameCount, opencv.image()); // just take the first face detected
		    	faces = null;
		    }
	    
		    // play idle animation
	    	//background(0);
		    tint(255, 255, 255, 255); // display the background image at full alpha - i.e. no tint
	    	image(background, width / 2, height / 2, width, height);
	    	//image(opencv.image(), 0, 0);
	    	cellEffect.draw();
			idleMessage.draw();
	    
		} else if(face != null) { // if a face has been detected
			//PApplet.println("Showing face animation");
			
			if(informationAnimation == null) {
				
				fictionalIdentity = new FictionalIdentityDisplay(this); // create a new identity each time
				
				// setup the animations
				informationAnimation = new AniSequence(this);
				informationAnimation.beginSequence();
				
				// flash face large on the screen
				informationAnimation.beginStep();
				informationAnimation.add(Ani.to(face, 0.2f, "alpha", 230.0f, Ani.CUBIC_IN)); // show face
				informationAnimation.add(Ani.to(face, 0.2f, "scale", 1.6f, Ani.CUBIC_IN)); // scale face to be bigger
				informationAnimation.add(Ani.to(this, 3f, 0f, "usedForDetectingEndOfAnimation", 0f, Ani.LINEAR)); // hold then end
				informationAnimation.endStep();
				
				// show opening statement and move face to left
				informationAnimation.add(Ani.to(face, 2f, "x", 500, Ani.QUAD_IN)); // move face to the left
				informationAnimation.add(Ani.to(openingStatement, 0f, 0f, "alpha", 0, Ani.CUBIC_OUT)); // dummy to blank the opening text
				informationAnimation.beginStep();
				informationAnimation.add(Ani.to(openingStatement, 2f, "alpha", 200, Ani.CUBIC_OUT)); // show opening statement
				informationAnimation.add(Ani.to(openingStatement, 1f, 5f, "alpha", 0f, Ani.CUBIC_OUT)); // hide opening statement
				informationAnimation.endStep();
				
				// show face
				//informationAnimation.add(Ani.to(face, 1f, "alpha", 230.0f, Ani.CUBIC_OUT)); // show face
				
				// move the face and show fictional identity
				informationAnimation.beginStep();
				//informationAnimation.add(Ani.to(face, 2f, "scale", 2, Ani.QUAD_IN)); // scale face to be bigger
				informationAnimation.add(Ani.to(fictionalIdentity, 1f, 1f, "alpha", 200f, Ani.CUBIC_IN)); // show fictional identity
				informationAnimation.endStep();
				
				// show for a while and then fade out face
				informationAnimation.beginStep();
				informationAnimation.add(Ani.to(this, 0f, 0f, "usedForDetectingEndOfAnimation", 0f, Ani.LINEAR, "onEnd:setGrabScreenShotForWebServer")); // hold then end
				informationAnimation.add(Ani.to(fictionalIdentity, 2f, 4f, "alpha", 0f, Ani.CUBIC_OUT)); // hold then hide fictional identity
				informationAnimation.add(Ani.to(face, 2f, 4f, "alpha", 0.0f, Ani.CUBIC_OUT)); // hold then hide face
				informationAnimation.endStep();
				
				// show closing statement
				informationAnimation.add(Ani.to(closingStatement, 2f, "alpha", 200f, Ani.CUBIC_OUT)); // show closingStatement
				informationAnimation.add(Ani.to(closingStatement, 1f, 3f, "alpha", 0f, Ani.CUBIC_OUT)); // hold closingStatement for some time and then hide it
				
				informationAnimation.add(Ani.to(this, 0f, 2f, "usedForDetectingEndOfAnimation", 1f, Ani.LINEAR, "onEnd:animationEnded")); // hold then end

				informationAnimation.endSequence();
				
				informationAnimation.start();
				
				
			}

			// draw the information animations
			//background(0);
			tint(255, 255, 255, 255); // display the background image at full alpha - i.e. no tint
			image(background, width / 2, height / 2, width, height);
			openingStatement.draw();
			closingStatement.draw();
		    face.draw();
		    fictionalIdentity.draw();
		    
		}
	
		if(saveFrameNow == true) {
			grabScreenShotForWebServer();
			saveFrameNow = false;
		}
		
	}
	
	public void animationEnded() {
		PApplet.println("Animation ended restart looking for faces");
		face = null;
		informationAnimation = null;
				
		openingStatement.alpha = 0;
		closingStatement.alpha = 0;
		
		// Restart the opencv capturing process. Otherwise it is still reading from old video for some reason.
		// This introduces a delay but needs to be done.
		opencv.capture( width / 2, height /2); // open video stream. Half size again.
		
	}

	public void setGrabScreenShotForWebServer() {
		saveFrameNow = true;
	}
	
	public void grabScreenShotForWebServer() {
		PApplet.println("Should grab screen shot now");
		saveFrame("fictionalIdentityScreenshots/##############.jpg");
		loadPixels();
		screenShot.pixels = pixels;
		screenShot.updatePixels();
		saveToWeb.saveJPG("", "ignoreFolderName", screenShot); // filename is made up from the current date and time
		//saveFrame();
	}
	
	public static void main(String _args[]) {
		PApplet.main(new String[] { identity.ThisPervasiveDayIdentity.class.getName() });
	}
	
	public void stop() {
	    opencv.stop();
	    super.stop();
	}

}