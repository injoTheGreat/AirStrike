package game.events
{
	import flash.events.Event;
	
	import game.objects.WeaponDefinition;
	
	public class CollectItemEvent extends Event
	{
		public static const AMMUNITION_RELOAD:String = "reload_weapon_ammunition";
		public static const PLAYER_ENERGY_REFILL:String = "refill_player_energy";
		public static const PLAYER_WEAPON_CHANGED:String = "player_weapon_changed";
		public static const ENEMY_WEAPON_CHANGED:String = "enemy_weapon_changed";
		
		private var _weaponDef:WeaponDefinition;
		
		public function CollectItemEvent(type:String, weapon:WeaponDefinition=null)
		{
			super(type);
			this._weaponDef = weapon;
		}
		
		public function get weapon():WeaponDefinition
		{
			return _weaponDef; 
		}
		
		public override function clone():Event
		{
			return new CollectItemEvent(type, weapon);
		}
	}
}