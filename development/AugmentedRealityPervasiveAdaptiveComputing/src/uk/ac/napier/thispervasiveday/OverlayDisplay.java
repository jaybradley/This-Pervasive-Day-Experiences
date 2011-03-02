package uk.ac.napier.thispervasiveday;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Rect;
import android.view.View;
import uk.ac.napier.thispervasivedaycameratexture.R;

public class OverlayDisplay extends View {
	 
    //private Bitmap image;
    private Paint paint;
    private int x=50;
    private Rect drawingRect;
 
    public OverlayDisplay(Context context) {
        super(context);
        //image = Bitmap.createBitmap(BitmapFactory.decodeResource(this.getResources(), R.drawable.test));
        paint = new Paint();
        paint.setARGB(100, 0, 100, 100);
        //paint.setAlpha(100);
        
        drawingRect = new Rect();
    }
 
    public void invalidateRegionOfInterest() {
    	invalidate(drawingRect);
    }
    
    protected void onDraw(Canvas canvas) {
    	//canvas.drawBitmap(image, x, 0, paint);
    	drawingRect.set(50 + x, 50 + x, 200, 200);
    	canvas.drawRect(drawingRect, paint);
    	
    }
 
    // called by thread
    public void update() {
    	System.err.println("HERE 2");
        if(x < 100)
            x += 1;
        else
            x=0;
    }
 
}
