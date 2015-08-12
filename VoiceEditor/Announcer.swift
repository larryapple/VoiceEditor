//
//  Copyright © 2015 Rivergate Software. All rights reserved.
//

import AVFoundation

public
class Announcer {

	private
	static let delegate = AnnouncerDelegate ()
	
	private
	static var speechSynthesizer: NSSpeechSynthesizer =
	{
		let result = NSSpeechSynthesizer (voice: nil)!
		result.delegate = delegate
		
		return result
	} ()
	
	static let playerVoice = "com.apple.speech.synthesis.voice.daniel"
	
	private
	static var pendingSpeeches: [String] = []
	var isSilent: Bool = false

	func speak (speech: String)
	{
		guard !isSilent else { return }
		
		let voice = Announcer.playerVoice
		
		Announcer.pendingSpeeches.append (speech)
		
		if Announcer.pendingSpeeches.count == 1
		{
			dispatch_async (dispatch_get_global_queue (QOS_CLASS_USER_INITIATED, 0))
				{
					Announcer.speechSynthesizer.setVoice (voice)
					Announcer.speechSynthesizer.startSpeakingString (speech)
			}
		}
	}
}

class AnnouncerDelegate: NSObject, NSSpeechSynthesizerDelegate
{
	func speechSynthesizer (sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool)
	{
		precondition (NSThread.isMainThread (), "Speech must finish on main thread")
		
		//	Discard the utterance that was being spoken
		
		if (Announcer.pendingSpeeches.count > 0) {
			Announcer.pendingSpeeches.removeAtIndex (0) }
		
		//	Look for the next utterance
		
		guard let speech = Announcer.pendingSpeeches.first else { return }
		
		dispatch_async (dispatch_get_global_queue (QOS_CLASS_USER_INITIATED, 0)) {
			
			Announcer.speechSynthesizer.setVoice (Announcer.playerVoice)
			Announcer.speechSynthesizer.startSpeakingString (speech)
		}
	}
}
