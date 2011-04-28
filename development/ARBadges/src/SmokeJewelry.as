package {
	
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Object3D;
	
	import com.greensock.TimelineLite;
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Vector3D;
	
	import org.flintparticles.common.displayObjects.RadialDot;
	import org.flintparticles.threeD.away3d.Away3DRenderer;
	import org.flintparticles.threeD.emitters.Emitter3D;
	
	
	
	public class SmokeJewelry extends ARJewelry {
		
		private var away3dRenderer:Away3DRenderer;
		private var smoke:Emitter3D;
		private var fire:Emitter3D;
		
		public function SmokeJewelry(manager:ARJewelryManager) {
			super(manager);
			
			trace("SmokeJewelry constructed");
			
			smoke = new Smoke();
			//smoke.start();
			//smoke = new Candle(new Vector3D(0, 0, 0));
			fire = new Fire();
			//fire.start();
			
			
			//scale(5);
				
			
			
			//away3dRenderer = new Away3DRenderer(manager.view.scene);
			away3dRenderer = new Away3DRenderer(this);
			
			away3dRenderer.addEmitter(smoke);
			away3dRenderer.addEmitter(fire);
			
			//scale(10);
			
			//this.addChild(object);
			
			this.ownCanvas = true;
			//this.filters = [new BlurFilter( 2, 2, 1 ), new ColorMatrixFilter( [ 1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0.95,0 ] )];
			
			//this.filters = [new GlowFilter(0xffffbe, 0.5, 12, 12, 2, 1, false, false), new GlowFilter(0xffffbe, 0.5, 12, 12, 2, 1, true, false)];
			
			//startAnimation();
			
		}
		
		
		override public function pause():void {
			super.pause();
			fire.stop();
			smoke.stop();
		}
		
		override public function resume():void {
			super.resume();
			
			
			fire.start();
			smoke.start();
/*			if(healthChangeTimeline != null) {
				healthChangeTimeline.restart();
			} else {
				startAnimation();
			}
*/			
		}
		
		override protected function startAnimation():void {
		//	trace("HealthJewelry::startAnimation");
			
		//	if(mainTimeline == null) {
/*				mainTimeline = new TimelineMax({paused:true});
				
				//see http://www.greensock.com/as/docs/tween/ use insert multiple to get x and y scaling at the same time. Get these to repeat forever
				//either use some inbuilt repeat mechanism or just call this function the the animation has ended
				
				mainTimeline.insertMultiple([new TweenLite(rotationContainer, 0.5, {scaleX:2}), new TweenLite(rotationContainer, 0.5, {scaleY:2})]);
				mainTimeline.insertMultiple([new TweenLite(rotationContainer, 0.5, {scaleX:1}), new TweenLite(rotationContainer, 0.5, {scaleY:1})]);
				mainTimeline.repeat = -1;
				mainTimeline.repeatDelay = 0.3;
				
				mainTimeline.play();
*/			//}
		}
		
	}
}