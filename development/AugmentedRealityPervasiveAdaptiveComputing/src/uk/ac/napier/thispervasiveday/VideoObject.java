package uk.ac.napier.thispervasiveday;

import javax.microedition.khronos.opengles.GL10;

import android.content.Context;
import edu.dhbw.andar.ARObject;


/**
 *
 */
public class VideoObject extends ARObject {
	private Context context;
	private TexturedPlane texturedPlane;
	
	public VideoObject(Context context, String name, String patternName, double markerWidth, double[] markerCenter) {
		super(name, patternName, markerWidth, markerCenter);
		
		this.context = context;
		this.texturedPlane = new TexturedPlane();

	}
	
	/**
	 * Everything drawn here will be drawn directly onto the marker,
	 * as the corresponding translation matrix will already be applied.
	 */
	@Override
	public final void draw(GL10 gl) {
		super.draw(gl);
	    
	    //draw the video
		gl.glScalef(25.0f, 25.0f, 25.0f);
		gl.glEnable(GL10.GL_TEXTURE_2D);
		texturedPlane.draw(gl);

	}
	@Override
	public void init(GL10 gl) {
		texturedPlane.loadGLTexture(gl, this.context);
		System.err.println("Loading textures just once");
	}
}
