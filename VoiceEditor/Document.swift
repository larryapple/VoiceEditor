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
	// MARK: File names
	
	static let fileNames: [String] =
	[
		"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16",
		"17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31",
		
		"Game_1", "Game_2", "Game_3", "Game_4", "Game_5", "Game_6", "Game_7",
		"Game_8", "Game_9", "Game_10", "Game_11", "Game_12", "Game_13", "Game_14",
		
		"Play_1", "Play_2", "Play_3", "Play_4", "Play_5", "Play_6", "Play_7", "Play_8", "Play_9", "Play_10",
		"Play_11", "Play_12", "Play_13", "Play_14", "Play_15", "Play_16", "Play_17", "Play_18", "Play_19", "Play_20",
		"Play_21", "Play_22", "Play_23", "Play_24", "Play_25", "Play_26", "Play_27", "Play_28", "Play_29", "Play_30",
		"Play_31", "Play_32", "Play_33", "Play_34", "Play_35", "Play_36", "Play_37", "Play_38", "Play_39", "Play_40",
		"Play_41", "Play_42", "Play_43",
		
		"First_1", "First_2", "First_3", "First_4", "First_5", "First_6", "First_7", "First_8", "First_9", "First_10",
		"First_11", "First_12", "First_13", "First_14", "First_15", "First_16", "First_17", "First_18", "First_19", "First_20",
		"First_21", "First_22", "First_23", "First_24", "First_25", "First_26", "First_27", "First_28", "First_29", "First_30",
		"First_31", "First_32", "First_33", "First_34", "First_35", "First_36", "First_37", "First_38", "First_39", "First_40",
		"First_41", "First_42", "First_43", "First_44", "First_45", "First_46",
		
		"Fif10_1", "Fif10_2", "Fif10_3", "Fif10_4", "Fif10_5", "Fif10_6", "Fif10_7", "Fif10_8", "Fif10_9", "Fif10_10",
		"Fif10_11", "Fif10_12", "Fif10_13", "Fif10_14", "Fif10_15", "Fif10_16", "Fif10_17", "Fif10_18", "Fif10_19", "Fif10_20",
		"Fif10_21",
		
		"Fif2_1", "Fif2_2", "Fif2_3", "Fif2_4", "Fif2_5", "Fif2_6", "Fif2_7", "Fif2_8", "Fif2_9", "Fif2_10",
		"Fif2_11", "Fif2_12", "Fif2_13", "Fif2_14", "Fif2_15", "Fif2_16", "Fif2_17", "Fif2_18", "Fif2_19", "Fif2_20",
		"Fif2_21", "Fif2_22", "Fif2_23", "Fif2_24", "Fif2_25", "Fif2_26", "Fif2_27", "Fif2_28", "Fif2_29", "Fif2_30",
		"Fif2_31", "Fif2_32", "Fif2_33", "Fif2_34", "Fif2_35", "Fif2_36", "Fif2_37", "Fif2_38", "Fif2_39", "Fif2_40",
		"Fif2_41", "Fif2_42", "Fif2_43",
		
		"Fif4_1", "Fif4_2", "Fif4_3", "Fif4_4", "Fif4_5", "Fif4_6", "Fif4_7", "Fif4_8", "Fif4_9", "Fif4_10",
		"Fif4_11", "Fif4_12", "Fif4_13", "Fif4_14", "Fif4_15", "Fif4_16", "Fif4_17", "Fif4_18", "Fif4_19", "Fif4_20",
		"Fif4_21", "Fif4_22", "Fif4_23", "Fif4_24", "Fif4_25", "Fif4_26", "Fif4_27", "Fif4_28", "Fif4_29", "Fif4_30",
		"Fif4_31", "Fif4_32", "Fif4_33", "Fif4_34", "Fif4_35", "Fif4_36", "Fif4_37",
		
		"Fif6_1", "Fif6_2", "Fif6_3", "Fif6_4", "Fif6_5", "Fif6_6", "Fif6_7", "Fif6_8", "Fif6_9", "Fif6_10",
		"Fif6_11", "Fif6_12", "Fif6_13", "Fif6_14", "Fif6_15", "Fif6_16", "Fif6_17", "Fif6_18", "Fif6_19", "Fif6_20",
		"Fif6_21", "Fif6_22", "Fif6_23", "Fif6_24", "Fif6_25", "Fif6_26", "Fif6_27", "Fif6_28", "Fif6_29", "Fif6_30",
		"Fif6_31", "Fif6_32", "Fif6_33", "Fif6_34",

		"Fif8_1", "Fif8_2", "Fif8_3", "Fif8_4", "Fif8_5", "Fif8_6", "Fif8_7", "Fif8_8", "Fif8_9", "Fif8_10",
		"Fif8_11", "Fif8_12", "Fif8_13", "Fif8_14", "Fif8_15", "Fif8_16", "Fif8_17", "Fif8_18", "Fif8_19", "Fif8_20",
		"Fif8_21", "Fif8_22", "Fif8_23", "Fif8_24", "Fif8_25", "Fif8_26", "Fif8_27", "Fif8_28", "Fif8_29", "Fif8_30",
		]
	
	// MARK: Score names
	
	let scorePhrasesEnglish: [String] =
	[
		"fifteen ", "a pair is ", "2 pairs is ", "3 pairs is ", "6 pairs is ",
		"a run is ", "a run of 4 is ", "a run of 5 is ", "a double run is ", "a double run of 4 is ",
		"a triple run is ", "a double double run is ", "a flush is ", "a 5 flush is ",
		"his nobs is "
	]
	
	let scorePhrasesFrench: [String] =
	[
		"quinze ", "paire pour ", "2 paires pour ", "3 paires pour ", "6 paires pour ",
		"suite pour ", "suite de 4 pour ", "suite de 5 pour ", "double suite pour ", "double suite de 4 pour ",
		"triple suite pour ", "double double suite pour ", "couleur pour ", "couleur de 5 pour ",
		"le bon valet pour "
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
	
	let scorePhrasesCzech: [String] =
	[
		"15 ", "pár za tolik ", "2 páry za tolik ", "3 páry za tolik ", "6 párů za tolik ",
		"postupka za tolik ", "postupka ze 4 za tolik ", "postupka z 5 za tolik ", "dvojitá postupka za tolik ", "dvojitá postupka ze 4 za tolik ",
		"trojitá postupka za tolik ", "dvojitě dvojitá postupka za tolik ", "4 karty stejné barvy za tolik ", "5 karet stejné barvy za tolik ",
		"tolik za milostpána"
	]
	
	var scorePhrases: [String] = [String] ()
	var insertAnd: String = ""
	var nobsFirst: Bool = false
	
	override init ()
	{
		voice = Voice ()
		scorePhrases = scorePhrasesFrench
		insertAnd = "et "
		nobsFirst = false
		super.init()
	}
	
	var voice: Voice

	var	language: String {
		get {return voice.language}
		set {voice.language = newValue;}
	}
	var locale: String {
		get {return voice.locale}
		set {voice.locale = newValue}
	}
	var voiceName: String {
		get {return voice.voiceName}
		set {voice.voiceName = newValue}
	}
	
	var audioFiles: [NSData] {
		get {return voice.audioFiles}
		set {voice.audioFiles = newValue}
	}
	
	var fileDurations: [Int] {
		get {return voice.fileDurations}
		set {voice.fileDurations = newValue}
	}
	
	var fileNameDict: [Int: String] {
		get {return voice.fileNameDict}
		set {voice.fileNameDict = newValue}
	}
	
	var durationDict: [String: Int] {
		get {return voice.durationDict}
		set {voice.durationDict = newValue}
	}
	
	var speakDict: [Int: String] {
		get {return voice.speakDict}
		set {voice.speakDict = newValue}
	}
	
	// MARK: Generate all possible scores
	
	var countDict: [String: CountScore] = [String: CountScore] ()
	
	func generateScores ()
	{
		countDict.removeAll()
		speakDict.removeAll()
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
			array.append(key)
		}
		
		array = array.sort { $0.compare($1) == .OrderedAscending }
		for var i = 0; i < array.count; i++ {
			var str = array [i] as NSString
			str = str.substringToIndex (str.length - 2)
			print (str)
		}
		
		// Create the file name dictionary
		
		var j: Int
		for j = 0; j < Document.fileNames.count; j++ {
			if Document.fileNames [j].compare ("First_1") == NSComparisonResult.OrderedSame {
				break
			}
		}
		
		if (j >= Document.fileNames.count) {
			print ("File names missing")
			return
		}
		
		fileNameDict.removeAll()
		for var i = 0; i < array.count; i++ {
			let phrase = array [i]
			if let countScore: CountScore = countDict [phrase] {
				if let oldName = fileNameDict [countScore.rawValue] {
					print (oldName + " is duplicated")
				}
				
				else {
					fileNameDict [countScore.rawValue] = Document.fileNames [j]
				}
				if let oldSpeak = speakDict [countScore.rawValue] {
					print (oldSpeak + " is duplicated")
				}
				else {
					speakDict [countScore.rawValue] = Document.fileNames [j]
				}
				j++
			}
			else {
				print ("CountScore invalid")
			}
		}
		
	}
	
	func evaluateHand (cards: [Card], anySuits: Int, rightJack: Int)
	{
		let result = countHand(cards)
		let fifteens = result.count15
		var pairs = result.countPairs
		var runs = result.countRuns
		var doubleRun = 0
		var doubleRunOf4 = 0
		var tripleRun = 0
		var doubleDoubleRun = 0
		
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
		
		let score = evaluateCount(fifteens, pairs: pairs, runs: runs,
			doubleRun: doubleRun, doubleRunOf4: doubleRunOf4, tripleRun: tripleRun,
			doubleDoubleRun: doubleDoubleRun, anySuits: anySuits, rightJack: rightJack)
		
		if score.key.rawValue == 0 {
			return
		}
		
		let oldKey: CountScore? = countDict [score.speak]
		if (oldKey != nil)
		{
			if (oldKey! == score.key) {
			}
			else {
				print ("EEk")
			}
		}
			
		else {
			countDict [score.speak] = score.key
		}

	}
	
	enum PairsRuns: Int {
		case None = 0, Pairs1, Pairs2, Pairs3, Pairs4, Pairs6, Pairs1Run3, Run3, Run3Double, Run3DoubleDouble, Run3Triple, Run4, Run4Double, Run5
	}
	
	func evaluateCount (fifteens: Int, pairs: Int, runs: Int, doubleRun: Int, doubleRunOf4: Int,
		tripleRun: Int, doubleDoubleRun: Int, anySuits: Int, rightJack: Int) -> (key: CountScore, speak: String)
	{
		var str: String = ""
		var count: Int = 0
		var key = 0
		
		if fifteens > 0
		{
			count += fifteens
			str = scorePhrases [0] + String (count) + " "
			key = ((fifteens / 2) << 8)
		}
		
		if pairs == 2
		{
			count += pairs
			if (count > pairs)
			{ str += insertAnd }
			str += scorePhrases [1] + String (count) + " "
			
			if runs == 0
			{
				key += PairsRuns.Pairs1.rawValue
			}
			else if runs == 3
			{
				count += runs
				str += insertAnd + scorePhrases [5] + String (count) + " "
				key += PairsRuns.Pairs1Run3.rawValue
			}
				
			else
			{
				print ("A run of " + String (runs) + " is not possible here")
			}
		}
			
		else if pairs == 4
		{
			count += pairs
			if (count > pairs)
			{
				str += insertAnd
			}
			str += scorePhrases [2] + String (count) + " "
			key += PairsRuns.Pairs2.rawValue
		}
			
		else if pairs == 6
		{
			count += pairs
			if (count > pairs)
			{
				str += insertAnd
			}
			str += scorePhrases [3] + String (count) + " "
			key += PairsRuns.Pairs3.rawValue
		}
			
		else if pairs == 8
		{
			count += pairs
			if (count > pairs)
			{
				str += insertAnd
			}
			str += scorePhrases [1] + String (count - 6) + " "
			str += insertAnd
			str += scorePhrases [3] + String (count) + " "
			key += PairsRuns.Pairs4.rawValue
		}
			
		else if pairs == 12
		{
			count += pairs
			if (count > pairs)
			{
				str += insertAnd
			}
			str += scorePhrases [4] + String (count) + " "
			key += PairsRuns.Pairs6.rawValue
		}
			
		else if (pairs == 0)
		{
			if runs == 3
			{
				count += runs
				if (count > runs)
				{
					str += insertAnd
				}
				str += scorePhrases [5] + String (count) + " "
				key += PairsRuns.Run3.rawValue
			}
				
			else if runs == 4
			{
				count += runs
				if (count > runs)
				{
					str += insertAnd
				}
				str += scorePhrases [6] + String (count) + " "
				key += PairsRuns.Run4.rawValue
			}
				
			else if runs == 5
			{
				count += runs
				if (count > runs)
				{
					str += insertAnd
				}
				str += scorePhrases [7] + String (count) + " "
				key += PairsRuns.Run5.rawValue
			}
		}
		
		if doubleRun == 8
		{
			count += doubleRun
			if (count > doubleRun)
			{
				str += insertAnd
			}
			str += scorePhrases [8] + String (count) + " "
			key += PairsRuns.Run3Double.rawValue
		}
			
		else if doubleRunOf4 == 10
		{
			count += doubleRunOf4
			if (count > doubleRunOf4)
			{
				str += insertAnd
			}
			str += scorePhrases [9] + String (count) + " "
			key += PairsRuns.Run4Double.rawValue
		}
			
		else if tripleRun == 15
		{
			count += tripleRun
			if (count > tripleRun)
			{
				str += insertAnd
			}
			str += scorePhrases [10] + String (count) + " "
			key += PairsRuns.Run3Triple.rawValue
		}
			
		else if doubleDoubleRun	== 16
		{
			count += doubleDoubleRun
			if (count > doubleDoubleRun)
			{
				str += insertAnd
			}
			str += scorePhrases [11] + String (count) + " "
			key += PairsRuns.Run3DoubleDouble.rawValue
		}
		
		if anySuits == 4
		{
			count += 4
			if (count > 4)
			{
				str += insertAnd
			}
			str += scorePhrases [12] + String (count) + " "
			key += (2 << 4)
		}
		
		if anySuits == 5
		{
			count += 5
			if (count > 5)
			{
				str += insertAnd
			}
			str += scorePhrases [13] + String (count) + " "
			key += (3 << 4)
		}
		if rightJack == 1
		{
			count++
			if (count > 1)
			{
				str += insertAnd
			}
			str += scorePhrases [14] + String (count) + " "
			key += (1 << 12)
		}
		
		str += "\n"
		
		let countScore: CountScore = CountScore (rawValue: key)
		return (countScore, str)
	
	}
	
	
	// MARK: Generate durations dictionary
	
	func generateDurations (url: NSURL)
	{
		let fileManager = NSFileManager.defaultManager()
		let path = url.path
		let nsPath = path! as NSString
		let contents = try! fileManager.contentsOfDirectoryAtPath(path!)
		voiceName = String (nsPath.lastPathComponent)
		Announcer.playerVoice = voiceName.lowercaseString
		var audioData: [NSData] = [NSData] (count: Document.fileNames.count, repeatedValue: NSData ())
		var durations: [Int] = [Int] (count: Document.fileNames.count, repeatedValue: -1)
		durationDict = [String: Int] ()
		
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
					
						audioData [i] = data
						durations [i] = ms
					
						let oldKey = durationDict [fileName]
						if (oldKey == nil)
						{
							durationDict [fileName] = ms
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

		//	Save the data and durations
		
		audioFiles = audioData
		fileDurations = durations
	}
	
	// MARK: ExportAudioFolder
	
	func exportAudioFolder (url: NSURL)
	{
		let fileManager = NSFileManager.defaultManager()
		do {
			try fileManager.createDirectoryAtURL (url, withIntermediateDirectories: false, attributes: nil)
		}
		catch
		{
			try! fileManager.removeItemAtPath(url.path!)
			try! fileManager.createDirectoryAtURL (url, withIntermediateDirectories: false, attributes: nil)
		}
		
		for var i = 0; i < audioFiles.count; i++
		{
			let data = audioFiles [i]
			let fileName = Document.fileNames [i]
			let string = url.path! + "/" + fileName + ".m4a"
			
			fileManager.createFileAtPath(string, contents: data, attributes: nil)
		}
		
		var data: NSData = NSKeyedArchiver.archivedDataWithRootObject(fileNameDict)
		var path = url.path! + "/" + "_fileDict.data"
		data.writeToFile(path, atomically: true)
		
		data = NSKeyedArchiver.archivedDataWithRootObject(durationDict)
		path = url.path! + "/" + "_durationDict.data"
		data.writeToFile(path, atomically: true)
		
		data = NSKeyedArchiver.archivedDataWithRootObject(speakDict)
		path = url.path! + "/" + "_speakDict.data"
		data.writeToFile(path, atomically: true)
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
		
		var suitsOk = 5
		for var i = 0; i < 4; i++
		{
			if ranks [4] == ranks [i] && suitsOk == 5
			{
				suitsOk = 4
			}
			for var j = i+1; j < 4; j++
			{
				if ranks [j] == ranks[i]
				{
					suitsOk = 0
				}
			}
		}
		
		let rawValue = (suits [0].rawValue + 1) & 3
		if (suitsOk == 4)
		{
			suits [4] = Suit (rawValue: rawValue)!
		}
		
		else if (suitsOk == 0)
		{
			suits [1] = Suit (rawValue: rawValue)!
		}
		
		var cards: [Card] = [Card] ()
		for var i = 0; i < 5; i++
		{
			let card = Card(rank: ranks[i], suit: suits[i])
			cards.append (card)
		}
		
		let result = countHand(cards)
		let fifteens = result.count15
		var pairs = result.countPairs
		var runs = result.countRuns
		var anySuits = 4
		var rightJack = 0
		for var i = 0; i < 4; i++ {
			if ranks [i] == Rank.Jack && suits [i].rawValue == suits [4].rawValue {
				rightJack = 1
			}
			if i > 0 && suits [i].rawValue != suits [i-1].rawValue {
				anySuits = 0
			}
		}
		
		if anySuits == 4 && suits [4].rawValue == suits [0].rawValue {
			anySuits = 5
		}
		
		var doubleRun = 0
		var doubleRunOf4 = 0
		var tripleRun = 0
		var doubleDoubleRun = 0
		
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
		
		let score = evaluateCount(fifteens, pairs: pairs, runs: runs,
			doubleRun: doubleRun, doubleRunOf4: doubleRunOf4, tripleRun: tripleRun,
			doubleDoubleRun: doubleDoubleRun, anySuits: anySuits, rightJack: rightJack)
		
		if score.key.rawValue > 0 {
			Announcer.speak(voiceName, speech: score.speak)
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

