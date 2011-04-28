package {
	
	import away3d.core.base.Object3D;
	import away3d.core.utils.Debug;
	import away3d.events.Loader3DEvent;
	import away3d.loaders.Loader3D;
	import away3d.loaders.Obj;
	import away3d.materials.ShadingColorMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.RoundedCube;
	
	import com.greensock.TimelineLite;
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	
	import flash.filters.GlowFilter;
	import flash.geom.Vector3D;
	
	public class ObjJewelry extends ARJewelry {
		
		private static const CUBE_SIZE:Number = 100;
		private var object3d:Object3D;
		private var mat:ShadingColorMaterial;
		private var loader:Loader3D;
		
		public function ObjJewelry(manager:ARJewelryManager) {
			super(manager);
			
			trace("ObjJewelry constructed");

			var object:RedCross = new RedCross();
			scale(0.3);
			rotateTo(60, 30, -30);
			
			
			this.addChild(object);
			
			//mat = new ShadingColorMaterial(null, {ambient:0xFF1919, diffuse:0x730000, specular: 0xFFFFFF});
			
			
			this.ownCanvas = true;
			this.filters = [new GlowFilter(0xffffbe, 0.5, 12, 12, 2, 1, false, false), new GlowFilter(0xffffbe, 0.5, 12, 12, 2, 1, true, false)];
			
			//startAnimation();
		}
		
		override protected function startAnimation():void {
			var myTimeline:TimelineMax = new TimelineMax({paused:true});
						
			myTimeline.insertMultiple([new TweenLite(this, 0.5, {scaleX:3}), new TweenLite(this, 0.5, {scaleY:3})]);
			myTimeline.insertMultiple([new TweenLite(this, 0.5, {scaleX:1}), new TweenLite(this, 0.5, {scaleY:1})]);
			myTimeline.repeat = -1;
			myTimeline.repeatDelay = 0.2;
			
			myTimeline.play();
			
		}
	}
}