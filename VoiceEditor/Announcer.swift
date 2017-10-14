//
//  Copyright © 2015 Rivergate Software. All rights reserved.
//

import AppKit

open
class Announcer {

	fileprivate
	static let delegate = AnnouncerDelegate ()
	
	fileprivate
	static var speechSynthesizer: NSSpeechSynthesizer =
	{
		let result = NSSpeechSynthesizer (voice: nil)!
		result.delegate = delegate
		
		return result
	} ()
	
	static var _playerVoice: String = "com.apple.speech.synthesis.voice.samantha"
	
	static var playerVoice: String {
		get {return Announcer._playerVoice}
		set {Announcer._playerVoice = "com.apple.speech.synthesis.voice." + newValue}
	}
	
	fileprivate
	static var pendingSpeeches: [String] = []
	static var isSilent: Bool = false

	static func speak (_ voice: String, speech: String)
	{
		guard !Announcer.isSilent else { return }
		
		Announcer.pendingSpeeches.append (speech)
		
		if Announcer.pendingSpeeches.count == 1
		{
			DispatchQueue.global (qos: DispatchQoS.QoSClass.userInitiated).async 
				{
					Announcer.speechSynthesizer.setVoice ("com.apple.speech.synthesis.voice." + voice.lowercased())
					Announcer.speechSynthesizer.startSpeaking (speech)
			}
		}
	}
}

class AnnouncerDelegate: NSObject, NSSpeechSynthesizerDelegate
{
	func speechSynthesizer (_ sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool)
	{
		precondition (Thread.isMainThread, "Speech must finish on main thread")
		
		//	Discard the utterance that was being spoken
		
		if (Announcer.pendingSpeeches.count > 0) {
			Announcer.pendingSpeeches.remove (at: 0) }
		
		//	Look for the next utterance
		
		guard let speech = Announcer.pendingSpeeches.first else { return }
		
		DispatchQueue.global (qos: DispatchQoS.QoSClass.userInitiated).async  {
			
			Announcer.speechSynthesizer.startSpeaking (speech)
		}
	}
}
