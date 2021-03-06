package uk.ac.napier.thispervasiveday;

import android.os.Bundle;
import edu.dhbw.andar.ARToolkit;
import edu.dhbw.andar.AndARActivity;
import edu.dhbw.andar.exceptions.AndARException;
import uk.ac.napier.thispervasivedaycameratexture.R;

public class thispervasiveday extends AndARActivity {
    
	//CustomObject someObject;
	VideoObject testVideoObject;
	CustomObject cubeObject;
	TexturedCubeObject texturedCubeObject;
	ARToolkit artoolkit;
	
	/** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        CustomRenderer renderer = new CustomRenderer();//optional, may be set to null
		super.setNonARRenderer(renderer);//or might be omitted
		try {
			//register a object for each marker type
			artoolkit = super.getArtoolkit();
			
			
//			testVideoObject = new VideoObject("test", "patt.hiro", 80.0, new double[]{0,0});
//			artoolkit.registerARObject(testVideoObject);
//			testVideoObject = new VideoObject("test", "android.patt", 80.0, new double[]{0,0});
//			artoolkit.registerARObject(testVideoObject);
//			testVideoObject = new VideoObject("test", "barcode.patt", 80.0, new double[]{0,0});
//			artoolkit.registerARObject(testVideoObject);
			
//			texturedCubeObject = new TexturedCubeObject(this, "test", "patt.hiro", 80.0, new double[]{0,0});
//			artoolkit.registerARObject(texturedCubeObject);

//			texturedCubeObject = new TexturedCubeObject(this, "test", "android.patt", 80.0, new double[]{0,0});
		//	artoolkit.registerARObject(texturedCubeObject);

			//			texturedCubeObject = new TexturedCubeObject(this, "test", "barcode.patt", 80.0, new double[]{0,0});
//			artoolkit.registerARObject(texturedCubeObject);
			
			//testVideoObject = new VideoObject(this, "test", "patt.hiro", 80.0, new double[]{0,0});
			//artoolkit.registerARObject(testVideoObject);
			
			//testVideoObject = new VideoObject(this, "test", "android.patt", 80.0, new double[]{0,0});
			//artoolkit.registerARObject(testVideoObject);
			
			//testVideoObject = new VideoObject(this, "test", "barcode.patt", 80.0, new double[]{0,0});
			//artoolkit.registerARObject(testVideoObject);

			
			
			
			
			// animated textured plane
			//testVideoObject = new VideoObject(this, "test", "android.patt", 80.0, new double[]{0,0});
			//artoolkit.registerARObject(testVideoObject);
			
			// cube with textured sides
			//texturedCubeObject = new TexturedCubeObject(this, "test", "android.patt", 80.0, new double[]{0,0});
			//artoolkit.registerARObject(texturedCubeObject);
			
			// cube with textured camera sides
			cubeObject = new CustomObject("test", "android.patt", 80.0, new double[]{0,0});
			artoolkit.registerARObject(cubeObject);
			
		} catch (AndARException ex){
			//handle the exception, that means: show the user what happened
			System.out.println("AndARException Exception: " + ex.getMessage());
		}		
		startPreview();
	}
	
	/**
	 * Inform the user about exceptions that occurred in background threads.
	 * This exception is rather severe and can not be recovered from.
	 * TODO Inform the user and shut down the application.
	 */
	@Override
	public void uncaughtException(Thread thread, Throwable ex) {
		System.err.println("AndAR EXCEPTION: " + ex.getMessage());
		//Log.e("AndAR EXCEPTION", ex.getMessage());
		finish();
	}
}