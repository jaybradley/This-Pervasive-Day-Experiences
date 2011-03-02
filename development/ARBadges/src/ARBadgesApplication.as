package {
	
	import mx.events.FlexEvent;
	
	import spark.components.Application;
	import spark.core.SpriteVisualElement;
	
	public class ARBadgesApplication extends Application {
		public function ARBadgesApplication() {
			super();
			
			addEventListener(FlexEvent.APPLICATION_COMPLETE, onApplicationComplete);
			
		}
		
		private function onApplicationComplete(event:FlexEvent):void {
			//this.addChild(new FLARManagerExample_Away3D());
			var spriteHolder:SpriteVisualElement = new SpriteVisualElement();
			spriteHolder.verticalCenter = -240;
			spriteHolder.horizontalCenter = -320;
			addElement(spriteHolder);
			spriteHolder.addChild(new ARBadgesContentDisplay());
		}
		
	}
}