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

	var audioFiles: [Data] = [Data] ()				// The audio files data
	var fileDurations: [Int] = [Int] ()					// The duration in ms of each elementary file in the voice, stored in the voice folder
	var fileNameDict: [Int: String] = [Int: String] ()	// Dictionary of file names for unique phrase keys
	var durationDict: [String: Int] = [String: Int] ()	// Dictionary of durations for file names
	var speakDict: [Int: String] = [Int: String] ()		// Dictionary of text to speech strings for unique phrase keys

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
	
	func encode(with aCoder: NSCoder)
	{
		aCoder.encode(language, forKey: languageKey)
		aCoder.encode(locale, forKey: localeKey)
		aCoder.encode(voiceName, forKey: voiceNameKey)
		
		aCoder.encode(audioFiles, forKey: audioFilesKey)
		aCoder.encode(fileDurations, forKey: fileDurationsKey)
		aCoder.encode(fileNameDict, forKey: fileDictKey)
		aCoder.encode(durationDict, forKey: durationDictKey)
		aCoder.encode(speakDict, forKey: speakDictKey)
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		_language = aDecoder.decodeObject(forKey: languageKey) as! String
		_locale = aDecoder.decodeObject(forKey: localeKey) as! String
		_voiceName = aDecoder.decodeObject(forKey: voiceNameKey) as! String
		let name = _voiceName as NSString
		if (name.length == 0) {
			return
		}
		
		audioFiles = aDecoder.decodeObject(forKey: audioFilesKey) as! [Data]
		fileDurations = aDecoder.decodeObject(forKey: fileDurationsKey) as! [Int]
		fileNameDict = aDecoder.decodeObject(forKey: fileDictKey) as! [Int: String]
		durationDict = aDecoder.decodeObject(forKey: durationDictKey) as! [String: Int]
		speakDict = aDecoder.decodeObject(forKey: speakDictKey) as! [Int: String]
	}

}
