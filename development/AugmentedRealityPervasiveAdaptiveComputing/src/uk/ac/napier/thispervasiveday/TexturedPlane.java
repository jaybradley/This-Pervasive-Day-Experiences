package uk.ac.napier.thispervasiveday;


import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.FloatBuffer;

import javax.microedition.khronos.opengles.GL10;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.opengl.GLUtils;

public class TexturedPlane {

	/** The buffer holding the vertices */
	private FloatBuffer vertexBuffer;
	/** The buffer holding the texture coordinates */
	private FloatBuffer textureBuffer;
	/** The buffer holding the indices */
	private ByteBuffer indexBuffer;
	
	/** Our texture pointer */
	private int numberOfFrames = 126;
	//private int numberOfFrames = 2;
	private int[] textures = new int[numberOfFrames];
	private int currentFrame = 0;
	
	/** 
	 * The initial vertex definition
	 * 
	 * Note that each face is defined, even
	 * if indices are available, because
	 * of the texturing we want to achieve 
	 */	
    private float vertices[] = {
    					//Vertices according to faces
			    		-1.0f, -1.0f, 1.0f, //Vertex 0
			    		1.0f, -1.0f, 1.0f,  //v1
			    		-1.0f, 1.0f, 1.0f,  //v2
			    		1.0f, 1.0f, 1.0f,   //v3
											};
    
    /** The initial texture coordinates (u, v) */	
    private float texture[] = {    		
			    		//Mapping coordinates for the vertices
			    		0.0f, 0.0f,
			    		0.0f, 1.0f,
			    		1.0f, 0.0f,
			    		1.0f, 1.0f, };
        
    /** The initial indices definition */	
    private byte indices[] = {
    					//Faces definition
			    		0,1,3, 0,3,2, 			//Face front
			    		};

	/**
	 * The Cube constructor.
	 * 
	 * Initiate the buffers.
	 */
	public TexturedPlane() {
		//
		ByteBuffer byteBuf = ByteBuffer.allocateDirect(vertices.length * 4);
		byteBuf.order(ByteOrder.nativeOrder());
		vertexBuffer = byteBuf.asFloatBuffer();
		vertexBuffer.put(vertices);
		vertexBuffer.position(0);

		//
		byteBuf = ByteBuffer.allocateDirect(texture.length * 4);
		byteBuf.order(ByteOrder.nativeOrder());
		textureBuffer = byteBuf.asFloatBuffer();
		textureBuffer.put(texture);
		textureBuffer.position(0);

		//
		indexBuffer = ByteBuffer.allocateDirect(indices.length);
		indexBuffer.put(indices);
		indexBuffer.position(0);
	}

	/**
	 * The object own drawing function.
	 * Called from the renderer to redraw this instance
	 * with possible changes in values.
	 * 
	 * @param gl - The GL Context
	 */
	public void draw(GL10 gl) {
		//Bind our only previously generated texture in this case
		//gl.glBindTexture(GL10.GL_TEXTURE_2D, textures[0]); // This is the texture that will need to be updated with each video frame
		System.err.println("Using texture: " + Integer.toString(currentFrame));
		gl.glBindTexture(GL10.GL_TEXTURE_2D, textures[currentFrame]); // This is the texture that will need to be updated with each video frame
		currentFrame += 10;
		if(currentFrame >= numberOfFrames) {
			currentFrame = 0;
		}
		//Point to our buffers
		gl.glEnableClientState(GL10.GL_VERTEX_ARRAY);
		gl.glEnableClientState(GL10.GL_TEXTURE_COORD_ARRAY);

		//Set the face rotation
		gl.glFrontFace(GL10.GL_CCW);
		
		//Enable the vertex and texture state
		gl.glVertexPointer(3, GL10.GL_FLOAT, 0, vertexBuffer);
		gl.glTexCoordPointer(2, GL10.GL_FLOAT, 0, textureBuffer);
		
		//Draw the vertices as triangles, based on the Index Buffer information
		gl.glDrawElements(GL10.GL_TRIANGLES, indices.length, GL10.GL_UNSIGNED_BYTE, indexBuffer);
		
		//Disable the client state before leaving
		gl.glDisableClientState(GL10.GL_VERTEX_ARRAY);
		gl.glDisableClientState(GL10.GL_TEXTURE_COORD_ARRAY);
	}
	
	/**
	 * Load the textures
	 * 
	 * @param gl - The GL Context
	 * @param context - The Activity context
	 */
	public void loadGLTexture(GL10 gl, Context context) {
		//textures[0] = loadTexture(gl, context, "/sdcard/ThisPervasiveDay/images/eye.bmp");
		//textures[1] = loadTexture(gl, context, "/sdcard/ThisPervasiveDay/images/eye2.bmp");
		//textures[0] = loadTexture(gl, context, "/sdcard/ThisPervasiveDay/images/frames/frame1.png");
		//textures[1] = loadTexture(gl, context, "/sdcard/ThisPervasiveDay/images/frames/frame2.png");
		String filename = "";
		for(int frameNumber = 1; frameNumber <= numberOfFrames; frameNumber++) {
			filename = "/sdcard/ThisPervasiveDay/images/frames/frame" + Integer.toString(frameNumber) + ".png";
			System.err.println("Loading: " + filename);
			textures[frameNumber - 1] = loadTexture(gl, context, filename);
			System.err.println("Texture: " + Integer.toString(frameNumber -1) + " filled");
		}
		
	}
	
	// Get a new texture id:
	private static int newTextureID(GL10 gl) {
	    int[] temp = new int[1];
	    gl.glGenTextures(1, temp, 0);
	    return temp[0];        
	}

	// Will load a texture out of a drawable resource file, and return an OpenGL texture ID:
	private int loadTexture(GL10 gl, Context context, String filename) {
	    
	    // In which ID will we be storing this texture?
	    int id = newTextureID(gl);
	    
	    // We need to flip the textures vertically:
	    Matrix flip = new Matrix();
	    flip.postScale(1f, -1f);
	    
	    // This will tell the BitmapFactory to not scale based on the device's pixel density:
	    // (Thanks to Matthew Marshall for this bit)
	    BitmapFactory.Options opts = new BitmapFactory.Options();
	    opts.inScaled = false;
	    
	    // Load up, and flip the texture:
	    //Bitmap temp = BitmapFactory.decodeResource(context.getResources(), resource, opts);
	    Bitmap temp = BitmapFactory.decodeFile(filename, opts);
	    Bitmap bmp = Bitmap.createBitmap(temp, 0, 0, temp.getWidth(), temp.getHeight(), flip, true);
	    temp.recycle();
	    
	    gl.glBindTexture(GL10.GL_TEXTURE_2D, id);
	    
	    // Set all of our texture parameters:
	    gl.glTexParameterf(GL10.GL_TEXTURE_2D, GL10.GL_TEXTURE_MIN_FILTER, GL10.GL_LINEAR_MIPMAP_NEAREST);
	    gl.glTexParameterf(GL10.GL_TEXTURE_2D, GL10.GL_TEXTURE_MAG_FILTER, GL10.GL_LINEAR_MIPMAP_NEAREST);
	    gl.glTexParameterf(GL10.GL_TEXTURE_2D, GL10.GL_TEXTURE_WRAP_S, GL10.GL_REPEAT);
	    gl.glTexParameterf(GL10.GL_TEXTURE_2D, GL10.GL_TEXTURE_WRAP_T, GL10.GL_REPEAT);
	    
	    // Generate, and load up all of the mipmaps:
	    for(int level=0, height = bmp.getHeight(), width = bmp.getWidth(); true; level++) {
	        // Push the bitmap onto the GPU:
	        GLUtils.texImage2D(GL10.GL_TEXTURE_2D, level, bmp, 0);
	        
	        // We need to stop when the texture is 1x1:
	        if(height==1 && width==1) break;
	        
	        // Resize, and let's go again:
	        width >>= 1; height >>= 1;
	        if(width<1)  width = 1;
	        if(height<1) height = 1;
	        
	        Bitmap bmp2 = Bitmap.createScaledBitmap(bmp, width, height, true);
	        bmp.recycle();
	        bmp = bmp2;
	    }
	    
	    bmp.recycle();
	    
	    return id;
	}
}
