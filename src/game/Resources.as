package game
{
    import mx.core.SoundAsset;
    
    import game.utils.GraphicsResource;

    /**
    * resource place holder
    */
    public class Resources
    {
		//images
		
		//player 
        [Embed(source="assets/images/airplanes/brownPlane.png")]
        private static var planeAsset:Class;
		
		// enemies
		[Embed(source="assets/images/airplanes/smallblueplane.png")]
		private static var bluePlane:Class;
		[Embed(source="assets/images/airplanes/smallgreenplane.png")]
		private static var greenPlane:Class;
		[Embed(source="assets/images/airplanes/smallwhiteplane.png")]
		private static var whitePlane:Class;
		[Embed(source="assets/images/airplanes/coolPlane.png")]
		private static var coolPlane:Class;
		[Embed(source="assets/images/airplanes/plane.png")]
		private static var aircraft:Class;
		[Embed(source="assets/images/airplanes/bomber_1.png")]
		private static var bomber1:Class;
		[Embed(source="assets/images/airplanes/bomber_2.png")]
		private static var bomber2:Class;
		[Embed(source="assets/images/airplanes/f-16.png")]
		private static var f16:Class;
		
		[Embed(source="assets/images/anti-aicraft/anti_aircraft.png")]
		private static var antiAircraft:Class;
		[Embed(source="assets/images/anti-aicraft/anti_aircraft1.png")]
		private static var antiAircraft1:Class;
		
		[Embed(source="assets/images/airplanes/aircraft.png")]
		private static var aircraft1:Class;
		[Embed(source="assets/images/airplanes/longsword_fighter.png")]
		private static var masterAircraft:Class;
		
		// weapons
		[Embed(source="assets/images/weapons/2bullets.png")]
		private static var twoBullets:Class;
		[Embed(source="assets/images/weapons/3bullets.png")]
		private static var threeBullets:Class;
		[Embed(source="assets/images/weapons/onebullet.png")]
		private static var oneBullet:Class;
		[Embed(source="assets/images/weapons/roundbullet.png")]
		private static var roundbullets:Class;
		[Embed(source="assets/images/weapons/rocket.png")]
		private static var missileWeapon:Class;

		// explosions
		[Embed(source="assets/images/weapons/blast2.png")]
		private static var explosion:Class;
		[Embed(source="assets/images/weapons/hitEnemy1.png")]
		private static var hitEnemy:Class;
		[Embed(source="assets/images/weapons/hitPlayer.png")]
		private static var hitPlayer:Class;
		
		// background items
		[Embed(source="assets/images/islands/niceisland.png")]
		private static var bigIsland:Class;
		[Embed(source="assets/images/islands/niceisland1.png")]
		private static var bigIsland1:Class;
		[Embed(source="assets/images/islands/niceisland2.png")]
		private static var bigIsland2:Class;

		[Embed(source="assets/images/islands/bigisland.png")]
		private static var island:Class;
		[Embed(source="assets/images/islands/bigisland1.png")]
		private static var island1:Class;
		
		[Embed(source="assets/images/islands/smallisland.png")]
		private static var smallIsland:Class;
		[Embed(source="assets/images/islands/smallisland1.png")]
		private static var smallIsland1:Class;
		
		[Embed(source="assets/images/islands/volcanoisland.png")]
		private static var volcanoIsland:Class;
		 
		[Embed(source="assets/images/cloud.png")]
		private static var cloud:Class;
		
		// background pick-up items
		[Embed(source="assets/images/weapons/ammo_2.png")]
		private static var weapon2BulletsItem:Class;
		[Embed(source="assets/images/weapons/ammo_3.png")]
		private static var weapon3BulletsItem:Class;
		[Embed(source="assets/images/weapons/ammo_Box_P4F_31x25.png")]
		private static var ammoBoxItem:Class;
		[Embed(source="assets/images/energy.png")]
		private static var helpItem:Class;
		[Embed(source="assets/images/weapons/rocket_straight_up.png")]
		private static var missileItem:Class;
		
		//sounds
		
		[Embed(source="assets/sounds/sfx/gun1.mp3")]
		private static var gun1:Class;
		[Embed(source="assets/sounds/sfx/silencer.mp3")]
		private static var gun2:Class;
		[Embed(source="assets/sounds/sfx/one_shot.mp3")]
		private static var oneShot:Class;
		[Embed(source="assets/sounds/sfx/threeRoundFiring.mp3")]
		private static var threeRoundShot:Class;
		[Embed(source="assets/sounds/sfx/rocket_launch.mp3")]
		private static var rocketLaunch:Class;
		[Embed(source="assets/sounds/sfx/anti_aircraft_gun.mp3")]
		private static var antiAircraftShot:Class;
		
		[Embed(source="assets/sounds/sfx/explosion.mp3")]
		private static var explosionSound:Class;
		[Embed(source="assets/sounds/sfx/missileHit.mp3")]
		private static var missileHitSound:Class;

		[Embed(source="assets/sounds/sfx/pick_up_item.mp3")]
		private static var pickUpItem:Class;
		[Embed(source="assets/sounds/sfx/pick_up_item2.mp3")]
		private static var pickUpItem2:Class;
		[Embed(source="assets/sounds/sfx/pick_up_item1.mp3")]
		private static var pickUpItem1:Class;
		
		
		[Embed(source="assets/sounds/sfx/flyingLoad.mp3")]
		private static var gameLoad:Class;
		[Embed(source="assets/sounds/music/mainMenu2.mp3")]
		private static var mainMenu:Class;
		[Embed(source="assets/sounds/music/gameplay.mp3")]
		private static var gameplay:Class;
		[Embed(source="assets/sounds/music/duel.mp3")]
		private static var duel:Class;
		[Embed(source="assets/sounds/music/mission_failed.mp3")]
		private static var gameOver:Class;
		
        // player/enemy bjects
        public static var WarriorPlaneGraphics:GraphicsResource = new GraphicsResource(new planeAsset(), 3, 30);
		public static var WhiteEnemy:GraphicsResource = new GraphicsResource(new whitePlane(), 3, 20);
		public static var GreenEnemy:GraphicsResource = new GraphicsResource(new greenPlane(), 3, 20);
		public static var BlueEnemy:GraphicsResource = new GraphicsResource(new bluePlane(), 3, 20);
		public static var CoolPlaneEnemy:GraphicsResource = new GraphicsResource(new coolPlane(), 3, 20);
		public static var AircraftEnemy:GraphicsResource = new GraphicsResource(new aircraft(), 1, 55);
		public static var BomberAirCraftEnemy1:GraphicsResource = new GraphicsResource(new bomber1(), 1, 55);
		public static var BomberAirCraftEnemy2:GraphicsResource = new GraphicsResource(new bomber2(), 1, 55);
		public static var F16Enemy:GraphicsResource = new GraphicsResource(new f16(), 1, 55);
		public static var AntiAicraft:GraphicsResource = new GraphicsResource(new antiAircraft());
		public static var AntiAicraft1:GraphicsResource = new GraphicsResource(new antiAircraft1());
		public static var AircraftMasterHelp:GraphicsResource = new GraphicsResource(new aircraft1(), 1, 55);
		public static var MasterEnemy:GraphicsResource = new GraphicsResource(new masterAircraft(), 1, 55);
		
		// weapon items
		public static var TwoBullets:GraphicsResource = new GraphicsResource(new twoBullets());
		public static var ThreeBullets:GraphicsResource = new GraphicsResource(new threeBullets());
		public static var OneBullet:GraphicsResource = new GraphicsResource(new oneBullet());
		public static var RoundBullets:GraphicsResource = new GraphicsResource(new roundbullets());
		public static var MissileWeapon:GraphicsResource = new GraphicsResource(new missileWeapon());
		
		//background items
		public static var BigIslandGraphics:GraphicsResource = new GraphicsResource(new bigIsland());
		public static var BigIsland1Graphics:GraphicsResource = new GraphicsResource(new bigIsland1());
		public static var BigIsland2Graphics:GraphicsResource = new GraphicsResource(new bigIsland2());
		public static var IslandGraphics:GraphicsResource = new GraphicsResource(new island());
		public static var Island1Graphics:GraphicsResource = new GraphicsResource(new island1());
		public static var SmallIslandGraphics:GraphicsResource = new GraphicsResource(new smallIsland());
		public static var SmallIsland1Graphics:GraphicsResource = new GraphicsResource(new smallIsland1());
		public static var VolcanoIslandGraphics:GraphicsResource = new GraphicsResource(new volcanoIsland());
		public static var CloudGraphics:GraphicsResource = new GraphicsResource(new cloud());
		
		// background pickUp items
		public static var Weapon2BulletsItem:GraphicsResource = new GraphicsResource(new weapon2BulletsItem());
		public static var Weapon3BulletsItem:GraphicsResource = new GraphicsResource(new weapon3BulletsItem());
		public static var AmmoBoxItem:GraphicsResource = new GraphicsResource(new ammoBoxItem());
		public static var HelpItem:GraphicsResource = new GraphicsResource(new helpItem());
		public static var MissileItem:GraphicsResource = new GraphicsResource(new missileItem());
		
		// explosions
		public static var ExplosionGraphics:GraphicsResource = new GraphicsResource(new explosion(), 12, 30);
		public static var MissileHit:GraphicsResource = new GraphicsResource(new hitEnemy(), 4, 30);
		public static var MissileHit1:GraphicsResource = new GraphicsResource(new hitPlayer(), 5, 40);
		
		// sounds
		public static var GunSound1:SoundAsset = new gun1() as SoundAsset;
		public static var GunSound2:SoundAsset = new gun2() as SoundAsset;
		public static var EnemyOneShot:SoundAsset = new oneShot() as SoundAsset;
		public static var ThreeRoundShot:SoundAsset = new threeRoundShot() as SoundAsset;
		public static var RocketLaunchSound:SoundAsset = new rocketLaunch() as SoundAsset;
		public static var AntiAircraftSound:SoundAsset = new antiAircraftShot() as SoundAsset;
		
		public static var ExplosionSound:SoundAsset = new explosionSound() as SoundAsset;	
		public static var MissileHitSound:SoundAsset = new missileHitSound() as SoundAsset;
		public static var PickUpItemSound:SoundAsset = new pickUpItem() as SoundAsset;
		public static var PickUpItem1Sound:SoundAsset = new pickUpItem1() as SoundAsset;
		public static var PickUpItem2Sound:SoundAsset = new pickUpItem2() as SoundAsset;
		
		public static var GameLoadSound:SoundAsset = new gameLoad() as SoundAsset;
		public static var MainMenuGameSound:SoundAsset = new mainMenu() as SoundAsset;
		public static var GameplaySound:SoundAsset = new gameplay() as SoundAsset;
		public static var DuelSound:SoundAsset = new duel() as SoundAsset;
		public static var GameOverSound:SoundAsset = new gameOver() as SoundAsset;
		
    }
}