//
//  Copyright © 2015 Rivergate Software. All rights reserved.
//

import Cocoa
import AVFoundation

enum AnnouncedPhrase
{
	case CribYour						// "it's your crib"
	case CribMy							// "it's my crib"
	
	case Play (Int)						// <card total>
	
	case Go								// "go"
	case Pass							// "pass"
	
	case PlayFifteen					// "15 for 2"
	case PlayThirtyOne					// "31 for 2"
	
	case PlayedGo1						// "[and] 1 for go"
	case PlayedLast1					// "and 1 for last card"
	
	case PlayedPair (Int)				// "and a pair for <points>"
	case PlayedPairs3 (Int)				// "and a pair royal for <points>"
	case PlayedPairs6 (Int)				// "and a double pair royal for <points>"
	case PlayedRun (Int)				// "and a run for <points>"
	case PlayedGo (Int)					// "and go for <points>"
	case Played31 (Int)					// "and 31 for <points>"
	case PlayedLast	(Int)				// "and last card for <points>"
	
	case CountHandYour					// "in your hand"
	case CountHandMy					// "in my hand"
	case CountCribYour					// "in your crib"
	case CountCribMy					// "in my crib"
	
	case CountedHeels					// "2 for his heels”
	
	case CountedFifteen (Int)			// "fifteen <points>"
	
	case CountedPair					// "[and] a pair is <points>"
	case CountedPairs2					// "[and] 2 pairs is <points>"
	case CountedPairs3					// "[and] 3 pairs is <points>"
	case CountedPairs6					// "[and] 6 pairs is <points>"
	case CountedRun3					// "[and] a run is <points>"
	case CountedRun4					// "[and] a run of 4 is <points>"
	case CountedRun5					// "[and] a run of 5 is <points>"
	case CountedDoubleRun3				// "[and] a double run is <points>"
	case CountedDoubleRun4				// "[and] a double run of 4 is <points>"
	case CountedTripleRun				// "[and] a triple run is <points>"
	case CountedDoubleDoubleRun			// "[and] a double double run is <points>"
	case CountedFlush4					// "[and] 4 of the same suit is <points>"
	case CountedFlush5					// "[and] 5 of the same suit is <points>”
	
	case CountedNobs					// "[and] the right jack is <points>"
	
	case CountedNone					// "no score"
	
	case YouWon							// "you won this game"
	case YouWonSkunky					// "you won this game and they were skunked"
	case YouWonDoubleSkunky				// "you won this game and they were double skunked"
	
	case YouLost						// "you lost this game"
	case YouLostSkunky					// "you lost this game and you were skunked"
	case YouLostDoubleSkunky			// "you lost this game and you were double skunked"
}

struct Card
{
	var rank: Rank
	var suit: Suit
}

class Document: NSDocument, AVAudioPlayerDelegate
{
	// MARK: File names
	
	static let fileNames: [String] =
	[
		"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16",
		"17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31",
		
		"C_1", "C_2", "C_3", "C_4", "C_5", "C_6", "C_7", "C_8", "C_9", "C_10", "C_11",
		"C_12", "C_13", "C_14", "C_15", "C_16", "C_17", "C_18", "C_19", "C_20", "C_21",
		"C_22", "C_23", "C_24", "C_25", "C_26", "C_27", "C_28", "C_29", "C_30", "C_31",
		
		"Game_1", "Game_2", "Game_3", "Game_4", "Game_5", "Game_6", "Game_7", "Game_8",
		"Game_9", "Game_10", "Game_11", "Game_12", "Game_13", "Game_14",
		
		"Play_1", "Play_2", "Play_3", "Play_4", "Play_5", "Play_6", "Play_7", "Play_8",
		"Play_9", "Play_10", "Play_11", "Play_12", "Play_13",
		
		"Fif_1", "Fif_2", "Fif_3", "Fif_4", "Fif_5", "Fif_6", "Fif_7", "Fif_8",
		
		"First_1", "First_2", "First_3", "First_4", "First_5", "First_6", "First_7", "First_8",
		"First_9", "First_10", "First_11", "First_12", "First_13", "First_14", "First_15", "First_16",
		
		"Pair_1", "Pair_2", "Pair_3", "Pair_4", "Pair_5", "Pair_6", "Pair_7", "Pair_8",
		"Pair_9", "Pair_10", "Pair_11", "Pair_12", "Pair_13", "Pair_14", "Pair_15", "Pair_16",
		"Pair_17", "Pair_18", "Pair_19", "Pair_20", "Pair_21", "Pair_22", "Pair_23", "Pair_24",
		"Pair_25", "Pair_26", "Pair_27", "Pair_28", "Pair_29", "Pair_30", "Pair_31", "Pair_32",
		"Pair_33",
		
		"Run_1", "Run_2", "Run_3", "Run_4", "Run_5", "Run_6", "Run_7", "Run_8",
		"Run_9", "Run_10", "Run_11", "Run_12", "Run_13", "Run_14", "Run_15", "Run_16",
		"Run_17", "Run_18", "Run_19", "Run_20", "Run_21", "Run_22",
		
		"Suit_1", "Suit_2", "Suit_3", "Suit_4", "Suit_5", "Suit_6", "Suit_7", "Suit_8",
		"Suit_9", "Suit_10", "Suit_11", "Suit_12", "Suit_13", "Suit_14", "Suit_15", "Suit_16",
		"Suit_17", "Suit_18", "Suit_19", "Suit_20", "Suit_21", "Suit_22", "Suit_23", "Suit_24",
		"Suit_25",
		
		"Jack_1", "Jack_2", "Jack_3", "Jack_4", "Jack_5", "Jack_6", "Jack_7", "Jack_8",
		"Jack_9", "Jack_10", "Jack_11", "Jack_12", "Jack_13", "Jack_14", "Jack_15", "Jack_16",
		"Jack_17", "Jack_18", "Jack_19"
	]
	
	// MARK: Score names
	
	let scorePhrases: [String] =
	[
		"fifteen ", "a pair is ", "2 pairs is ", "3 pairs is ", "6 pairs is ",
		"a run is ", "a run of 4 is ", "a run of 5 is ", "a double run is ", "a double run of 4 is ",
		"a triple run is ", "a double double run is ", "4 of the same suit is ", "5 of the same suit is ",
		"the right jack is "
	]
	
	let scorePhrasesGerman: [String] =
	[
		"fünfzehn", "ein Paar macht ", "2 Paare macht ", "3 Paare macht ", "6 Paare macht ",
		"eine Folge macht ", "eine Folge von 4 macht ", "eine Folge von 5 macht ", "eine Doppelfolge macht ", "eine Doppelfolge von 4 macht ",
		"eine Dreierfolge macht ", "eine Doppeldoppelfolge macht ", "4 derselben Farbe macht ", "5 derselben Farbe macht ",
		"der richtige Bube ist "
	]
	
	let scorePhrasesSpanish: [String] =
	[
		"quince ", "un par gana ", "2 pares ganan ", "3 pares ganan ", "6 pares ganan ",
		"una escalera gana ", "una escalera de 4 gana ", "una escalera de 5 gana ", "una doble-escalera gana ", "una doble-escalera de 4 gana ",
		"una triple-escalera gana ", "una doble-doble-escalera gana ", "4 del mismo palo ganan ", "5 del mismo palo ganan ",
		"la buena sota gana "
	]
	
	//	MARK: Variables required to build and access the data for playing audio files and speaking text
	
	var	language: String = ""
	var locale: String = ""
	var _voiceName: String = ""
	var voiceName: String {
		get {return _voiceName}
		set {_voiceName = newValue}
	}
	
	var fileDurations: [Int] = [Int] ()					// The duration in ms of each elementary file in the voice, stored in the voice folder
	var fileDict: [Int: String] = [Int: String] ()		// Dictionary of file names for elementary phrase keys
	var durationDict: [Int: Int] = [Int: Int] ()		// Dictionary of durations for elementary phrase keys
	var speakDict: [Int: String] = [Int: String] ()		// Dictionary of text to speech strings for elementary phrase keys
	
	// MARK: External call to get the files for counting a hand out loud
	
	func filesForAnnouncedPhrases (phrases: [AnnouncedPhrase]) -> (files: [String], starts: [Double], durations: [Double])
	{
		var fileNames: [String] = [String] ()
		var starts: [Double] = [Double] ()
		var durations: [Double] = [Double] ()
		var fifteens: Int = 0, pairs: Int = 0, runs: Int = 0, suits: Int = 0, jack: Int = 0
		
		for phrase in phrases
		{
			switch (phrase)
			{
			case .CribYour: return filesForFileName("Game_1")
			case .CribMy: return filesForFileName("Game_2")
			case .CountHandYour: return filesForFileName("Game_3")
			case .CountHandMy: return filesForFileName("Game_4")
			case .CountCribYour: return filesForFileName("Game_5")
			case .CountCribMy: return filesForFileName("Game_6")
			case .CountedHeels: return filesForFileName("Game_7")
			case .YouWon: return filesForFileName("Game_8")
			case .YouWonSkunky: return filesForFileName("Game_9")
			case .YouWonDoubleSkunky: return filesForFileName("Game_10")
			case .YouLost: return filesForFileName("Game_11")
			case .YouLostSkunky: return filesForFileName("Game_12")
			case .YouLostDoubleSkunky: return filesForFileName("Game_13")
				
			case .Play(let points): return filesForFileName(String (points))
				
			case .Go: return filesForFileName("Play_1")
			case .Pass: return filesForFileName("Play_2")
			case .PlayFifteen: return filesForFileName("Play_3")
			case .PlayThirtyOne: return filesForFileName("Play_4")
			case .PlayedGo1: return filesForFileName("Play_5")
			case .PlayedLast1: return filesForFileName("Play_6")
				
			case .PlayedPair(let points): return filesForPlayPhrase(phrase, play: points)
			case .PlayedPairs3(let points): return filesForPlayPhrase(phrase, play: points)
			case .PlayedPairs6(let points): return filesForPlayPhrase(phrase, play: points)
			case .PlayedRun(let points): return filesForPlayPhrase(phrase, play: points)
			case .PlayedGo(let points): return filesForPlayPhrase(phrase, play: points)
			case .Played31(let points): return filesForPlayPhrase(phrase, play: points)
			case .PlayedLast(let points): return filesForPlayPhrase(phrase, play: points)
				
			case .CountedFifteen(let points): fifteens = points
			case .CountedPair: pairs += 2
			case .CountedPairs2: pairs = 4
			case .CountedPairs3: pairs += 6
			case .CountedPairs6: pairs = 12
			case .CountedRun3: runs = 3
			case .CountedRun4: runs = 4
			case .CountedRun5: runs = 5
			case .CountedDoubleRun3: pairs = 2; runs = 6
			case .CountedDoubleRun4: pairs = 2; runs = 8
			case .CountedTripleRun: pairs = 6; runs = 9
			case .CountedDoubleDoubleRun: pairs = 2; runs = 12
			case .CountedFlush4: suits = 4
			case .CountedFlush5: suits = 5
			case .CountedNobs: jack = 1
			case .CountedNone: return filesForFileName("Game_14")
			}
		}
		
		let keys: [Int] = keysForScores(fifteens, pairs: pairs, runs: runs, anySuits: suits, rightJack: jack)
		var start = 0.0
		
		for var i = 0; i < keys.count; i++
		{
			let key = keys [i]
			let fileName: String? = fileDict [key]
			if fileName == nil
			{
				print ("missing file name")
				continue
			}
			
			let durationMs = durationDict [key]
			if durationMs == nil
			{
				print ("missing duration")
				continue
			}
			
			fileNames.append(fileName!)
			starts.append(start)
			let duration = Double (durationMs!) / 1000.0
			start += duration
			durations.append(duration)
		}
		
		
		return (fileNames, starts, durations)
	}
	
	func filesForFileName (fileName: String) -> (files: [String], starts: [Double], durations: [Double])
	{
		var fileNames: [String] = [String] (), starts: [Double] = [Double] (), durations: [Double] = [Double] ()
		
		let key = keyForFileName (fileName)
		let durationMs = durationDict [key]
		if durationMs == nil
		{
			print ("missing duration")
		}
			
		else
		{
			fileNames.append (fileName);
			starts.append(0.0)
			durations.append(Double (durationMs!) / 1000.0)
		}
		
		return (fileNames, starts, durations)
	}
	
	func keyForFileName (name: String) -> Int
	{
		for var i = 0; i < Document.fileNames.count; i++
		{
			let fileName = Document.fileNames[i]
			if fileName == name
			{
				return i + (1 << 30)
			}
		}
		
		return 0
	}
	
	
	func filesForPlayPhrase (phrase: AnnouncedPhrase, play: Int) -> (files: [String], starts: [Double], durations: [Double])
	{
		var fileNames: [String] = [String] (), starts: [Double] = [Double] (), durations: [Double] = [Double] ()
		var fileName: String = ""
		var points = 0
		
		switch (phrase)
		{
		case .PlayedPair(let pts):	 fileName = "Play_7"; points = pts
		case .PlayedPairs3(let pts): fileName = "Play_8"; points = pts
		case .PlayedPairs6(let pts): fileName = "Play_9"; points = pts
		case .PlayedRun(let pts):	 fileName = "Play_10"; points = pts
		case .PlayedGo(let pts):	 fileName = "Play_11"; points = pts
		case .Played31(let pts):	 fileName = "Play_12"; points = pts
		case .PlayedLast(let pts):	 fileName = "Play_13"; points = pts
		default: break
		}
		
		var durationMs = durationDict [keyForFileName(fileName)]
		if durationMs == nil
		{
			if durationMs == nil
			{
				print ("missing duration")
				return (fileNames, starts, durations)
			}
		}
		
		fileNames.append (fileName);
		starts.append(0.0)
		
		let duration = Double (durationMs!) / 1000.0
		durations.append(duration)
		
		fileName = String (points)
		durationMs = durationDict [keyForFileName(fileName)]
		if durationMs == nil
		{
			if durationMs == nil
			{
				print ("missing duration")
				return (fileNames, starts, durations)
			}
		}
		
		fileNames.append (fileName);
		starts.append(duration)
		durations.append(Double (durationMs!) / 1000.0)
		return (fileNames, starts, durations)
	}
	
	// MARK: Generate all possible scores
	
	var scoreString: [String] = [String] ()
	
	func generateScores ()
	{
		scoreString = [String] ()
		speakDict = [Int: String] ()
		durationDict = [Int: Int] ()
		
		var avails: [Int] = [Int] (count: 13, repeatedValue: 4)
		var ranks: [Rank] = [Rank] (count: 5, repeatedValue: Rank.Ace)
		var suits: [Suit] = [Suit.Clubs, Suit.Clubs, Suit.Clubs, Suit.Diamonds, Suit.Hearts]
		
		for var i = 0; i < 13; i++
		{
			avails [i]--
			var index = 0
			ranks [index++] = Rank (rawValue: i)!
			for var j = i; j < 13; j++
			{
				avails [j]--
				ranks [index++] = Rank (rawValue: j)!
				for var k = j; k < 13; k++
				{
					avails [k]--
					ranks [index++] = Rank (rawValue: k)!
					for var m = k; m < 13; m++
					{
						avails [m]--
						ranks [index++] = Rank (rawValue: m)!
						for var n = 0; n < 13; n++
						{
							if (avails [n] == 0)
							{
								continue
							}
							
							ranks [index] = Rank (rawValue: n)!
							var cards = Array<Card> ()
							
							//	Evaluate first with no possible suit matches
							
							for (var a = 0; a < 5; a++)
							{
								let card = Card(rank: ranks[a], suit: suits[a])
								cards.append (card)
							}
							
							evaluateHand (cards, anySuits: 0, rightJack: 0)
							
							//	If there is a jack in the hand, make it the right jack
							
							var rightJack: Int = 0
							for (var a = 0; a < 4; a++)
							{
								if ranks[a] == Rank.Jack
								{
									rightJack = 1
									evaluateHand(cards, anySuits: 0, rightJack: rightJack)
									break
								}
							}
							
							//	If there are any pairs in the hand, we are done with suits
							
							var anyPairs = false
							for (var a = 1; a < 4; a++)
							{
								if ranks[a] == ranks[a-1]
								{
									anyPairs = true
									break
								}
							}
							
							//	Evaluate a hand with a 4 or 5-card flush and with the right jack
							
							if !anyPairs
							{
								var anySuits = 5;
								
								//	If the starter matches any card, it cannot be the same suit when we count the 4-card flush
								
								for (var a = 0; a < 4; a++)
								{
									if ranks[a] == ranks[4]
									{
										anySuits = 4
										rightJack = 0
										break
									}
								}
								
								//	First evaluate with and without the right jack
								
								evaluateHand (cards, anySuits: anySuits, rightJack: 0)
								if (rightJack == 1)
								{
									evaluateHand (cards, anySuits: anySuits, rightJack: 1)
								}
								
								//	Then if it is a 5-card flush, do it again for 4 cards
								
								if (anySuits == 5)
								{
									evaluateHand (cards, anySuits: 4, rightJack: 0)
									if (rightJack == 1)
									{
										evaluateHand (cards, anySuits: 4, rightJack: 1)
									}
								}
							}
						}
						avails [m]++
						index--
					}
					avails [k]++
					index--
				}
				avails [j]++
				index--
			}
			avails [i]++
			index--
		}
		
		//	Sort the strings by the generated sort key
		
		scoreString = scoreString.sort { $0.compare($1) == .OrderedAscending }
		
		//		print (String(scoreString.count) + " unique counts")
		//		print (scoreString)
		//		return
		
		//	Create a dictionary of the file names, and an array of the strings with the file name prefix
		
		var stringArray: [String] = [String] ()
		var index = 1, prevPrefix = ""
		fileDict.removeAll()
		durationDict.removeAll() // the duration dictionary will be empty until the file dictionary is reloaded
		
		for item in scoreString
		{
			let str: NSString = item
			let first3 = str.substringToIndex (3)
			var prefix = String (first3)
			let prefixNumber: Int? = Int (prefix)
			if (prefixNumber == nil)
			{
				continue
			}
			
			if (prefixNumber == 0)
			{
				prefix = "Fif_"
			}
				
			else if (prefixNumber < 101)
			{
				prefix = "First_"
			}
				
			else if (prefixNumber < 107)
			{
				prefix = "Pair_"
			}
				
			else if (prefixNumber < 114)
			{
				prefix = "Run_"
			}
				
			else if (prefixNumber < 116)
			{
				prefix = "Suit_"
			}
				
			else
			{
				prefix = "Jack_"
			}
			
			var str2: NSString = str.substringFromIndex (6)
			str2 = str2.substringToIndex (8)
			
			if (prefix != prevPrefix)
			{
				prevPrefix = prefix
				index = 1
			}
			
			//	Create the file dictionary entry
			
			let key = Int (String (str2))
			let fileName: String = prefix + String (index++)
			let oldKey = fileDict [key!]
			
			if (oldKey == nil)
			{
				fileDict [key!] = fileName
			}
			else
			{
				print ("duplicate file dictionary entries")
			}
			
			//	Create the duration dictionary entry
			
			var i: Int = 0
			for i = 0; i < Document.fileNames.count; i++
			{
				if fileName.compare (Document.fileNames [i]) == NSComparisonResult.OrderedSame
				{
					let ms = fileDurations [i]
					let oldKey = durationDict [key!]
					
					if (oldKey == nil)
					{
						durationDict [key!] = ms
					}
					else
					{
						print ("duplicate duration dictionary entries")
					}
					
					break
				}
			}
			
			if i >= Document.fileNames.count
			{
				print ("we just tried to create an invalid file name")
				return
			}
			
			//	Add the script text to the array
			
			let scriptText = String (str.substringFromIndex(15))
			stringArray.append(scriptText)
		}
		
//		var data: NSData = NSKeyedArchiver.archivedDataWithRootObject(fileDict)
//		var path = "/users/larryapplegate/Desktop/_fileDict.data"
//		data.writeToFile(path, atomically: true)
//		
//		data = NSKeyedArchiver.archivedDataWithRootObject(durationDict)
//		path = "/users/larryapplegate/Desktop/_durationDict.data"
//		data.writeToFile(path, atomically: true)
//		
//		data = NSKeyedArchiver.archivedDataWithRootObject(speakDict)
//		path = "/users/larryapplegate/Desktop/_speakDict.data"
//		data.writeToFile(path, atomically: true)
//		
		print (String(stringArray.count) + " unique phrases")
		print (stringArray)
	}
	
	func keysForScores (fifteens: Int, pairs: Int, runs: Int, anySuits: Int, rightJack: Int) -> [Int]
	{
		var keys: [Int] = [Int] ()
		var count = 0
		var and: Bool = false
		
		if (fifteens > 0)
		{
			let key = keyForPartialScoreType(PartialScoreType.Fifteen, firstScore: fifteens, secondScore: 0, count: 0, and: false)
			keys.append(key)
			count += fifteens
			and = true
		}
		
		if (pairs + runs) > 0
		{
			let key = keyForPartialScoreType(PartialScoreType.PairRun, firstScore: pairs, secondScore: runs, count: count, and: and)
			keys.append(key)
			count += pairs + runs
			and = true
		}
		
		if (anySuits) > 0
		{
			let key = keyForPartialScoreType(PartialScoreType.PairRun, firstScore: anySuits, secondScore: 0, count: count, and: and)
			keys.append(key)
			count += pairs + runs
			and = true
		}
		
		if (rightJack) > 0
		{
			let key = keyForPartialScoreType(PartialScoreType.PairRun, firstScore: rightJack, secondScore: 0, count: count, and: and)
			keys.append(key)
			count += pairs + runs
			and = true
		}
		
		return keys
	}
	
	func evaluateHand (cards: [Card], anySuits: Int, rightJack: Int)
	{
		let result = countHand(cards)
		let fifteens = result.count15
		let pairs = result.countPairs
		let runs = result.countRuns
		
		var count = 0
		var and: Bool = false
		
		if fifteens > 0
		{
			savePartialScoreType (PartialScoreType.Fifteen, firstScore: fifteens, secondScore: 0, count: 0, and: false)
			count += fifteens
			and = true
		}
		
		if pairs + runs > 0
		{
			savePartialScoreType (PartialScoreType.PairRun, firstScore: pairs, secondScore: runs, count: count, and: and)
			count += pairs + runs
			and = true
		}
		
		if (anySuits > 0)
		{
			savePartialScoreType (PartialScoreType.Flush, firstScore: anySuits, secondScore: 0, count: count, and: and)
			count += anySuits
			and = true
		}
		
		if (rightJack > 0)
		{
			savePartialScoreType (PartialScoreType.Nobs, firstScore: rightJack, secondScore: 0, count: count, and: and)
			count += rightJack
			and = true
		}
	}
	
	enum PartialScoreType: Int
	{
		case Fifteen
		case PairRun
		case Flush
		case Nobs
	}
	
	enum PairRunType: Int
	{
		case Pair, Run3, Pairs2, Run4, PairRun3, Run5, Pairs3, Pairs2and6,
		DoubleRun3, DoubleRun4, Pairs6, TripleRun, DoubleDoubleRun
	}
	
	enum PhraseIndex: Int
	{
		case Fifteen, Pair, Pairs2, Pairs3, Pairs6, Run3, Run4, Run5,
		DoubleRun3, DoubleRun4, TripleRun, DoubleDoubleRun, Flush4, Flush5, Nobs
	}
	
	func keyForPartialScoreType (type: PartialScoreType, firstScore: Int, secondScore: Int, count: Int, and: Bool) -> Int
	{
		let totalScore = count + firstScore + secondScore
		var key: Int = (type.rawValue << 9) + totalScore
		if and
		{
			key |= 1 << 11
		}
		
		if type == PartialScoreType.PairRun
		{
			if secondScore == 0
			{
				switch (firstScore)
				{
				case 2:
					key |= PairRunType.Pair.rawValue << 5
					
				case 4:
					key |= PairRunType.Pairs2.rawValue << 5
					
				case 6:
					key |= PairRunType.Pairs3.rawValue << 5
					
				case 8:
					key |= (PairRunType.Pairs2and6.rawValue << 5)
					
				case 12:
					key |= PairRunType.Pairs6.rawValue << 5
					
				default: print ("bad first score")
				}
			}
				
			else if firstScore == 0
			{
				switch (secondScore)
				{
				case 3:
					key |= PairRunType.Run3.rawValue << 5
					
				case 4:
					key |= PairRunType.Run4.rawValue << 5
					
				case 5:
					key |= (PairRunType.Run5.rawValue << 5)
					
				default: print ("bad second score")
				}
			}
				
			else
			{
				switch (firstScore + secondScore)
				{
				case 5:
					key |= (PairRunType.PairRun3.rawValue << 5)
					
				case 8:
					key |= (PairRunType.DoubleRun3.rawValue << 5)
					
				case 10:
					key |= (PairRunType.DoubleRun4.rawValue << 5)
					
				case 15:
					key |= (PairRunType.TripleRun.rawValue << 5)
					
				case 16:
					key |= (PairRunType.DoubleDoubleRun.rawValue << 5)
					
				default: print ("bad first & second score")
				}
			}
		}
			
		else if type == PartialScoreType.Flush
		{
			if firstScore == 4
			{
				key |= 4 << 5
			}
				
			else if firstScore == 5
			{
				key |= 5 << 5
			}
				
			else
			{
				print ("bad flush")
			}
			
		}
		
		return key
	}
	
	func savePartialScoreType (type: PartialScoreType, firstScore: Int, secondScore: Int, count: Int, and: Bool)
	{
		let totalScore = count + firstScore + secondScore
		var key: Int = (type.rawValue << 9) + totalScore
		var string = ""
		var sort = "0"
		
		if and
		{
			key |= 1 << 11
			string = "and "
			sort = "1"
		}
		
		switch (type)
		{
		case PartialScoreType.Fifteen:
			string = scorePhrases [PhraseIndex.Fifteen.rawValue] + String (totalScore)
			sort += "00"
			
		case PartialScoreType.PairRun:
			if secondScore == 0
			{
				switch (firstScore)
				{
				case 2:
					key |= PairRunType.Pair.rawValue << 5
					string += scorePhrases [PhraseIndex.Pair.rawValue] + String (totalScore)
					sort += "01"
					
				case 4:
					key |= PairRunType.Pairs2.rawValue << 5
					string += scorePhrases [PhraseIndex.Pairs2.rawValue] + String (totalScore)
					sort += "03"
					
				case 6:
					key |= PairRunType.Pairs3.rawValue << 5
					string += scorePhrases [PhraseIndex.Pairs3.rawValue] + String (totalScore)
					sort += "04"
					
				case 8:
					key |= (PairRunType.Pairs2and6.rawValue << 5)
					string += scorePhrases [PhraseIndex.Pair.rawValue] + String (count + 2) + " and "
						+ scorePhrases [PhraseIndex.Pairs3.rawValue] + String (totalScore)
					sort += "05"
					
				case 12:
					key |= PairRunType.Pairs6.rawValue << 5
					string += scorePhrases [PhraseIndex.Pairs6.rawValue] + String (totalScore)
					sort += "06"
					
				default: print ("bad first score")
				}
			}
				
			else if firstScore == 0
			{
				switch (secondScore)
				{
				case 3:
					key |= PairRunType.Run3.rawValue << 5
					string += scorePhrases [PhraseIndex.Run3.rawValue] + String (totalScore)
					sort += "07"
					
				case 4:
					key |= PairRunType.Run4.rawValue << 5
					string += scorePhrases [PhraseIndex.Run4.rawValue] + String (totalScore)
					sort += "08"
					
				case 5:
					key |= (PairRunType.Run5.rawValue << 5)
					string += scorePhrases [PhraseIndex.Run5.rawValue] + String (totalScore)
					sort += "09"
					
				default: print ("bad second score")
				}
			}
				
			else
			{
				switch (firstScore + secondScore)
				{
				case 5:
					key |= (PairRunType.PairRun3.rawValue << 5)
					string += scorePhrases [PhraseIndex.Pair.rawValue] + String (count + firstScore) + " and "
						+ scorePhrases [PhraseIndex.Run3.rawValue] + String (totalScore)
					sort += "02"
					
				case 8:
					key |= (PairRunType.DoubleRun3.rawValue << 5)
					string += scorePhrases [PhraseIndex.DoubleRun3.rawValue] + String (totalScore)
					sort += "10"
					
				case 10:
					key |= (PairRunType.DoubleRun4.rawValue << 5)
					string += scorePhrases [PhraseIndex.DoubleRun4.rawValue] + String (totalScore)
					sort += "11"
					
				case 15:
					key |= (PairRunType.TripleRun.rawValue << 5)
					string += scorePhrases [PhraseIndex.TripleRun.rawValue] + String (totalScore)
					sort += "12"
					
				case 16:
					key |= (PairRunType.DoubleDoubleRun.rawValue << 5)
					string += scorePhrases [PhraseIndex.DoubleDoubleRun.rawValue] + String (totalScore)
					sort += "13"
					
				default: print ("bad first & second score")
				}
			}
			
			
		case PartialScoreType.Flush:
			if firstScore == 4
			{
				key |= 4 << 5
				string += scorePhrases [PhraseIndex.Flush4.rawValue] + String (totalScore)
				sort += "14"
			}
				
			else if firstScore == 5
			{
				key |= 5 << 5
				string += scorePhrases [PhraseIndex.Flush5.rawValue] + String (totalScore)
				sort += "15"
			}
				
			else
			{
				print ("bad flush")
			}
			
		case PartialScoreType.Nobs:
			string += scorePhrases [PhraseIndex.Nobs.rawValue] + String (totalScore)
			sort += "16"
		}
		
		//	Finish off the sort key and the speak string
		
		if (totalScore < 10)
		{
			sort += "0"
		}
		
		sort += String (totalScore) + " "
		string += "\n"
		
		//	Save the score string in the speak dictionary
		
		var str2 = speakDict [key]
		if (str2 == nil)
		{
			speakDict [key] = string
		}
			
			//	Add the score to the score string array only once
			
		else
		{
			if (str2 != string)
			{
				print (" bad key")
			}
			return
		}
		
		//	Add the sort key and the dictionary key on the front of the phrase in order to sort them
		
		str2 = String (key)
		var str3: NSString = NSString (string: str2!)
		while (str3.length < 8)
		{
			str2 = "0" + String (str3)
			str3 = NSString (string: str2!)
		}
		
		let str = sort + str2! + " " + string
		scoreString.append (str)
	}
	
	// MARK: Generate durations
	
	func generateDurations (url: NSURL)
	{
		let fileManager = NSFileManager.defaultManager()
		let path = url.path
		let nsPath = path! as NSString
		let contents = try! fileManager.contentsOfDirectoryAtPath(path!)
		voiceName = String (nsPath.lastPathComponent)
		Announcer.playerVoice = voiceName.lowercaseString
		var durations: [Int] = [Int] (count: Document.fileNames.count, repeatedValue: -1)
		
		//	Examine every file in the folder
		
		for var i = 0; i < contents.count; i++
		{
			var fileName: String = contents [i]
			let filePath = nsPath.stringByAppendingPathComponent(fileName)
			
			if fileName.hasSuffix(".m4a")
			{
				//	Save the duration in ms of each audio file
				
				let data: NSData = NSData (contentsOfURL: NSURL (fileURLWithPath: filePath))!
				var newString = fileName as NSString
				newString = newString.stringByDeletingPathExtension
				fileName = String (newString)
				
				var i = 0
				for i = 0; i < Document.fileNames.count; i++
				{
					if fileName.compare (Document.fileNames [i]) == NSComparisonResult.OrderedSame
					{
						let audioPlayer = try! AVAudioPlayer (data: data, fileTypeHint: AVFileTypeAppleM4A)
						audioPlayer.prepareToPlay()
						let ms: Int = Int (round (audioPlayer.duration * Double (1000)))
						durations [i] = ms
						break
					}
				}
				
				if i >= Document.fileNames.count
				{
					print (fileName)
				}
			}
		}
		
		//	Make sure all sound files are present
		
		for var i = 0; i < durations.count; i++
		{
			if durations [i] < 0
			{
				print ("missing files")
				return
			}
		}

		//	Save the new durations
		
		fileDurations = durations

//		//	Load the dictionaries from the folder if they exist
//		
//		for var i = 0; i < contents.count; i++
//		{
//			let fileName: String = contents [i]
//			let filePath = path?.stringByAppendingPathComponent(fileName)
//			let data: NSData = NSData (contentsOfURL: NSURL (fileURLWithPath: filePath!))!
//			
//			switch (fileName)
//			{
//			case "FileDict.data": fileDict = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Int: String]
//				
//			case "DurationDict.data": durationDict = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Int: Int]
//				
//			case "SpeakDict.data": speakDict = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Int: String]
//				
//			default: break
//			}
//		}
	}
	
	// MARK: SpeakHandText
	
	func speakHandText (text: String)
	{
		if text == ""
		{
			return
		}
		
		let str: NSString = text
		if str.length != 5 && str.length != 6 && str.length != 10
		{
			print ("wrong length")
			return
		}
		
		var ranks: [Rank] = [Rank] (count: 5, repeatedValue: Rank.Ace)
		var suits: [Suit] = [Suit.Clubs, Suit.Diamonds, Suit.Hearts, Suit.Spades, Suit.Clubs]
		
		for var i = 0; i < 5; i++
		{
			let r = str.substringWithRange(NSMakeRange(i, 1))
			var rank: Rank = Rank.Ace
			switch (r)
			{
			case "a": rank = Rank.Ace
			case "1": rank = Rank.Ace
			case "2": rank = Rank.Two
			case "3": rank = Rank.Three
			case "4": rank = Rank.Four
			case "5": rank = Rank.Five
			case "6": rank = Rank.Six
			case "7": rank = Rank.Seven
			case "8": rank = Rank.Eight
			case "9": rank = Rank.Nine
			case "t": rank = Rank.Ten
			case "j": rank = Rank.Jack
			case "q": rank = Rank.Queen
			case "k": rank = Rank.King
			default:
				print ("no rank " + r)
				return
			}
			
			ranks [i] = rank
		}
		
		if (str.length == 6)
		{
			let s = str.substringWithRange(NSMakeRange(5, 1))
			var suit:Suit = Suit.Clubs
			switch (s)
			{
			case "c": suit = Suit.Clubs
			case "d": suit = Suit.Diamonds
			case "h": suit = Suit.Hearts
			case "s": suit = Suit.Spades
			default:
				print ("no suit " + s)
				return
			}
			for var i = 0; i < 5; i++
			{
				suits [i] = suit
			}
		}
		
		if str.length == 10
		{
			for var i = 0; i < 5; i++
			{
				let s = str.substringWithRange(NSMakeRange(i + 5, 1))
				var suit:Suit = Suit.Clubs
				switch (s)
				{
				case "c": suit = Suit.Clubs
				case "d": suit = Suit.Diamonds
				case "h": suit = Suit.Hearts
				case "s": suit = Suit.Spades
				default:
					print ("no suit " + s)
					return
				}
				
				suits [i] = suit
			}
		}
		
		var cards: [Card] = [Card] ()
		for (var i = 0; i < 5; i++)
		{
			let card = Card(rank: ranks[i], suit: suits[i])
			cards.append (card)
		}
		
		let result = countHand(cards)
		var count = 0
		
		if result.count15 > 0
		{
			count += result.count15
			let speech: String? = speakDict [count]
			if speech != nil
			{
				Announcer.speak(speech!)
			}
		}
		
		var and = false
		if (count > 0)
		{
			and = true
		}
		
		if result.countPairs > 0 || result.countRuns > 0
		{
			let key = keyForPartialScoreType (PartialScoreType.PairRun, firstScore: result.countPairs,
				secondScore: result.countRuns, count: count, and: and)
			let speech: String? = speakDict [key]
			if speech != nil
			{
				Announcer.speak(speech!)
			}
				
			else
			{
				print ("bad count pairs & runs")
			}
			
			count += result.countPairs + result.countRuns
			and = true
		}
		
		if result.countSuit > 0
		{
			let key = keyForPartialScoreType (PartialScoreType.Flush, firstScore: result.countSuit,
				secondScore: 0, count: count, and: and)
			
			let speech: String? = speakDict [key]
			if speech != nil
			{
				Announcer.speak(speech!)
			}
				
			else
			{
				print ("bad count suit")
			}
			
			count += result.countSuit
			and = true
		}
		
		if result.countJack > 0
		{
			let key = keyForPartialScoreType (PartialScoreType.Nobs, firstScore: result.countJack,
				secondScore: 0, count: count, and: and)
			
			let speech: String? = speakDict [key]
			if speech != nil
			{
				Announcer.speak(speech!)
			}
				
			else
			{
				print ("bad count jack")
			}
			and = true
		}
		
	}
	
	// MARK: Utilities
	
	private func countHand (hand: [Card]) -> (count15: Int, countPairs: Int, countRuns: Int, countSuit: Int, countJack: Int)
	{
		var values = [Int] (count: 5, repeatedValue: 0)    // the hand as 1-10
		var result15 = 0, resultPairs = 0, resultRuns = 0, resultSuit = 0, resultJack = 0;
		
		for var i = 0; i < 5; i++
		{
			values [i] = hand[i].rank >= Rank.Ten ? 10 : hand[i].rank.rawValue + 1
		}
		
		result15 = count15 (values)
		
		var mask = 0
		var mask2 = 0
		var mask3 = 0
		var bit = 0
		var value = 0
		
		for var i = 0; i < 5; i++
		{
			value = hand[i].rank.rawValue
			bit = 1 << value
			if ((mask & bit) != 0)
			{
				if ((mask3 & bit) != 0)
				{
					resultPairs += 12    // four of a kind
					mask2 = 0
					break
				}
				
				if ((mask2 & bit) != 0)
				{
					mask3 |= bit
				}
				else
				{
					mask2 |= bit
				}
			}
			else
			{
				mask |= bit
			}
		}
		
		if (mask2 != 0)
		{
			resultPairs += 2
			var mask4 = mask2
			while ((mask4 & 1) == 0)
			{
				mask4 >>= 1
			}
			if (mask4 > 1)          // at least a pair
			{
				resultPairs += 2
				if (mask3 != 0)
				{
					resultPairs += 4     // a pair and three of a kind
					// can't have a run (I'll check anyway)
				}
			}
				
			else if (mask3 != 0)
			{
				resultPairs += 4         // three of a kind
			}
		}
		
		for var j = 0; j < 13; j++
		{
			if ((mask & 1) != 0)
			{
				if (mask == 31)
				{
					resultRuns += 5
					break
				}
				
				if ((mask & 15) == 15)
				{
					if ((mask2 & 15) != 0)
					{
						resultRuns += 8
					}
					else
					{
						resultRuns += 4
					}
					break
				}
				
				if ((mask & 7) == 7)
				{
					if ((mask2 & 7) != 0)
					{
						if (mask3 != 0)
						{
							resultRuns += 9
						}
						else
						{
							while (mask2 != 0)
							{
								if ((mask2 & 1) != 0)
								{
									mask3++
								}
								mask2 >>= 1
							}
							if (mask3 > 1)
							{
								resultRuns += 12
							}
							else
							{
								resultRuns += 6
							}
						}
					}
						
					else
					{
						resultRuns += 3
					}
					break
				}
			}
			
			if (mask == 0)
			{ break }
			
			mask >>= 1
			mask2 >>= 1
			mask3 >>= 1
		}
		
		let suit = hand[0].suit;
		if hand[1].suit == suit && hand[2].suit == suit && hand[3].suit == suit
		{
			resultSuit = hand[4].suit == suit ? 5 : 4
		}
		
		for (var i = 0; i < 4; i++)
		{
			if hand[i].rank == Rank.Jack && hand[i].suit == hand[4].suit
			{
				resultJack = 1;
			}
		}
		
		return (result15, resultPairs, resultRuns, resultSuit, resultJack)
	}
	
	//  Count the combinations of 15
	
	private func count15 (values: [Int]) -> Int
	{
		var sum = 0
		var count = 0
		
		//  Check all
		
		for var i = 0; i < 5; i++
		{
			sum += values[i]
		}
		
		if (sum == 15)
		{
			return 2
		}
		
		//  Check 4 at a time, 3 at a time, and 2 at a time
		
		for var i = 0; i < 5 - 1; i++
		{
			if ((sum - values[i]) == 15)
			{
				count += 2
			}
			
			for var j = i + 1; j < 5; j++
			{
				if ((sum - values[i] - values[j]) == 15)
				{
					count += 2
				}
				
				if ((values[i] + values[j]) == 15)
				{
					count += 2
				}
			}
		}
		
		if (sum - values[4] == 15)
		{
			count += 2
		}
		
		return count
	}
	
	
	// MARK: Outlets & Actions, Overrides
	
	@IBOutlet var voiceNameText: NSTextField!
	
	
	@IBAction func generate(sender: AnyObject)
	{
		generateScores()
	}
	
	@IBAction func speakHand(sender: NSTextField)
	{
		speakHandText(sender.stringValue)
	}
	
	override func windowControllerDidLoadNib(aController: NSWindowController) {
		super.windowControllerDidLoadNib(aController)
		// Add any code here that needs to be executed once the windowController has loaded the document's window.
	}

	override class func autosavesInPlace() -> Bool {
		return true
	}

	override func makeWindowControllers() {
		// Returns the Storyboard that contains your Document window.
		let storyboard = NSStoryboard(name: "Main", bundle: nil)
		let windowController = storyboard.instantiateControllerWithIdentifier("Document Window Controller") as! NSWindowController
		self.addWindowController(windowController)
	}

//	override func dataOfType(typeName: String) throws -> NSData
//	{
//		// Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
//		// throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
//
//		let data: NSData = NSKeyedArchiver.archivedDataWithRootObject(voice)
//		return data
//	}
//	
//	override func readFromData(data: NSData, ofType typeName: String) throws
//	{
//		if let obj: AnyObject = NSKeyedUnarchiver.unarchiveObjectWithData (data)
//		{
//			voice = obj as! Voice
//		}
//	
//		else
//		{
//			throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
//		}
//	}

}

