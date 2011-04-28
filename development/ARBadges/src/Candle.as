package
{
	import flash.geom.Vector3D;
	
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.counters.Steady;
	import org.flintparticles.common.displayObjects.Dot;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.threeD.actions.Accelerate;
	import org.flintparticles.threeD.actions.Move;
	import org.flintparticles.threeD.away3d.initializers.A3DDisplayObjectClass;
	import org.flintparticles.threeD.emitters.Emitter3D;
	import org.flintparticles.threeD.initializers.Position;
	import org.flintparticles.threeD.initializers.Velocity;
	import org.flintparticles.threeD.zones.DiscZone;
	import org.flintparticles.threeD.zones.PointZone;
	
	public class Candle extends Emitter3D
	{
		public function Candle( position:Vector3D )
		{
			counter = new Steady( 30 );
			
			
			
			
			//addInitializer( new SharedImage( new Dot( 1 ) ) );
			addInitializer( new A3DDisplayObjectClass(Dot , 10 ) );
			addInitializer( new ColorInit( 0xFFFFFF00, 0xFFFF6600 ) );
			addInitializer( new Position( new PointZone( position ) ) );
			addInitializer( new Velocity( new DiscZone( new Vector3D( 0, -80, 0 ), new Vector3D( 0, 1, 0 ), 30 ) ) );
			addInitializer( new Lifetime( 2 ) );
			
			addAction( new Move() );
			addAction( new Accelerate( new Vector3D( 0, 50, 0 ) ) );
			addAction( new Age() );
		}
	}
}