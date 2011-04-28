package {
	import away3d.containers.ObjectContainer3D;
	
	import com.greensock.TimelineMax;

	public class ARJewelry extends ObjectContainer3D  {
		
		public var inUse:Boolean = false;
		protected var manager:ARJewelryManager;
		protected var mainTimeline:TimelineMax = null;
		
		
		public function ARJewelry(manager:ARJewelryManager) {
			this.manager = manager;
		}
		
		public function pause():void {
			trace("ARJewelry::pause");
			inUse = false;
			if(mainTimeline != null) {
				mainTimeline.pause();
			}
		}
		
		public function resume():void {
			trace("ARJewelry::resume");
			inUse = true;
			if(mainTimeline != null) {
				mainTimeline.restart();
			} else {
				startAnimation();
			}
		}
		
		protected function startAnimation():void {
			trace("ARJewelry::startAnimation");
		} 
		
		
	}
}