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
        [Embed(source="assets/images/brownplane.png")]
        private static var planeAsset:Class;
		
		// enemies
		[Embed(source="assets/images/smallblueplane.png")]
		private static var bluePlane:Class;
		[Embed(source="assets/images/smallgreenplane.png")]
		private static var greenPlane:Class;
		[Embed(source="assets/images/smallwhiteplane.png")]
		private static var whitePlane:Class;
		
		// weapons
		[Embed(source="assets/images/twobullets.png")]
		private static var twoBullets:Class;
		[Embed(source="assets/images/onebullet.png")]
		private static var oneBullet:Class;
		[Embed(source="assets/images/roundbullet.png")]
		private static var roundbullets:Class;

		
		// explosions
		[Embed(source="assets/images/blast2.png")]
		private static var explosion:Class;
		[Embed(source="assets/images/hitEnemy.png")]
		private static var hitEnemy:Class;
		[Embed(source="assets/images/hitPlayer.png")]
		private static var hitPlayer:Class;
		
		// background items
		[Embed(source="assets/images/niceisland.png")]
		private static var bigIsland:Class;

		[Embed(source="assets/images/bigisland.png")]
		private static var island:Class;
		
		[Embed(source="assets/images/smallisland.png")]
		private static var smallIsland:Class;
		
		[Embed(source="assets/images/volcanoisland.png")]
		private static var volcanoIsland:Class;
		 
		[Embed(source="assets/images/cloud.png")]
		private static var cloud:Class;
		
		// background pickUp items
		[Embed(source="assets/images/ammo_2.png")]
		private static var weapon2BulletsItem:Class;
		[Embed(source="assets/images/ammo_3.png")]
		private static var weapon3BulletsItem:Class;
		[Embed(source="assets/images/ammo_Box_P4F_31x25.png")]
		private static var ammoBoxItem:Class;
		[Embed(source="assets/images/energy.png")]
		private static var helpItem:Class;
		
		//sounds
		
		[Embed(source="assets/sounds/gun1.mp3")]
		private static var gun1:Class;
		[Embed(source="assets/sounds/silencer.mp3")]
		private static var gun2:Class;
		[Embed(source="assets/sounds/one_shot.mp3")]
		private static var oneShot:Class;
		[Embed(source="assets/sounds/three_round_shot.mp3")]
		private static var threeRoundShot:Class;
		
		[Embed(source="assets/sounds/explosion.mp3")]
		private static var explosionSound:Class;
		[Embed(source="assets/sounds/missileHit.mp3")]
		private static var missileHitSound:Class;

		[Embed(source="assets/sounds/pick_up_item.mp3")]
		private static var pickUpItem:Class;
		[Embed(source="assets/sounds/pick_up_item2.mp3")]
		private static var pickUpItem2:Class;
		[Embed(source="assets/sounds/pick_up_item1.mp3")]
		private static var pickUpItem1:Class;
		
        // player/enemy bjects
        public static var WarriorPlaneGraphics:GraphicsResource = new GraphicsResource(new planeAsset(), 3, 30);
		public static var WhiteEnemy:GraphicsResource = new GraphicsResource(new whitePlane(), 3, 20);
		public static var GreenEnemy:GraphicsResource = new GraphicsResource(new greenPlane(), 3, 20);
		public static var BlueEnemy:GraphicsResource = new GraphicsResource(new bluePlane(), 3, 20);
		
		// weapon items
		public static var TwoBullets:GraphicsResource = new GraphicsResource(new twoBullets());
		public static var OneBullet:GraphicsResource = new GraphicsResource(new oneBullet());
		public static var RoundBullets:GraphicsResource = new GraphicsResource(new roundbullets());
		
		//background items
		public static var BigIslandGraphics:GraphicsResource = new GraphicsResource(new bigIsland());
		public static var IslandGraphics:GraphicsResource = new GraphicsResource(new island());
		public static var SmallIslandGraphics:GraphicsResource = new GraphicsResource(new smallIsland());
		public static var VolcanoIslandGraphics:GraphicsResource = new GraphicsResource(new volcanoIsland());
		public static var CloudGraphics:GraphicsResource = new GraphicsResource(new cloud());
		
		// background pickUp items
		public static var Weapon2BulletsItem:GraphicsResource = new GraphicsResource(new weapon2BulletsItem());
		public static var Weapon3BulletsItem:GraphicsResource = new GraphicsResource(new weapon3BulletsItem());
		public static var AmmoBoxItem:GraphicsResource = new GraphicsResource(new ammoBoxItem());
		public static var HelpItem:GraphicsResource = new GraphicsResource(new helpItem());
		
		// explosions
		public static var ExplosionGraphics:GraphicsResource = new GraphicsResource(new explosion(), 12, 30);
		public static var MissileHit:GraphicsResource = new GraphicsResource(new hitEnemy(), 4, 35);
		public static var MissileHit1:GraphicsResource = new GraphicsResource(new hitPlayer(), 5, 40);
		
		// sounds
		public static var GunSound1:SoundAsset = new gun1() as SoundAsset;
		public static var GunSound2:SoundAsset = new gun2() as SoundAsset;
		public static var EnemyOneShot:SoundAsset = new oneShot() as SoundAsset;
		public static var ThreeRoundShot:SoundAsset = new threeRoundShot() as SoundAsset;
		
		public static var ExplosionSound:SoundAsset = new explosionSound() as SoundAsset;	
		public static var MissileHitSound:SoundAsset = new missileHitSound() as SoundAsset;
		public static var PickUpItemSound:SoundAsset = new pickUpItem() as SoundAsset;
		public static var PickUpItem1Sound:SoundAsset = new pickUpItem1() as SoundAsset;
		public static var PickUpItem2Sound:SoundAsset = new pickUpItem2() as SoundAsset;
		
		
    }
}