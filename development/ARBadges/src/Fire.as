package
	
{
	
	import flash.geom.Vector3D;
	
	import org.flintparticles.common.actions.*;
	import org.flintparticles.common.counters.*;
	import org.flintparticles.common.displayObjects.RadialDot;
	import org.flintparticles.common.initializers.*;
	import org.flintparticles.threeD.actions.*;
	import org.flintparticles.threeD.away3d.initializers.A3DDisplayObjectClass;
	import org.flintparticles.threeD.emitters.Emitter3D;
	import org.flintparticles.threeD.initializers.*;
	import org.flintparticles.threeD.zones.*;
	
	
	
	public class Fire extends Emitter3D
		
	{
		
		public function Fire()
			
		{
			
			counter = new Steady( 60 );
			
			
			
			addInitializer( new Lifetime( 2, 3 ) );
			
			addInitializer( new Velocity( new DiscZone( new Vector3D( 0, 0, 0 ), new Vector3D( 0, 1, 0 ), 40 ) ) );
			
			addInitializer( new Position( new DiscZone( new Vector3D( 0, 0, -50 ), new Vector3D( 0, 1, 0 ), 3 ) ) );
			
			
			addInitializer( new A3DDisplayObjectClass( RadialDot,8 ) );
			
			
			
			addAction( new Age( ) );
			
			addAction( new Move( ) );
			
			addAction( new LinearDrag( 1 ) );
			
			addAction( new Accelerate( new Vector3D( 0, 40, 0 ) ) );
			
			addAction( new ColorChange( 0xFFFFCC00, 0x00CC0000 ) );
			
			addAction( new ScaleImage( 1, 1.5 ) );
			
			addAction( new RotateToDirection() );
			
		}
		
	}
	
}

