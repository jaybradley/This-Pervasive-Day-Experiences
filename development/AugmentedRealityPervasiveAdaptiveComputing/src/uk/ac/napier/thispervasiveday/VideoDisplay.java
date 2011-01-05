package uk.ac.napier.thispervasiveday;

import java.io.IOException;

import android.content.Context;
import android.hardware.Camera;
import android.view.SurfaceHolder;
import android.view.SurfaceView;

class VideoDisplay extends SurfaceView implements SurfaceHolder.Callback {
	SurfaceHolder mHolder;
	Camera mCamera;

	VideoDisplay(Context context) {
		super(context);

		// Install a SurfaceHolder.Callback so we get notified when the
		// underlying surface is created and destroyed.
		mHolder = getHolder();
		mHolder.addCallback(this);
		mHolder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);
	}

	public void surfaceCreated(SurfaceHolder holder) {
		// The Surface has been created, acquire the camera and tell it where
		// to draw.
		mCamera = Camera.open();
		try {
			mCamera.setPreviewDisplay(holder);
		} catch (IOException exception) {
			mCamera.release();
			mCamera = null;
			// TODO: add more exception handling logic here
		}
	}

	public void surfaceDestroyed(SurfaceHolder holder) {
		// Surface will be destroyed when we return, so stop the preview.
		// Because the CameraDevice object is not a shared resource, it's very
		// important to release it when the activity is paused.
		mCamera.stopPreview();
		mCamera.release();
		mCamera = null;
	}

	public void surfaceChanged(SurfaceHolder holder, int format, int w, int h) {
		Camera.Parameters parameters = mCamera.getParameters();
		parameters.setPreviewSize(w, h); // This causes an error on the physical device but is correct in the emulator.
		// where w and h come from but they're wrong. That's what causes the error.
		//parameters.setPreviewSize(parameters.getPreviewSize().width, parameters.getPreviewSize().height);
		mCamera.setParameters(parameters);
		mCamera.startPreview();
		
	}

}
