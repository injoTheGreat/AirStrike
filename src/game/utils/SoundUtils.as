package game.utils
{
	import game.MainManager;
	
	import mx.core.SoundAsset;

	public class SoundUtils
	{
		public static function play(sound:SoundAsset):void{
			if(MainManager.inst.soundEnabled && sound){
				sound.play();
			}
		}
	}
}