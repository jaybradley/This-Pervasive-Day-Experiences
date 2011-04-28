package {
	import away3d.materials.ShadingColorMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.RoundedCube;
	
	import flash.filters.GlowFilter;

	public class CubeJewelry extends ARJewelry {
		
		private static const CUBE_SIZE:Number = 100;
		
		public function CubeJewelry(manager:ARJewelryManager) {
			super(manager);
			
			trace("CubeJewelry constructed");
			
			var mat:ShadingColorMaterial = new ShadingColorMaterial(null, {ambient:0xFF1919, diffuse:0x730000, specular: 0xFFFFFF});
			var cube:RoundedCube = new RoundedCube({material:mat, width:CUBE_SIZE, height:CUBE_SIZE, depth:CUBE_SIZE});
			cube.ownCanvas = true;
			cube.filters = [new GlowFilter(0xffffbe, 1, 12, 12, 3, 3, false, false), new GlowFilter(0xffffbe, 1, 12, 12, 3, 3, true, false)];
			cube.z = -0.5 * CUBE_SIZE;
			
			this.addChild(cube);
		}
	}
}