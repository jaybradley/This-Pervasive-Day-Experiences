package identity;

import java.awt.Rectangle;

import processing.core.*;

public class DetectedFace {

	PImage faceImage;
	public int frameCreated = 0;
	Identity parent;
	Rectangle faceExtent;
	public int x = 0;
	public int y = 0;
	public float alpha = 0.0f;
	public float scale = 1.0f;
	
	public DetectedFace(Identity parent, Rectangle face, int frameCount, PImage src) {
		this.parent = parent;
		faceImage = parent.createImage(face.width, face.height, PApplet.ARGB);
		faceExtent = face;
		x = (parent.width / 2);// - (faceImage.width / 2);
		y = (parent.height / 2);// - (faceImage.height / 2);
    	frameCreated = frameCount;
    	
    	//faceImage.copy(src, faceExtent.x, faceExtent.y, faceExtent.width, faceExtent.height, ((faceImage.width / 2) - (faceExtent.width / 2)), ((faceImage.height / 2) - (faceExtent.height / 2)), faceExtent.width * 2, faceExtent.height * 2);
    	faceImage.copy(src, faceExtent.x, faceExtent.y, faceExtent.width, faceExtent.height, 0, 0, faceExtent.width, faceExtent.height);
		// filer the image in some way
    	faceImage.filter(PApplet.POSTERIZE, 3);
    	//faceImage.filter(PApplet.THRESHOLD, 0.4f);
    	
    	faceImage.filter(PApplet.GRAY);
    	
    	//faceImage.filter(PApplet.INVERT);
    	faceImage.filter(PApplet.BLUR, 2);
	}
	
	public void draw() {
		parent.tint(255, 200, 200, alpha);
		parent.image(faceImage, x, y, faceImage.width * scale, faceImage.height * scale);
	}
	
	public void animationEnded() {
		parent.animationEnded();
	}
}