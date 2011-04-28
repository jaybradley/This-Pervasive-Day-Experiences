package {
	
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Object3D;
	import away3d.core.draw.ScreenVertex;
	
	import com.greensock.TimelineLite;
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Vector3D;
	
	import mx.core.FlexGlobals;
	
	import org.flintparticles.common.displayObjects.RadialDot;
	import org.flintparticles.threeD.away3d.Away3DRenderer;
	import org.flintparticles.threeD.emitters.Emitter3D;
	
	
	
	public class AdaptiveJewelry extends ARJewelry {
		
		private var away3dRenderer:Away3DRenderer;
		private var fountain:Emitter3D;
		private var lastColour:int = -1;
				
		public function AdaptiveJewelry(manager:ARJewelryManager) {
			super(manager);
			
			trace("AdaptiveJewelry constructed");
			
			fountain = new Fountain();
			
			//scale(5);
			
			
			
			//away3dRenderer = new Away3DRenderer(manager.view.scene);
			away3dRenderer = new Away3DRenderer(this);
			
			away3dRenderer.addEmitter(fountain);
			
			//scale(10);
			
			this.ownCanvas = true;
			
		}
		
		
		override public function pause():void {
			super.pause();
			fountain.stop();
		}
		
		override public function resume():void {
			super.resume();
			fountain.start();
		}
		
		public function changeColours():void {
			
			
			
			//var aFountain:Fountain = fountain as Fountain;
			//(fountain as Fountain).colours.addColor(0xff0000ff, 1);
			
			var screenVertex:ScreenVertex = manager.camera3D.screen(this);
			trace("screenVertex is (" +screenVertex + ")");
			var widthOfApp:int = FlexGlobals.topLevelApplication.width;
			var heightOfApp:int = FlexGlobals.topLevelApplication.height;
			
			var bd:BitmapData = new BitmapData(widthOfApp, heightOfApp);
			bd.draw(FlexGlobals.topLevelApplication.stage);
			var b:Bitmap = new Bitmap(bd);
			var xPos:int = (widthOfApp / 2) + screenVertex.x;
			var yPos:int = (heightOfApp / 2) + screenVertex.y;
			
			//xPos += 50;
			yPos += 100;
			var colour:int = b.bitmapData.getPixel(xPos, yPos);
			trace("colour: " + colour + " width: " + widthOfApp + " height: " + heightOfApp + " x, y is " + xPos + ", " + yPos);
			
			var colourStr:String = colour.toString(16).toUpperCase();
			colourStr = "000000" + colourStr;
			trace("#" + colourStr.substr(colourStr.length - 6));
			
			if(lastColour != -1) {
				(fountain as Fountain).colours.removeColor(lastColour);
			}
			(fountain as Fountain).colours.addColor(colour, 1);
			lastColour = colour;
		}
		
		override protected function startAnimation():void {
			if(mainTimeline == null) {
				
				mainTimeline = new TimelineMax({paused:true});
				
				//healthChangeTimeline.insert(TweenLite.from(this, 0, {nothing_forAnimation:1, onComplete:changeHealth}));
				mainTimeline.insert(TweenLite.delayedCall(1, changeColours, []));
				mainTimeline.repeat = -1;
				mainTimeline.repeatDelay = 2;
				
				mainTimeline.play();
			}
		}
		
	}
}