package
{
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.actions.Fade;
	import org.flintparticles.common.actions.ScaleImage;
	import org.flintparticles.common.counters.Steady;
	import org.flintparticles.common.displayObjects.RadialDot;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.threeD.actions.LinearDrag;
	import org.flintparticles.threeD.actions.Move;
	import org.flintparticles.threeD.actions.RandomDrift;
	import org.flintparticles.threeD.away3d.initializers.A3DDisplayObjectClass;
	import org.flintparticles.threeD.emitters.Emitter3D;
	import org.flintparticles.threeD.initializers.Velocity;
	import org.flintparticles.threeD.zones.ConeZone;
	
	import flash.geom.Vector3D;
	
	public class Smoke extends Emitter3D
	{
		public function Smoke()
		{
			counter = new Steady( 9 );
			
			addInitializer( new Lifetime( 11, 12 ) );
			addInitializer( new Velocity( new ConeZone( new Vector3D( 0, 0, 0 ), new Vector3D( 0, 1, 0 ), 0.5, 40, 30 ) ) );
			addInitializer( new A3DDisplayObjectClass( RadialDot, 10 ) );
			
			addAction( new Age( ) );
			addAction( new Move( ) );
			addAction( new LinearDrag( 0.01 ) );
			addAction( new ScaleImage( 1, 15 ) );
			addAction( new Fade( 0.15, 0 ) );
			addAction( new RandomDrift( 15, 15, 15 ) );
		}
	}
}