package game.utils
{
	import flash.media.SoundChannel;
	
	import mx.core.SoundAsset;
	
	import game.MainManager;

	/**
	 * Class representing sound assets manipulation
	 * @author nmilic
	 * 
	 */	
	public class SoundUtils
	{
		private static var _currentMusic:SoundChannel;
	
		public static function playSFX(sound:SoundAsset):void
		{
			if(MainManager.inst.soundEnabled && sound)
			{
				sound.play();
			}
		}
		
		// reserved for the main music themes - main menu, gameplay, etc
		public static function playMusic(sound:SoundAsset, repeatCount:int = 10):void
		{
			if(MainManager.inst.musicEnabled && sound)
			{
				_currentMusic = sound.play(0, repeatCount); 
			}
		}
		
		public static function stop():void
		{
			if (_currentMusic)
				_currentMusic.stop();
		}
	}
}