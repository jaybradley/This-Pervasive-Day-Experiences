package uk.ac.napier.thispervasiveday;

import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;
import java.nio.ShortBuffer;

import javax.microedition.khronos.opengles.GL10;

import edu.dhbw.andar.ARObject;
import edu.dhbw.andar.pub.SimpleBox;
import edu.dhbw.andar.util.GraphicsUtil;

/**
 * An example of an AR object being drawn on a marker.
 * @author tobi
 *
 */
public class VideoObject extends ARObject {

	private float angleOfRotation = 0.0f;
	FloatBuffer vertexBuffer;
	private FloatBuffer mat_flash;
	private FloatBuffer mat_ambient;
	private FloatBuffer mat_flash_shiny;
	private FloatBuffer mat_diffuse;
	
	
	private float vertices[] = {
  	      -10.0f,  10.0f, 0.0f,  // 0, Top Left
  	      -10.0f, -10.0f, 0.0f,  // 1, Bottom Left
  	       10.0f, -10.0f, 0.0f,  // 2, Bottom Right
  	       10.0f,  10.0f, 0.0f,  // 3, Top Right
  	};
	
	private short[] indices = { 0, 1, 2, 0, 2, 3 };
	private ShortBuffer indexBuffer;
	
	
	public VideoObject(String name, String patternName,
			double markerWidth, double[] markerCenter) {
		super(name, patternName, markerWidth, markerCenter);
		float   mat_ambientf[]     = {1f, 0, 0.0f, 1.0f};
		float   mat_flashf[]       = {1f, 0, 0.0f, 1.0f};
		float   mat_diffusef[]       = {1f, 0.0f, 0f, 1.0f};
		float   mat_flash_shinyf[] = {50.0f};

		mat_ambient = GraphicsUtil.makeFloatBuffer(mat_ambientf);
		mat_flash = GraphicsUtil.makeFloatBuffer(mat_flashf);
		mat_flash_shiny = GraphicsUtil.makeFloatBuffer(mat_flash_shinyf);
		mat_diffuse = GraphicsUtil.makeFloatBuffer(mat_diffusef);
		
		// a float is 4 bytes, therefore we multiply the number if vertices with 4.
    	ByteBuffer vbb = ByteBuffer.allocateDirect(vertices.length * 4);
    	vbb.order(ByteOrder.nativeOrder());
    	vertexBuffer = vbb.asFloatBuffer();
    	vertexBuffer.put(vertices);
    	vertexBuffer.position(0);
    	
    	ByteBuffer ibb = ByteBuffer.allocateDirect(indices.length * 2);
		ibb.order(ByteOrder.nativeOrder());
		indexBuffer = ibb.asShortBuffer();
		indexBuffer.put(indices);
		indexBuffer.position(0);
	}
//	public VideoObject(String name, String patternName,
//			double markerWidth, double[] markerCenter, float[] customColor) {
//		super(name, patternName, markerWidth, markerCenter);
//		float   mat_flash_shinyf[] = {50.0f};
//
//		mat_ambient = GraphicsUtil.makeFloatBuffer(customColor);
//		mat_flash = GraphicsUtil.makeFloatBuffer(customColor);
//		mat_flash_shiny = GraphicsUtil.makeFloatBuffer(mat_flash_shinyf);
//		mat_diffuse = GraphicsUtil.makeFloatBuffer(customColor);
//	
//		// a float is 4 bytes, therefore we multiply the number if vertices with 4.
//    	ByteBuffer vbb = ByteBuffer.allocateDirect(vertices.length * 4);
//    	vbb.order(ByteOrder.nativeOrder());
//    	vertexBuffer = vbb.asFloatBuffer();
//    	vertexBuffer.put(vertices);
//    	vertexBuffer.position(0);
//	}
	
	
	/**
	 * Everything drawn here will be drawn directly onto the marker,
	 * as the corresponding translation matrix will already be applied.
	 */
	@Override
	public final void draw(GL10 gl) {
		super.draw(gl);
		
		gl.glMaterialfv(GL10.GL_FRONT_AND_BACK, GL10.GL_SPECULAR,mat_flash);
		gl.glMaterialfv(GL10.GL_FRONT_AND_BACK, GL10.GL_SHININESS, mat_flash_shiny);	
		gl.glMaterialfv(GL10.GL_FRONT_AND_BACK, GL10.GL_DIFFUSE, mat_diffuse);	
		gl.glMaterialfv(GL10.GL_FRONT_AND_BACK, GL10.GL_AMBIENT, mat_ambient);

	    //draw cube
		gl.glColor4f(0.5f, 0.5f, 1.0f, 1.0f); // 0x8080FFFF
	    //gl.glTranslatef( 0.0f, 0.0f, 12.5f );
	    
	    //angleOfRotation += 10.0f;
	    //gl.glRotatef(angleOfRotation, angleOfRotation + 10.0f, angleOfRotation + 40.0f, 1.0f);
	    
	    //draw the video
	    
	    gl.glEnableClientState(GL10.GL_VERTEX_ARRAY);

    	
    	gl.glVertexPointer(3, GL10.GL_FLOAT, 0, vertexBuffer);
    	//gl.glDrawArrays(GL10.GL_TRIANGLE_STRIP, 0, 4);
    	gl.glDrawElements(GL10.GL_TRIANGLES, indices.length, GL10.GL_UNSIGNED_SHORT, indexBuffer);
    	gl.glDisableClientState(GL10.GL_VERTEX_ARRAY);
	}
	@Override
	public void init(GL10 gl) {
		
	}
}
