package {
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.lights.DirectionalLight3D;
	import away3d.materials.ShadingColorMaterial;
	import away3d.primitives.Cube;
	
	import com.transmote.flar.FLARManager;
	import com.transmote.flar.camera.FLARCamera_Away3D;
	import com.transmote.flar.marker.FLARMarker;
	import com.transmote.flar.source.FLARCameraSource;
	import com.transmote.flar.utils.geom.AwayGeomUtils;
	import com.transmote.flar.utils.geom.FLARGeomUtils;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	
		
	
	/**
	 * standard FLARToolkit Away3D example, with our friends the Cubes.
	 * couldn't have done it without Mikael Emtinger's help.  muchas gracias, Mikael.
	 * 
	 * the Away3D platform can be found here:
	 * http://away3d.com/
	 * please note, usage of the Away3D platform is subject to Away3D's licensing.
	 * 
	 * @author	Eric Socolofsky
	 * @url		http://transmote.com/flar
	 */
	public class ARJewelryManager extends Sprite {
		//private static const CUBE_SIZE:Number = 100;
		
		private static const SIZE_OF_OBJECT_POOL:int = 10;
		
		public var view:View3D;
		public var camera3D:FLARCamera_Away3D;
		private var scene3D:Scene3D;
		private var light:DirectionalLight3D;
		
		private var markersByPatternId:Vector.<Vector.<FLARMarker>>;	// FLARMarkers, arranged by patternId
		private var activePatternIds:Vector.<int>;						// list of patternIds of active markers
		private var containersByMarker:Dictionary;						// Cube containers, hashed by corresponding FLARMarker
		
		private var objectPool:Object = new Object();
		private var objectTypesToShow:Array = ["TextJewelry", "HealthJewelry", "AdaptiveJewelry"]; // TextJewelry shoudl come first as other types use it
		private var jewelryByMarker:Dictionary;
		
		public function ARJewelryManager (flarManager:FLARManager, viewportSize:Rectangle) {
			FlexGlobals.topLevelApplication.stage.quality = StageQuality.MEDIUM;
			
			this.init();
			this.initEnvironment(flarManager, viewportSize);
			
			this.createObjects();
			//this.createLights();
		}
		
		private function createObjects():void {
			// create a dictionary of arrays so that you can do objectPool["some_type_of_jewelry"] = new ArrayCollection();
			
			//var test:ObjJewelry = new ObjJewelry();
			//trace(getQualifiedClassName(test));
			//var test1:CubeJewelry = new CubeJewelry();
			//trace(getQualifiedClassName(test1));
			
			
			// classnames need to be referenced before they can be used below
			var test:ObjJewelry;
			var test1:CubeJewelry;
			var test2:TextJewelry;
			var test3:HealthJewelry;
			var test4:SmokeJewelry;
			var test5:AdaptiveJewelry;
			
			objectPool["TextJewelry"] = new ArrayCollection();
			for(var index:int = 0; index <= 100; index += 1) {
				var textNumber:String = String(index);
				objectPool["TextJewelry"].addItem(new TextJewelry(this, textNumber + "%"));
			}
			
			
			for each(var typeOfJewelry:String in objectTypesToShow) {
				if(typeOfJewelry != "TextJewelry") { // deal with TextJewelry's separately as we want 100 of them
					objectPool[typeOfJewelry] = new ArrayCollection();
					
					for(var index:int = 0; index < SIZE_OF_OBJECT_POOL; index += 1) {
						var ClassReference:Class = getDefinitionByName(typeOfJewelry) as Class;
							objectPool[typeOfJewelry].addItem(new ClassReference(this));
						}
					}
			
			}
		
		}
		
		private function createLights():void {
			var light:DirectionalLight3D = new DirectionalLight3D();
			light.direction = new Vector3D(100, -500, 500);
			light.specular = 1;
			light.diffuse = 0.5;
			light.ambient = 0.5;
			this.scene3D.addLight(light);
		}
		
		public function getJewelryFromPool(type:String):ARJewelry {
			// do something like:
			// var objectsOfTheRightType:ArrayCollection = objectPool["type"]
			// loop through the objects until we get one that is  object[3].inUse == false;
			// set object[3].inUse = true;
			// return that one
			
			// remeber to frree it up when it's removed with object[3].inUse == false. and to reset any animations etc.
			
			trace("Geeting object of type: " + type + " from pool");
			
			if(type == "TextJewelry") {
				return getTextJewelryFromPool(randomRange(0, 100));
			}
			
			for(var index:int = 0; index < SIZE_OF_OBJECT_POOL; index += 1) {
				if(objectPool[type].getItemAt(index).inUse == false) {
					objectPool[type].getItemAt(index).resume();
					return objectPool[type].getItemAt(index);
				}
			}
			
			trace("Used all items in object pool of type: " + type);
			return null;
			
		}
		
		private function randomRange(max:Number, min:Number = 0):Number {
			return Math.random() * (max - min) + min;
		}
		
		public function getTextJewelryFromPool(index:Number):ARJewelry {
			// do something like:
			// var objectsOfTheRightType:ArrayCollection = objectPool["type"]
			// loop through the objects until we get one that is  object[3].inUse == false;
			// set object[3].inUse = true;
			// return that one
			
			// remeber to frree it up when it's removed with object[3].inUse == false. and to reset any animations etc.
			
			//trace("Geeting object of type: TextJewelry from pool. index is " + index);

				while(objectPool["TextJewelry"].getItemAt(index).inUse == true) {
					index += 1;
					if(index > 100) {
						index = 0;
					}
					//trace("Clash! Changed index to: " + index);
				}
				
				objectPool["TextJewelry"].getItemAt(index).resume();
				return objectPool["TextJewelry"].getItemAt(index);
				
		}

		public function removeTextJewelryFromPool(index:Number):void {
			// do something like:
			// var objectsOfTheRightType:ArrayCollection = objectPool["type"]
			// loop through the objects until we get one that is  object[3].inUse == false;
			// set object[3].inUse = true;
			// return that one
			
			// remeber to frree it up when it's removed with object[3].inUse == false. and to reset any animations etc.
			
			//trace("Geeting object of type: TextJewelry from pool. index is " + index);
			
			objectPool["TextJewelry"].getItemAt(index).pause();
						
		}

		
		
		public function addMarker (marker:FLARMarker) :void {
			trace("addMarker");
			
			this.storeMarker(marker);
			
			// create a new Cube, and place it inside a container (ObjectContainer3D) for manipulation
			var container:ObjectContainer3D = new ObjectContainer3D();
			
			var jewelry:ARJewelry = getJewelry(marker.patternId);			
			
			//var mat:ShadingColorMaterial = this.getMaterialByPatternId(marker.patternId);
			//var cube:Cube = new Cube({material:mat, width:CUBE_SIZE, height:CUBE_SIZE, depth:CUBE_SIZE});
			//cube.ownCanvas = true;
			//cube.filters = [new GlowFilter(0xffffbe, 1, 12, 12, 3, 3, false, false), new GlowFilter(0xffffbe, 1, 12, 12, 3, 3, true, false)];
			
			//cube.z = -0.5 * CUBE_SIZE;
			
			//container.addChild(cube);
			
			container.addChild(jewelry);
			this.scene3D.addChild(container);
			
			// associate container with corresponding marker
			this.containersByMarker[marker] = container;
			this.jewelryByMarker[marker] = jewelry;
			
			
		}
		
		public function removeMarker (marker:FLARMarker) :void {
			if (!this.disposeMarker(marker)) { return; }
			
			// find and remove corresponding container
			var container:ObjectContainer3D = this.containersByMarker[marker];
			if (container) {
				this.scene3D.removeChild(container);
				jewelryByMarker[marker].pause();
				
				
			}
			
			delete this.containersByMarker[marker]
		}
		
		private function init () :void {
			// set up lists (Vectors) of FLARMarkers, arranged by patternId
			this.markersByPatternId = new Vector.<Vector.<FLARMarker>>();
			
			// keep track of active patternIds
			this.activePatternIds = new Vector.<int>();
			
			// prepare hashtable for associating Cube containers with FLARMarkers
			this.containersByMarker = new Dictionary(true);
			this.jewelryByMarker = new Dictionary(true);
			
		}
		
		private function initEnvironment (flarManager:FLARManager, viewportSize:Rectangle) :void {
			this.scene3D = new Scene3D();
			this.camera3D = new FLARCamera_Away3D(flarManager, viewportSize);
			this.view = new View3D({x:0.5*viewportSize.width, y:0.5*viewportSize.height, scene:this.scene3D, camera:this.camera3D});
			this.addChild(this.view);
			
			this.light = new DirectionalLight3D();
			this.light.direction = new Vector3D(500, -300, 200);
			this.scene3D.addLight(light);
			
			this.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
		}
		
		private function onEnterFrame (evt:Event) :void {
			this.updateCubes();
			this.view.render();
		}
		
		private function updateCubes () :void {
			// update all Cube containers according to the transformation matrix in their associated FLARMarkers
			var i:int = this.activePatternIds.length;
			var markerList:Vector.<FLARMarker>;
			var marker:FLARMarker;
			var container:ObjectContainer3D;
			var j:int;
			while (i--) {
				markerList = this.markersByPatternId[this.activePatternIds[i]];
				j = markerList.length;
				while (j--) {
					marker = markerList[j];
					container = this.containersByMarker[marker];
					container.transform = AwayGeomUtils.convertMatrixToAwayMatrix(marker.transformMatrix);
				}
			}
		}
		
		private function storeMarker (marker:FLARMarker) :void {
			// store newly-detected marker.
			
			var markerList:Vector.<FLARMarker>;
			if (marker.patternId < this.markersByPatternId.length) {
				// check for existing list of markers of this patternId...
				markerList = this.markersByPatternId[marker.patternId];
			} else {
				this.markersByPatternId.length = marker.patternId + 1;
			}
			if (!markerList) {
				// if no existing list, make one and store it...
				markerList = new Vector.<FLARMarker>();
				this.markersByPatternId[marker.patternId] = markerList;
				this.activePatternIds.push(marker.patternId);
			}
			// ...add the new marker to the list.
			markerList.push(marker);
		}
		
		private function disposeMarker (marker:FLARMarker) :Boolean {
			// find and remove marker.
			// returns false if marker's patternId is not currently active.
			
			var markerList:Vector.<FLARMarker>;
			if (marker.patternId < this.markersByPatternId.length) {
				// get list of markers of this patternId
				markerList = this.markersByPatternId[marker.patternId];
			}
			if (!markerList) {
				// patternId is not currently active; something is wrong, so exit.
				return false;
			}
			
			var markerIndex:uint = markerList.indexOf(marker);
			if (markerIndex != -1) {
				markerList.splice(markerIndex, 1);
				if (markerList.length == 0) {
					this.markersByPatternId[marker.patternId] = null;
					var patternIdIndex:int = this.activePatternIds.indexOf(marker.patternId);
					if (patternIdIndex != -1) {
						this.activePatternIds.splice(patternIdIndex, 1);
					}
				}
			}
			
			return true;
		}
		
		private function getJewelry(patternID:int):ARJewelry {
			
			trace("patternid: " + patternID);
			
			switch (patternID % 2) {
				case 0:
					FlexGlobals.topLevelApplication.showBiometricText();
					return getJewelryFromPool("HealthJewelry");
					
				case 1:
					FlexGlobals.topLevelApplication.showAdaptiveText();
					return getJewelryFromPool("AdaptiveJewelry");
				/*case 2:
					return getJewelryFromPool("HealthJewelry");
				case 3:
					return getJewelryFromPool("HealthJewelry");
				case 4:
					return getJewelryFromPool("SmokeJewelry");
				case 5:
					return getJewelryFromPool("SmokeJewelry");
				case 6:
					return getJewelryFromPool("SmokeJewelry");
				case 7:
					return getJewelryFromPool("SmokeJewelry");
				case 8:
					return getJewelryFromPool("AdaptiveJewelry");
				case 9:
					return getJewelryFromPool("AdaptiveJewelry");
				case 10:
					return getJewelryFromPool("AdaptiveJewelry");
				case 11:
					return getJewelryFromPool("AdaptiveJewelry");
				case 12:
					return getJewelryFromPool("AdaptiveJewelry");*/
				default:
					return getJewelryFromPool("AdaptiveJewelry");
			}
			//return new CubeJewelry();
			//return new HealthJewelry();
			//return new TextJewelry();
			//return new ObjJewelry();
			//return getJewelryFromPool("ObjJewelry");
			//return getJewelryFromPool("HealthJewelry");
			//return getJewelryFromPool("SmokeJewelry");
			//return getJewelryFromPool("AdaptiveJewelry");
			
			
		}
		
		private function getMaterialByPatternId (patternId:int) :ShadingColorMaterial {
			switch (patternId % 12) {
				case 0:
					return new ShadingColorMaterial(null, {ambient:0xFF1919, diffuse:0x730000, specular: 0xFFFFFF});
				case 1:
					return new ShadingColorMaterial(null, {ambient:0xFF19E8, diffuse:0x730067, specular: 0xFFFFFF});
				case 2:
					return new ShadingColorMaterial(null, {ambient:0x9E19FF, diffuse:0x420073, specular: 0xFFFFFF});
				case 3:
					return new ShadingColorMaterial(null, {ambient:0x192EFF, diffuse:0x000A73, specular: 0xFFFFFF});
				case 4:
					return new ShadingColorMaterial(null, {ambient:0x1996FF, diffuse:0x003E73, specular: 0xFFFFFF});
				case 5:
					return new ShadingColorMaterial(null, {ambient:0x19FDFF, diffuse:0x007273, specular: 0xFFFFFF});
				case 6:
					return new ShadingColorMaterial(null, {ambient:0x19FF5A, diffuse:0x007320, specular: 0xFFFFFF});
				case 7:
					return new ShadingColorMaterial(null, {ambient:0x19FFAA, diffuse:0x007348, specular: 0xFFFFFF});
				case 8:
					return new ShadingColorMaterial(null, {ambient:0x6CFF19, diffuse:0x297300, specular: 0xFFFFFF});
				case 9:
					return new ShadingColorMaterial(null, {ambient:0xF9FF19, diffuse:0x707300, specular: 0xFFFFFF});
				case 10:
					return new ShadingColorMaterial(null, {ambient:0xFFCE19, diffuse:0x735A00, specular: 0xFFFFFF});
				case 11:
					return new ShadingColorMaterial(null, {ambient:0xFF9A19, diffuse:0x734000, specular: 0xFFFFFF});
				case 12:
					return new ShadingColorMaterial(null, {ambient:0xFF6119, diffuse:0x732400, specular: 0xFFFFFF});
				default:
					return new ShadingColorMaterial(null, {ambient:0xCCCCCC, diffuse:0x666666, specular: 0xFFFFFF});
			}
		}
	}
}