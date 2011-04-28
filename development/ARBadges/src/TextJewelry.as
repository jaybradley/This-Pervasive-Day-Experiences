package {
	
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.render.Renderer;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.PhongBitmapMaterial;
	import away3d.materials.ShadingColorMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.Plane;
	
	import com.greensock.TimelineLite;
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	
	import flash.display.BitmapData;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import mx.controls.ComboBox;
	import mx.controls.TextInput;
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	public class TextJewelry extends ARJewelry {
		
		private static const TEXT_SIZE:Number = 100;
		
		private var _render_txt:TextField;
		
		private var _frontMaterial:BitmapMaterial;
		private var _backMaterial:BitmapMaterial;
		private var _text_bmd:BitmapData;
		private var _render_tf:TextFormat;
		private var text:String;
		
		public var planeContainer:ObjectContainer3D;
		
		public function TextJewelry(manager:ARJewelryManager, text:String) {
			super(manager);
			
			trace("TextJewelry constructed");
			
			this.text = text;
			
			this._render_tf = new TextFormat();
			this._render_tf.align = "center";
			this._render_tf.size = 100;
			
			this.planeContainer = new ObjectContainer3D();
			planeContainer.bothsides = false;
			
			var plane:Plane;
			
			for(var i:int = 0; i < 10; i++) {
				plane = new Plane({    width:1200,
					height:100,
					rotationX:90,
					segments:2,
					z: i*2});
				plane.ownCanvas = true;
				plane.bothsides = false;
				this.planeContainer.addChild(plane);
			}
			
			this._render_txt = new TextField();
			this._render_txt.width = 1200;
			this._render_txt.height = 100;
			this._render_txt.type = TextFieldType.DYNAMIC;
			//this.render_txt.embedFonts = true;
			//this.render_txt.antiAliasType = AntiAliasType.ADVANCED;
			  
			this.createBitmaps();
			
			//var mat:ShadingColorMaterial = new ShadingColorMaterial(null, {ambient:0xFF1919, diffuse:0x730000, specular: 0xFFFFFF});

			this.ownCanvas = true;
			//this.filters = [new GlowFilter(0xffffbe, 0.5, 12, 12, 2, 1, false, false), new GlowFilter(0xffffbe, 0.5, 12, 12, 2, 1, true, false)];
			
			this.addChild(planeContainer);
			
			//startAnimation();
		}
		
		override protected function startAnimation():void {
			var myTimeline:TimelineMax = new TimelineMax({paused:true});
			
			//see http://www.greensock.com/as/docs/tween/ use insert multiple to get x and y scaling at the same time. Get these to repeat forever
			//either use some inbuilt repeat mechanism or just call this function the the animation has ended
			
			/*myTimeline.appendMultiple([new TweenLite(this, 3, {scaleX:1.5}), new TweenLite(this, 4, {scaleY:1.5})]);
			myTimeline.appendMultiple([new TweenLite(this, 3, {scaleX:1}), new TweenLite(this, 4, {scaleY:1})]);
			myTimeline.repeat = -1;
			myTimeline.repeatDelay = 0.0;
			
			
			myTimeline.play();*/
			
		}
		
		public function createBitmaps(event:Event = null):void {
			//this._render_txt.text = this.input_txt.text;
			this._render_txt.text = this.text;
			this._render_tf.color = 0xabd607;
			this._render_tf.font = "DistroMix";//this.font_cmb.selectedItem.fontName;
			this._render_txt.setTextFormat(this._render_tf);
			this._text_bmd = new BitmapData(1200,100, true, 0x000000);            
			this._text_bmd.draw(this._render_txt);
			this._frontMaterial = new BitmapMaterial(this._text_bmd, {smooth:true, debug:false});
			
			this._render_tf.color = 0xa0c807;
			this._render_txt.setTextFormat(this._render_tf);
			
			this._text_bmd = new BitmapData(1200,100, true, 0x000000);            
			this._text_bmd.draw(this._render_txt);
			this._backMaterial = new BitmapMaterial(this._text_bmd, {smooth:true, debug:false});
			
			var c:int = 0;
			for each(var plane:Plane in this.planeContainer.children) {
				if(c == 0) {
					plane.material = this._frontMaterial;
					c++
				} else {
					plane.material = this._backMaterial;    
				}
			}
		}
	}
}