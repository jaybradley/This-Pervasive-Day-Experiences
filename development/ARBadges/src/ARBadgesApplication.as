package {
	
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.core.TweenCore;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Elastic;
	
	import flash.display.StageQuality;
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	
	import spark.components.Application;
	import spark.components.Label;
	import spark.core.SpriteVisualElement;
	import spark.filters.DropShadowFilter;
	
	public class ARBadgesApplication extends Application {
		
		private var biometricTimeline:TimelineLite;
		private var adaptiveTimeline:TimelineLite;
		
		public function ARBadgesApplication() {
			super();
			
			
			addEventListener(FlexEvent.APPLICATION_COMPLETE, onApplicationComplete);
			
		}
		
		private function onApplicationComplete(event:FlexEvent):void {
			
			//this.addChild(new FLARManagerExample_Away3D());
			var spriteHolder:SpriteVisualElement = new SpriteVisualElement();
			//spriteHolder.width = 640;
			//spriteHolder.height = 480;
			spriteHolder.verticalCenter = -240;
			spriteHolder.horizontalCenter = -320;
			addElement(spriteHolder);
			spriteHolder.addChild(new ARBadgesContentDisplay());
			
			var shadow:DropShadowFilter = new DropShadowFilter();
			spriteHolder.filters = [shadow];
			
			biometricTimeline = new TimelineLite();
			biometricTimeline.append(TweenLite.to(FlexGlobals.topLevelApplication.biometricText, 3, {alpha: 0.9, ease: Bounce.easeInOut}));
			biometricTimeline.append(TweenLite.to(FlexGlobals.topLevelApplication.biometricText, 10, {alpha: 0, delay: 10, ease: Bounce.easeInOut}));
			
			adaptiveTimeline = new TimelineLite();
			adaptiveTimeline.append(TweenLite.to(FlexGlobals.topLevelApplication.adaptiveText, 3, {alpha: 0.9, ease: Bounce.easeInOut}));
			adaptiveTimeline.append(TweenLite.to(FlexGlobals.topLevelApplication.adaptiveText, 10, {alpha: 0, delay: 10, ease: Bounce.easeInOut}));
			
			//addEventListener(MouseEvent.CLICK, showBiometricText);
			//addEventListener(MouseEvent.CLICK, showAdaptiveText);
		}
		
		public function showBiometricText():void {
			if(FlexGlobals.topLevelApplication.biometricText.alpha < 0.7) {		
				biometricTimeline.restart()
			}
		}
		
		public function showAdaptiveText():void {
			if(FlexGlobals.topLevelApplication.adaptiveText.alpha < 0.7) {		
				adaptiveTimeline.restart();
			}
		}
		
	}
}