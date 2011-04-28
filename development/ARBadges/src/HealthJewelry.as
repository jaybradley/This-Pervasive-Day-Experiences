package {
	
	import away3d.containers.ObjectContainer3D;
	import away3d.materials.ShadingColorMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.RoundedCube;
	import away3d.tools.Merge;
	
	import com.greensock.TimelineLite;
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.filters.GlowFilter;
	
	public class HealthJewelry extends ARJewelry {
		
		private static const CUBE_SIZE:Number = 100;
		//var mat:ShadingColorMaterial;
		private var healthPercentage:int = 0;
		//private var targetHealthPercentage:int = 0;
		private var text:TextJewelry;
		public var nothing_forAnimation:int = 0;
		private var healthChangeTimeline:TimelineMax = null;
		public var object:RedCross;
		public var rotationContainer:ObjectContainer3D
		
		public function HealthJewelry(manager:ARJewelryManager) {
			super(manager);
			
			trace("ObjJewelry constructed");
			
			rotationContainer = new ObjectContainer3D();
			object = new RedCross();
			object.rotateTo(60, 30, -30);
			object.scale(0.3);
			
			//mat = new ShadingColorMaterial(null, {ambient:0xFF1919, diffuse:0x730000, specular: 0xFFFFFF});
			//for(var meshIndex:int = 0; meshIndex < object.meshes.length; meshIndex += 1) {
			//	object.meshes[meshIndex].material = new ShadingColorMaterial(null, {ambient:0xFF1919, diffuse:0x730000, specular: 0xFFFFFF});
			//}
			
			//var text:TextJewelry = new TextJewelry(manager, "76");
			healthPercentage = randomRange(0, 100);
			text = manager.getTextJewelryFromPool(healthPercentage) as TextJewelry;
			//text.moveDown(50);
			text.y = -50;
			
			
			
			this.addChild(rotationContainer);
			rotationContainer.addChild(object);
			//this.addChild(object);
			this.addChild(text);
			
			this.ownCanvas = true;
			//this.filters = [new GlowFilter(0xffffbe, 0.5, 12, 12, 2, 1, false, false), new GlowFilter(0xffffbe, 0.5, 12, 12, 2, 1, true, false)];
			
			//startAnimation();
			
		}
		
		private function randomRange(max:Number, min:Number = 0):Number {
			return Math.random() * (max - min) + min;
		}
		
		private function changeHealth():void {
			trace("HealthJewelry::changeHealth");
			
			//targetHealthPercentage = healthPercentage + randomRange(0, 10) - 5; 
			
			removeChild(text);
			manager.removeTextJewelryFromPool(healthPercentage);
			
			var changeInHealth:int = Math.round(Math.random() * 2) - 1;
			trace("changeInHealth is " + changeInHealth);
			
			healthPercentage += changeInHealth;
			if(healthPercentage > 100) {
				healthPercentage = 100;
			} else if(healthPercentage < 0) {
				healthPercentage = 0;
			}
			
			text = manager.getTextJewelryFromPool(healthPercentage) as TextJewelry;
			text.y = -50;
			addChild(text);
		}
		
		override public function pause():void {
			super.pause();
			if(healthChangeTimeline != null) {
				healthChangeTimeline.pause();
			}
		}
		
		override public function resume():void {
			super.resume();
			
			if(healthChangeTimeline != null) {
				healthChangeTimeline.restart();
			} else {
				startAnimation();
			}
			
		}
		
		override protected function startAnimation():void {
			trace("HealthJewelry::startAnimation");
			
			if(mainTimeline == null) {
				mainTimeline = new TimelineMax({paused:true});
				
				//see http://www.greensock.com/as/docs/tween/ use insert multiple to get x and y scaling at the same time. Get these to repeat forever
				//either use some inbuilt repeat mechanism or just call this function the the animation has ended
				
				mainTimeline.insertMultiple([new TweenLite(rotationContainer, 0.5, {scaleX:2}), new TweenLite(rotationContainer, 0.5, {scaleY:2})]);
				mainTimeline.insertMultiple([new TweenLite(rotationContainer, 0.5, {scaleX:1}), new TweenLite(rotationContainer, 0.5, {scaleY:1})]);
				mainTimeline.repeat = -1;
				mainTimeline.repeatDelay = 0.3;
				
				mainTimeline.play();
			}
			
			if(healthChangeTimeline == null) {
				
				healthChangeTimeline = new TimelineMax({paused:true});
				
				//healthChangeTimeline.insert(TweenLite.from(this, 0, {nothing_forAnimation:1, onComplete:changeHealth}));
				healthChangeTimeline.insert(TweenLite.delayedCall(1, changeHealth, []));
				healthChangeTimeline.repeat = -1;
				healthChangeTimeline.repeatDelay = 4;
				
				healthChangeTimeline.play();
			}
			
		}
		
		
	}
}