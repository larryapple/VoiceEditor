//
//  Copyright © 2015 Rivergate Software. All rights reserved.
//

import Foundation

enum Phrase: Int
{
	//	First, the simple phrases
	
	case DealingYou, DealingYou2, DealingThem, DealingMe, ScoreHeels,
	Go, Pass, Play15, Play31, Points1Go, Points1Last,
	ForYouHand, ForYou2Hand, ForThemHand, ForMeHand, ForYouCrib, ForThemCrib, ForMeCrib, ScoreNone,
	YouWon, YouWonSkunky, YouWonDoubleSkunky, TheyWon, TheyWonSkunky, TheyWonDoubleSkunky,
	
	//	Then the 7 ways points are scored and summed during the play
	
	PointsGo, PointsLast, PointsPair, PointsPairs3, PointsPairs6, PointsRun, Points31,
	
	//	The 15 ways points are scored when counting the hand, when they are the first score
	
	ScoreFifteen, ScorePair, ScorePairs2, ScorePairs3, ScorePairs6,
	ScoreRun3, ScoreRun4, ScoreRun5, ScoreDoubleRun3, ScoreDoubleRun4,
	ScoreTripleRun, ScoreDoubleDoubleRun, ScoreFlush4, ScoreFlush5, ScoreNobs,
	
	//	The last 14 score phrases are repeated with "and" in front, when they are not the first score
	
	AndScorePair, AndScorePairs2, AndScorePairs3, AndScorePairs6,
	AndScoreRun3, AndScoreRun4, AndScoreRun5, AndScoreDoubleRun3, AndScoreDoubleRun4,
	AndScoreTripleRun, AndScoreDoubleDoubleRun, AndScoreFlush4, AndScoreFlush5, AndScoreNobs,
	Count
}

class Voice : NSObject, NSCoding

{
	//	The file names used for the audio files created for import, in the same sequence as above
	
	static var fileNames: [String] =
	[
		"Deal_1", "Deal_2", "Deal_3", "Deal_4", "Deal_5",
		"Play_1", "Play_2", "Play_3", "Play_4", "Play_5", "Play_6",
		"Hand_1", "Hand_2", "Hand_3","Hand_4", "Hand_5", "Hand_6", "Hand_7", "Hand_8",
		"Won_1", "Won_2", "Won_3", "Won_4", "Won_5", "Won_6",
		
		"Points_1", "Points_2", "Points_3", "Points_4", "Points_5", "Points_6", "Points_7",
		
		"Score_1", "Score_2", "Score_3", "Score_4", "Score_5",
		"Score_6", "Score_7", "Score_8", "Score_9", "Score_10", "Score_11", "Score_12",
		"Score_13", "Score_14", "Score_15",
		
		"And_2", "And_3", "And_4", "And_5", "And_6", "And_7", "And_8", "And_9",
		"And_10", "And_11", "And_12", "And_13", "And_14", "And_15"
	]
	
	//	The durations can be adjusted between any point or score name and the score value,
	//	but the "and" scores use the same value as their corresponding first score, so are not included
	
	static var durationAdjustKeys: [String] =
	[
		"ptsGo", "ptsLast", "ptsPair", "pts3Pairs", "pts6Pairs", "ptsRun", "pts31",
		"15", "pair", "2pair", "3pairs", "6pairs",
		"run", "4run", "5run", "dblRun", "dbl4Run",
		"tplRun", "dblDblRun", "flush", "5flush", "nobs",
		"pair", "2pair", "3pairs", "6pairs",
		"run", "4run", "5run", "dblRun", "dbl4Run",
		"tplRun", "dblDblRun", "flush", "5flush", "nobs"
	]
	
	//	The language (2 characters), locale (2 characters), and name of the voice
	
	var	language: String = "en"
	var locale: String = "us"
	var voiceName: String = ""
	
	//	The durations of all the phrases (61), plus the numbers 1-31 twice, once as spoken in the middle of a sentence and once as spoken at the end
	
	var durations: [Int] = [Int] (count: 123, repeatedValue: 0)
	
	//	The dictionary of duration adjustments is created from the text field
	
	var durationAdjustments = [String: Int] ()
	var _daText: NSString = NSString ()
	var durationAdjustmentsText: String {
		get {return String (_daText)}
		set
		{
			_daText = newValue
			durationAdjustments.removeAll()
			repeat {
				let range: NSRange = _daText.rangeOfString("\n")
				var index = range.location
				if (range.length == 0)
				{
					break
				}
				
				let str: NSString = _daText.substringToIndex(index)
				if (str.length == 0)
				{
					_daText = _daText.substringFromIndex(1)
					continue
				}
				_daText = _daText.substringFromIndex(index + 1)
				let range2: NSRange = str.rangeOfString(":")
				index = range2.location
				let key = str.substringToIndex(index)
				index++
				let valueStr = str.substringFromIndex(index)
				let value = Int (valueStr)
				
				durationAdjustments [key] = value;
				
			} while true
		}
	}
	
	//	The audio files
	
	var audioFiles: [NSData] = [NSData] (count: 123, repeatedValue: NSData ())
	
	//	Keys for coding and decoding
	
	let languageKey = "language"
	let localeKay = "locale"
	let voiceNameKey = "voiceName"
	let durationsCountKey = "durationsCount"
	let durationKey = "duration"
	let durationAdjustmentsKey = "durationAdjustments"
	let audioFileKey = "audioFile"
	
	// MARK: NSCoding
	
	override init ()
	{
		super.init()
	}
	
	func encodeWithCoder(aCoder: NSCoder)
	{
		aCoder.encodeObject(language, forKey: languageKey)
		aCoder.encodeObject(locale, forKey: localeKay)
		aCoder.encodeObject(voiceName, forKey: voiceNameKey)
		
		aCoder.encodeInt32(Int32 (durations.count), forKey: durationsCountKey)
		for (var i = 0; i < durations.count; i++)
		{
			aCoder.encodeInt32(Int32 (durations[i]), forKey: durationKey)
		}
		
		aCoder.encodeObject(_daText, forKey: durationAdjustmentsKey)
		
		for (var i = 0; i < durations.count; i++)
		{
			let data = audioFiles [i]
			aCoder.encodeObject(data, forKey: audioFileKey)
		}
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		language = aDecoder.decodeObjectForKey(languageKey) as! String
		locale = aDecoder.decodeObjectForKey(localeKay) as! String
		voiceName = aDecoder.decodeObjectForKey(voiceNameKey) as! String
		
		durations.removeAll()
		let durationsCount = aDecoder.decodeInt32ForKey(durationsCountKey)
		for (var i = 0; i < Int(durationsCount); i++)
		{
			let duration: Int = Int (aDecoder.decodeInt32ForKey(durationKey))
			durations.append(duration)
		}
		
		_daText = aDecoder.decodeObjectForKey(durationAdjustmentsKey) as! NSString
		
		audioFiles.removeAll()
		for (var i = 0; i < durations.count; i++)
		{
			let data: NSData = aDecoder.decodeObjectForKey(audioFileKey) as! NSData
			audioFiles.append(data)
		}
	}

	// MARK: Accessors
	
	func dataforPhrase (phrase: Phrase) -> NSData
	{
		return audioFiles [phrase.rawValue]
	}
	
	func dataForNumber (number: Int, isLast: Bool) ->NSData
	{
		let index = (isLast ? 91 : 60) + number
		return audioFiles [index]
	}
	
	func durationForPhrase (phrase: Phrase) ->Int
	{
		return Int (durations [phrase.rawValue])
	}
	
	func durationForNumber (number: Int, isLast: Bool) -> Int
	{
		let index = (isLast ? 91 : 60) + number
		return Int (durations [index])
	}
	
}