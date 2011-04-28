package
{
	import flash.geom.Vector3D;
	
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.actions.Fade;
	import org.flintparticles.common.counters.Steady;
	import org.flintparticles.common.displayObjects.RadialDot;
	import org.flintparticles.common.initializers.ColorInit;
	import org.flintparticles.common.initializers.ColorsInit;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.threeD.actions.Accelerate;
	import org.flintparticles.threeD.actions.Move;
	import org.flintparticles.threeD.away3d.initializers.A3DDisplayObjectClass;
	import org.flintparticles.threeD.emitters.Emitter3D;
	import org.flintparticles.threeD.initializers.Velocity;
	import org.flintparticles.threeD.zones.DiscZone;
	
	public class Fountain extends Emitter3D {
		
		public var colours:ColorsInit;
		
		public function Fountain() {
			counter = new Steady( 20 );
			
			colours = new ColorsInit([0xFFFFFFFF, 0xaaffffff, 0x33ffffff], [0.5, 0.5, 0.5]);
			
			
			
			addInitializer( colours ); // green
			//addInitializer( new ColorInit( 0xFFCCCCFF, 0xFF6666FF ) ); // blue
			//addInitializer( new ColorInit( 0xFFFFFFFF, 0xFFFF6666 ) ); // red
			//addInitializer( new ColorInit( 0xFFFFFFFF, 0xFF66ff66 ) ); // green
			
			addInitializer( new Velocity( new DiscZone( new Vector3D( 0, -200, 0 ), new Vector3D( 0, 1, 0 ), 60 ) ) );
			addInitializer( new Lifetime( 4.2 ) );
			addInitializer( new A3DDisplayObjectClass( RadialDot, 30 ) );
			
			addAction( new Move() );
			addAction( new Accelerate( new Vector3D( 0, 150, 0 ) ) );
			addAction( new Age() );
			addAction( new Fade() );
		}
	}
}