//
//  Copyright © 2015 Rivergate Software. All rights reserved.
//

import Cocoa
import AVFoundation

struct Card
{
	var rank: Rank
	var suit: Suit
}

class Document: NSDocument, AVAudioPlayerDelegate
{
	var _voice: Voice?
	var voice: Voice {
		get {return _voice!}
		set {
			_voice = newValue
			updateChangeCount(NSDocumentChangeType.ChangeDone)
		}
	}
	
	var _viewController: ViewController? = nil
	var viewController: ViewController {
		get {return _viewController!}
		set {_viewController = newValue}
	}	

	var	language: String {
		get {return voice.language}
		set {
			voice.language = newValue
			updateChangeCount(NSDocumentChangeType.ChangeDone)
		}
	}
	
	var locale: String {
		get {return voice.locale}
		set {
			voice.locale = newValue
			updateChangeCount(NSDocumentChangeType.ChangeDone)
		}
	}
	
	var voiceName: String {
		get {return voice.voiceName}
		set {
			voice.voiceName = newValue
			updateChangeCount(NSDocumentChangeType.ChangeDone)
		}
	}
	
	var durationAdjustments: String {
		get {return voice.durationAdjustmentsText}
		set {
			voice.durationAdjustmentsText = newValue
			updateChangeCount(NSDocumentChangeType.ChangeDone)
		}
	}

	var sounds: [Sound] = []
	var audioPlayers: [AVAudioPlayer] = []
	
	var now: NSTimeInterval = 0;
	var testNumber = -1;
	let maxTest = 4;
	
	var includeAnd: Bool {
		get {return voice.includeAnd}
		set {
			voice.includeAnd = newValue
			updateChangeCount(NSDocumentChangeType.ChangeDone)
		}
	}
	
	var useContinueNumbers: Bool {
		get {return voice.useContinueNumbers}
		set {
			voice.useContinueNumbers = newValue
			updateChangeCount(NSDocumentChangeType.ChangeDone)
		}
	}
	
	var useSingleNumber: Bool {
		get {return voice.useSingleNumber}
		set {
			voice.useSingleNumber = newValue
			updateChangeCount(NSDocumentChangeType.ChangeDone)
		}
	}
	
	var cyclePhrases: Bool {
		get {return voice.cyclePhrases}
		set {
			voice.cyclePhrases = newValue
			updateChangeCount(NSDocumentChangeType.ChangeDone)
		}
	}
	
	var currentTest: Int {
		get {return voice.currentTest}
		set {
			voice.currentTest = newValue
			updateChangeCount(NSDocumentChangeType.ChangeDone)
		}
	}
	
	var numberTag: Int {
		get {return voice.currentNumber}
		set {
			voice.currentNumber = newValue - 50
			updateChangeCount(NSDocumentChangeType.ChangeDone)
		}
	}
	
	var handScores = Array<Phrase>()
	var handCounts = Array<Int> ()
	
	// MARK: Generate all possible scores
	
	var scoreNames: [String] =
	[

		"fifteen ", "a pair is ", "2 pairs is ", "3 pairs is ", "6 pairs is ",
		"a run is ", "a run of 4 is ", "a run of 5 is ", "a double run is ", "a double run of 4 is ",
		"a triple run is ", "a double double run is ", "4 of the same suit is ", "5 of the same suit is ",
		"the right jack is "
	]
	
	var countDict: [String: Int] = [String: Int] ()
	let omitSuitsAndJack = false

	func generateScores ()
	{
		countDict = [String: Int] ()
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
							
							evaluateHand (cards, anySuits: 0, rightJack: false)
							
							//	If there is a jack in the hand, make it the right jack
							
							var rightJack: Bool = false
							for (var a = 0; a < 4; a++)
							{
								if ranks[a] == Rank.Jack
								{
									rightJack = true
									evaluateHand(cards, anySuits: 0, rightJack: rightJack)
									break
								}
							}
							
							//	If there are any pairs in the hand, we are done
							
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
								for (var a = 0; a < 4; a++)
								{
									if ranks[a] == ranks[4]
									{
										anySuits = 4
										rightJack = false
										break
									}
								}
								
								//	First evaluate with and without the right jack
								
								evaluateHand (cards, anySuits: anySuits, rightJack: false)
								if (rightJack)
								{
									evaluateHand (cards, anySuits: anySuits, rightJack: true)
								}
								
								//	Then if it is a 5-card flush, do it again for 4 cards
								
								if (anySuits == 5)
								{
									evaluateHand (cards, anySuits: 4, rightJack: false)
									if (rightJack)
									{
										evaluateHand (cards, anySuits: 4, rightJack: true)
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
		
		print (String (countDict.count) + " unique counts")
		
		var array: [String] = [String] ()
		for (key, value) in countDict
		{
			var str1 = String (value)
			var str: NSString = NSString (string: str1)
			while (str.length < 8)
			{
				str1 = "0" + str1
				str = NSString (string:str1)
			}
			
			str1 += " " + key
			array.append(str1)
		}
		
		array = array.sort { $0.compare($1) == .OrderedAscending }
		print (array)
	}
	
	func evaluateHand (cards: [Card], anySuits: Int, rightJack: Bool)
	{
		let result = countHand(cards)
		let fifteens = result.count15
		var pairs = result.countPairs
		var runs = result.countRuns
		var doubleRun = 0
		var doubleRunOf4 = 0
		var tripleRun = 0
		var doubleDoubleRun = 0
		let total = fifteens + pairs + runs
		
		let sortKey = fifteens + ((pairs + runs) << 5) + (anySuits << 10) + ((rightJack ? 1 : 0) << 15) + (total << 20)
		
		if pairs > 0 && runs > 0
		{
			if pairs == 2 && runs == 6
			{
				doubleRun = 8
				pairs = 0
				runs = 0
			}
				
			else if pairs == 2 && runs == 8
			{
				doubleRunOf4 = 10
				pairs = 0
				runs = 0
			}
				
			else if pairs == 6 && runs == 9
			{
				tripleRun = 15
				pairs = 0
				runs = 0
			}
				
			else if pairs == 4 && runs == 12
			{
				doubleDoubleRun = 16
				pairs = 0
				runs = 0
			}
		}
		
		evaluateCount(fifteens, pairs: pairs, runs: runs,
			doubleRun: doubleRun, doubleRunOf4: doubleRunOf4, tripleRun: tripleRun,
			doubleDoubleRun: doubleDoubleRun, anySuits: anySuits, rightJack: rightJack, sortKey: sortKey)
	}
	
	func evaluateCount (fifteens: Int, pairs: Int, runs: Int, doubleRun: Int, doubleRunOf4: Int,
		tripleRun: Int, doubleDoubleRun: Int, anySuits: Int, rightJack: Bool, sortKey: Int)
	{
		var str: String = ""
		var count: Int = 0
		
		if fifteens > 0
		{
			count += fifteens
			str = scoreNames [0] + String (count) + " "
		}
		
		if pairs == 2
		{
			count += pairs
			if (count > pairs)
			{
				str += "and "
			}
			str += scoreNames [1] + String (count) + " "
		}
		
		else if pairs == 4
		{
			count += pairs
			if (count > pairs)
			{
				str += "and "
			}
			str += scoreNames [2] + String (count) + " "
		}
		
		else if pairs == 6
		{
			count += pairs
			if (count > pairs)
			{
				str += "and "
			}
			str += scoreNames [3] + String (count) + " "
		}
			
		else if pairs == 8
		{
			count += pairs
			if (count > pairs)
			{
				str += "and "
			}
			str += scoreNames [1] + String (count - 6) + " "
			str += "and "
			str += scoreNames [3] + String (count) + " "
		}
		
		else if pairs == 12
		{
			count += pairs
			if (count > pairs)
			{
				str += "and "
			}
			str += scoreNames [4] + String (count) + " "
		}
		
		if runs == 3
		{
			count += runs
			if (count > runs)
			{
				str += "and "
			}
			str += scoreNames [5] + String (count) + " "
		}
		
		else if runs == 4
		{
			count += runs
			if (count > runs)
			{
				str += "and "
			}
			str += scoreNames [6] + String (count) + " "
		}
			
		else if runs == 5
		{
			count += runs
			if (count > runs)
			{
				str += "and "
			}
			str += scoreNames [7] + String (count) + " "
		}
		
		if doubleRun == 8
		{
			count += doubleRun
			if (count > doubleRun)
			{
				str += "and "
			}
			str += scoreNames [8] + String (count) + " "
		}
		
		if doubleRunOf4 == 10
		{
			count += doubleRunOf4
			if (count > doubleRunOf4)
			{
				str += "and "
			}
			str += scoreNames [9] + String (count) + " "
		}
			
		else if tripleRun == 15
		{
			count += tripleRun
			if (count > tripleRun)
			{
				str += "and "
			}
			str += scoreNames [10] + String (count) + " "
		}
			
		else if doubleDoubleRun	== 16
		{
			count += doubleDoubleRun
			if (count > doubleDoubleRun)
			{
				str += "and "
			}
			str += scoreNames [11] + String (count) + " "
		}
		
		if (!omitSuitsAndJack)
		{
			if anySuits == 4
			{
				count += 4
				if (count > 4)
				{
					str += "and "
				}
				str += scoreNames [12] + String (count) + " "
			}
			
			if anySuits == 5
			{
				count += 5
				if (count > 5)
				{
					str += "and "
				}
				str += scoreNames [13] + String (count) + " "
			}
			
			if rightJack
			{
				count++
				if (count > 1)
				{
					str += "and "
				}
				str += scoreNames [14] + String (count) + " "
			}

		}
		
		if count == 0
		{
			return
		}
		
		if count == 19
		{
			print ("oops")
		}
	
		str += "\n"
		
		countDict [str] = sortKey
		
	}
	
	// MARK: Accessors
	
	func isBusy() ->Bool
	{
		return audioPlayers.count > 0
	}
	
	func stopTest ()
	{
		audioPlayers.removeAll()
	}
	
	func startTest ()
	{
		switch (currentTest)
		{
		case 1: testNumbers ("", count: 31)
		case 2: testNumbers ("C_", count: 31)
			
		case 3: testPhrases (Phrase.DealingYou, count: 5)
		case 4: testPhrases (Phrase.Go, count: 6)
		case 5: testPhrases (Phrase.ForYouHand, count: 8)
		case 6: testPhrases (Phrase.YouWon, count: 6)
		case 7: testPhrases (Phrase.PointsGo, count: 7)
		case 8: testPhrases (Phrase.ScoreFifteen, count: 15)
		case 9: testPhrases (Phrase.AndScorePair, count: 14)
		case 10: testPhrases(Phrase.DealingYou, count: 61)
			
		case 11: testPlays (Phrase.PointsGo, startNumber: 3, endNumber: 5, incr: 2)
		case 12: testPlays (Phrase.PointsLast, startNumber: 3, endNumber: 13, incr: 1)
		case 13: testPlays (Phrase.PointsPair, startNumber: 2, endNumber: 4, incr: 2)
		case 14: testPlays (Phrase.PointsPairs3, startNumber: 6, endNumber: 8, incr: 2)
		case 15: testPlays (Phrase.PointsPairs6, startNumber: 12, endNumber: 14, incr: 2)
		case 16: testPlays (Phrase.PointsRun, startNumber: 3, endNumber: 9, incr: 1)
		case 17: testPlays (Phrase.Points31, startNumber: 4, endNumber: 14, incr: 1)
			
		case 21: generateScores()
		case 22: testOtherScores(Phrase.ScorePair)
		case 23: testOtherScores(Phrase.ScorePairs2)
		case 24: testOtherScores(Phrase.ScorePairs3)
		case 25: testOtherScores(Phrase.ScorePairs6)
		case 26: testOtherScores(Phrase.ScoreRun3)
		case 27: testOtherScores(Phrase.ScoreRun4)
		case 28: testOtherScores(Phrase.ScoreRun5)
		case 29: testOtherScores(Phrase.ScoreDoubleRun3)
		case 30: testOtherScores(Phrase.ScoreDoubleRun4)
		case 31: testOtherScores(Phrase.ScoreTripleRun)
		case 32: testOtherScores(Phrase.ScoreDoubleDoubleRun)
		case 33: testOtherScores(Phrase.ScoreFlush4)
		case 34: testOtherScores(Phrase.ScoreFlush5)
		case 35: testOtherScores(Phrase.ScoreNobs)
			
		case 40: testCountHands()
			
		default:
			break
		}
	}
	
	func testPhrases (firstPhrase: Phrase, count: Int)
	{
		sounds.removeAll()
		
		for (var i: Int = 1; i <= count; i++)
		{
			let phrase = Phrase (rawValue: firstPhrase.rawValue + i - 1)
			let data = voice.dataforPhrase(phrase!)
			
			let sound = Sound.init (phrase: phrase!, voice: voice, fileData: data, adjust: 333)
			sounds.append(sound)
		}
		
		playSounds()
	}
	
	func testNumbers (prefix: String, count: Int)
	{
		sounds.removeAll()
		for (var i: Int = 1; i <= count; i++)
		{
			let data = voice.dataForNumber(i, isLast: prefix == "")
			
			let isLast = i == count - 1
			let sound = Sound.init (number: i, voice: voice, fileData: data, isLast: isLast)
			sound.delay = 333
			sounds.append(sound)
		}
		
		playSounds()
	}
	
	func testPlays (phrase: Phrase, startNumber: Int, endNumber: Int, incr: Int)
	{
		sounds.removeAll()
		for var number = startNumber; number <= endNumber; number += incr
		{
			if (useSingleNumber)
			{
				number = numberTag
			}
			AddScore(phrase, score: number, isLast: true)
			if (useSingleNumber)
			{
				break
			}
		}
		
		playSounds ()
	}
	
	func AddScore (phrase: Phrase, score: Int, isLast: Bool)
	{
		//	Adjust the duration to the following number if needed:
		
		let durationIndex = phrase.rawValue - Phrase.PointsGo.rawValue
		let phraseKey: String = Voice.durationAdjustKeys [durationIndex]
		let phraseScoreKey = phraseKey + String (score)
		let allKey = "all"
		let allScoreKey = allKey + String (score)

		//	First try the actual phrase and the score
		
		var adjust: Int? = voice.durationAdjustments [phraseScoreKey]
		if (adjust == nil)
		{
			//	Then try the phrase for any score
			
			adjust = voice.durationAdjustments [phraseKey]
			if (adjust == nil)
			{
				//	Then try "all" and the score
				
				adjust = voice.durationAdjustments [allScoreKey]
				if (adjust == nil)
				{
					//	Then try "all" for any score
					
					adjust = voice.durationAdjustments [allKey]
					if (adjust == nil)
					{
						//	Nothing matched, use 0
						
						adjust = 0
					}
				}
			}
		}
		
		//	Add the phrase sound to the list
		
		var data = voice.dataforPhrase(phrase)
		var sound = Sound.init (phrase: phrase, voice: voice, fileData: data, adjust: adjust!)
		sounds.append(sound)
		
		//	Add the score to the list
		
		data = voice.dataForNumber (score, isLast: isLast)
		sound = Sound.init (number: score, voice: voice, fileData: data, isLast: isLast)
		sounds.append(sound)
	}
	
	func playSounds ()
	{
		for (var i = 0; i < sounds.count; i++)
		{
			let sound = sounds [Int(i)]
			let audioPlayer = try! AVAudioPlayer (data: sound.data, fileTypeHint: AVFileTypeAppleM4A)
			audioPlayer.delegate = self;
			audioPlayer.prepareToPlay()
			if (i == 0)
			{
				now = audioPlayer.deviceCurrentTime + 0.5
			}
			
			audioPlayer.playAtTime(now)
			now += Double (sound.duration + sound.delay) / Double (1000)
			
			audioPlayers.append(audioPlayer)
		}
	}
	
	func testFifteens()
	{
		sounds.removeAll()
		
		for (var score: Int = 2; score < 18; score += 2)
		{
			if (useSingleNumber && numberTag > 0 && numberTag <= 31)
			{
				score = numberTag
			}
			
			AddScore (Phrase.ScoreFifteen, score: score, isLast: true)
			if (useSingleNumber)
			{
				break
			}
		}
		
		playSounds ()
	}
	
	func testOtherScores(phrase: Phrase)
	{
		var rawPhraseNumber = phrase.rawValue
		var lastPhraseNumber = cyclePhrases ? Phrase.ScoreNobs.rawValue : rawPhraseNumber
		if (includeAnd)
		{
			rawPhraseNumber += 14
			lastPhraseNumber += 14
		}
		
		var myPhrase = Phrase (rawValue: rawPhraseNumber)!
		
		sounds.removeAll()
		now = 0
		for (var i = rawPhraseNumber; i <= lastPhraseNumber; i++)
		{
			for (var score: Int = 2; score <= 29; score++)
			{
				//	Skip impossible scores
				
				if (score == 19 || (score >= 25 && score <= 27))
				{
					continue
				}
				
				if (useSingleNumber && numberTag > 0 && numberTag <= 31)
				{
					score = numberTag
				}
				
				AddScore(myPhrase, score: score, isLast: !useContinueNumbers)
				
				if (useSingleNumber)
				{
					break
				}
			}
			
			if (cyclePhrases)
			{
				let phrase2 = Phrase (rawValue: myPhrase.rawValue + 1)
				myPhrase = phrase2!
			}
		}
		
		playSounds ()
	}
	
	func testCountHands()
	{
		now = 0
		
		if (++testNumber >= maxTest)
		{
			testNumber = 0;
		}
		
		var ranks: [Rank] = [Rank.Ace, Rank.Two, Rank.Three, Rank.Four, Rank.Five]
		var suits: [Suit]  = [Suit.Clubs, Suit.Clubs, Suit.Clubs, Suit.Diamonds, Suit.Clubs]
		
		switch (testNumber)
		{
		case 0:
			ranks = [Rank.Three, Rank.Four, Rank.Nine, Rank.Ten, Rank.King]
			suits = [Suit.Clubs, Suit.Clubs, Suit.Clubs, Suit.Hearts, Suit.Clubs]
			
		case 1:
			ranks = [Rank.Nine, Rank.Two, Rank.Two, Rank.Two, Rank.Two]
			suits = [Suit.Clubs, Suit.Clubs, Suit.Clubs, Suit.Diamonds, Suit.Clubs]
			
		case 2:
			ranks = [Rank.Four, Rank.Five, Rank.Six, Rank.Seven, Rank.Seven]
			suits = [Suit.Clubs, Suit.Clubs, Suit.Clubs, Suit.Clubs, Suit.Diamonds
			]
			
		case 3:
			ranks = [Rank.Five, Rank.Five, Rank.Five, Rank.Jack, Rank.Five]
			suits = [Suit.Clubs, Suit.Diamonds, Suit.Hearts, Suit.Spades, Suit.Spades]
			
		default:
			break
		}
		
		var cards = Array<Card> ()
		
		for (var i = 0; i < 5; i++)
		{
			let card = Card(rank: ranks[i], suit: suits[i])
			cards.append (card)
		}
		
		handScores.removeAll()
		handCounts.removeAll()
		var count = 0
		
		let result = countHand(cards)
		if (result.count15 > 0)
		{
			handScores.append(Phrase.ScoreFifteen)
			count += result.count15
			handCounts.append(count)
		}
		
		if result.countPairs == 6 && result.countRuns == 0
		{
			handScores.append(Phrase.ScorePairs3)
			count += result.countPairs
			handCounts.append(count)
		}
		
		if result.countPairs == 2 && result.countRuns == 6
		{
			handScores.append(Phrase.ScoreDoubleRun3)
			count += 8
			handCounts.append(count)
		}
			
		else if result.countPairs == 2 && result.countRuns == 8
		{
			handScores.append(Phrase.ScoreDoubleRun4)
			count += 10
			handCounts.append(count)
		}
			
		else if result.countPairs == 6 && result.countRuns == 9
		{
			handScores.append(Phrase.ScoreTripleRun)
			count += 15
			handCounts.append(count)
		}
			
		else if result.countPairs == 4 && result.countRuns == 12
		{
			handScores.append(Phrase.ScoreDoubleDoubleRun)
			count += 16
			handCounts.append(count)
		}
			
		else
		{
			if result.countPairs == 2
			{
				handScores.append(Phrase.ScorePair)
				count += result.countPairs
				handCounts.append(count)
			}
				
			else if result.countPairs == 12
			{
				handScores.append(Phrase.ScorePairs6)
				count += 12
				handCounts.append(count)
			}
				
			else if result.countRuns == 3
			{
				handScores.append(Phrase.ScoreRun3)
				count += 3
				handCounts.append(count)
			}
				
			else if result.countRuns == 4
			{
				handScores.append(Phrase.ScoreRun4)
				count += 4
				handCounts.append(count)
			}
				
			else if result.countRuns == 5
			{
				handScores.append(Phrase.ScoreRun5)
				count += 5
				handCounts.append(count)
			}
		}
		
		if result.countSuit == 4
		{
			handScores.append(Phrase.ScoreFlush4)
			count += 4
			handCounts.append(count)
		}
		
		if result.countSuit == 5
		{
			handScores.append(Phrase.ScoreFlush5)
			count += 5
			handCounts.append(count)
		}
		
		if result.countJack > 0
		{
			handScores.append(Phrase.ScoreNobs)
			count++
			handCounts.append(count)
		}
		
		//	Count the hand: create the list of sounds to be played, with durations plus delays between phrase and number
		
		sounds.removeAll()
		for (var i: Int = 0; i < handCounts.count; i++)
		{
			//	Only the first phrase is without the "and"
			
			var phrase = handScores [i]
			if (i > 0)
			{
				phrase = Phrase (rawValue: phrase.rawValue + 14)!
			}
			
			//	The last phrase is "final", the earlier ones are "continued"
			
			let isLast = i == handCounts.count - 1
			
			//	Add the score
			
			AddScore (phrase, score: handCounts [i], isLast: isLast)
		}
		
		playSounds ()
		
		if (handScores.count == 0)
		{
			let data = voice.dataforPhrase(Phrase.ScoreNone)
			let sound = Sound.init (phrase: Phrase.ScoreNone, voice: voice, fileData: data, adjust: 0)
			let audioPlayer = try! AVAudioPlayer (data: sound.data, fileTypeHint: AVFileTypeAppleM4A)
			
			now = audioPlayer.deviceCurrentTime + 0.5
			audioPlayer.delegate = self;
			audioPlayer.prepareToPlay()
			audioPlayer.playAtTime(now)
			now += Double (sound.duration) / Double (1000)
			
			audioPlayers.append(audioPlayer)
		}
	}
	
	func audioPlayerDidFinishPlaying (player: AVAudioPlayer, successfully flag: Bool)
	{
		if (audioPlayers.count > 0)
		{
			audioPlayers.removeAtIndex(0)
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
			if (mask4 > 1)          // at least two pairs
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
					if (((mask2 >> j) & 7) != 0)
					{
						if (mask3 != 0)
						{
							resultRuns += 9
						}
						else
						{
							mask2 = (mask2 >> j) & 7
							while ((mask2 & 1) == 0)
							{
								mask2 >>= 1
							}
							if (mask2 > 1)
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
	
	// MARK: Override functions

	override init() {
	    super.init()
		voice = Voice.init ()
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

	override func dataOfType(typeName: String) throws -> NSData
	{
		// Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
		// throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
		

		let data: NSData = NSKeyedArchiver.archivedDataWithRootObject(voice)
		return data
	}
	
	override func readFromData(data: NSData, ofType typeName: String) throws
	{
		if let obj: AnyObject = NSKeyedUnarchiver.unarchiveObjectWithData (data)
		{
			voice = obj as! Voice
		}
	
		else
		{
			throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
		}
	}

}

