//
//  Copyright © 2015 Rivergate Software. All rights reserved.
//

import Foundation

class Voice : NSObject, NSCoding
{
	//	The language (2 characters), locale (2 characters), and name of the voice
	
	var	_language: String
	var	language: String {
		get {return _language}
		set {_language = newValue}
	}
	var _locale: String
	var locale: String {
		get {return _locale}
		set {_locale = newValue}
	}
	var _voiceName: String
	var voiceName: String {
		get {return _voiceName}
		set {_voiceName = newValue}
	}

	var audioFiles: [NSData] = [NSData] ()				// The audio files data
	var fileDurations: [Int] = [Int] ()					// The duration in ms of each elementary file in the voice, stored in the voice folder
	var fileDict: [Int: String] = [Int: String] ()		// Dictionary of file names for elementary phrase keys
	var durationDict: [Int: Int] = [Int: Int] ()		// Dictionary of durations for elementary phrase keys
	var speakDict: [Int: String] = [Int: String] ()		// Dictionary of text to speech strings for elementary phrase keys

	let languageKey = "language"
	let localeKey = "locale"
	let voiceNameKey = "voiceName"
	
	let audioFilesKey = "audioFiles"
	let fileDurationsKey = "fileDurations"
	let fileDictKey = "fileDictKey"
	let durationDictKey = "durationDictKey"
	let speakDictKey = "speakDictKey"

	override init ()
	{
		_language = ""
		_locale = ""
		_voiceName = ""
		super.init()
	}
	
	func encodeWithCoder(aCoder: NSCoder)
	{
		aCoder.encodeObject(language, forKey: languageKey)
		aCoder.encodeObject(locale, forKey: localeKey)
		aCoder.encodeObject(voiceName, forKey: voiceNameKey)
		
		aCoder.encodeObject(audioFiles, forKey: audioFilesKey)
		aCoder.encodeObject(fileDurations, forKey: fileDurationsKey)
		aCoder.encodeObject(fileDict, forKey: fileDictKey)
		aCoder.encodeObject(durationDict, forKey: durationDictKey)
		aCoder.encodeObject(speakDict, forKey: speakDictKey)
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		_language = aDecoder.decodeObjectForKey(languageKey) as! String
		_locale = aDecoder.decodeObjectForKey(localeKey) as! String
		_voiceName = aDecoder.decodeObjectForKey(voiceNameKey) as! String
		
		audioFiles = aDecoder.decodeObjectForKey(audioFilesKey) as! [NSData]
		fileDurations = aDecoder.decodeObjectForKey(fileDurationsKey) as! [Int]
		fileDict = aDecoder.decodeObjectForKey(fileDictKey) as! [Int: String]
		durationDict = aDecoder.decodeObjectForKey(durationDictKey) as! [Int: Int]
		speakDict = aDecoder.decodeObjectForKey(speakDictKey) as! [Int: String]
	}

}