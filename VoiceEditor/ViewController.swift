//
//  Copyright © 2015 Rivergate Software. All rights reserved.
//

import Cocoa

class ViewController: NSViewController
{
	let currentTestKey = "CurrentTest"
	let currentNumberKey = "CurrentNumber"
	let includeAndKey = "IncludeAnd"
	let useContinueNumbersKey = "UseContinueNumbers"
	let useSingleNumberKey = "UseSingleNumber"
	let cyclePhrasesKey = "CyclePhrases"
	
	@IBOutlet weak var window: NSWindow!
	@IBOutlet weak var document: Document!
	
	// MARK: Properties
	
	var _includeAnd = false
	var includeAnd: Bool
		{
		get {return _includeAnd}
		set{
			_includeAnd = newValue
			let userDefaults = NSUserDefaults.standardUserDefaults()
			userDefaults.setBool(newValue, forKey: includeAndKey)
			document.includeAnd = _includeAnd
		}
	}
	
	var _useContinueNumbers: Bool = false
	var useContinueNumbers: Bool
		{
		get {return _useContinueNumbers}
		set{
			_useContinueNumbers = newValue
			let userDefaults = NSUserDefaults.standardUserDefaults()
			userDefaults.setBool(newValue, forKey: useContinueNumbersKey)
			document.useContinueNumbers = _useContinueNumbers
		}
	}
	
	var _useSingleNumber: Bool = false
	var useSingleNumber: Bool
		{
		get {return _useSingleNumber}
		set{
			_useSingleNumber = newValue
			let userDefaults = NSUserDefaults.standardUserDefaults()
			userDefaults.setBool(_useSingleNumber, forKey: useSingleNumberKey)
			document.useSingleNumber = _useSingleNumber
		}
	}
	
	var _cyclePhrases: Bool = false
	var cyclePhrases: Bool
		{
		get {return _cyclePhrases}
		set{
			_cyclePhrases = newValue
			let userDefaults = NSUserDefaults.standardUserDefaults()
			userDefaults.setBool(newValue, forKey: cyclePhrasesKey)
			document.cyclePhrases = _cyclePhrases
		}
	}
	
	// MARK: Actions
	
	@IBAction func selectTest(sender: NSMenuItem)
	{
		if (sender.tag != document.currentTest)
		{
			document.currentTest = sender.tag
		}
	}
	
	@IBAction func selectNumber(sender: NSMenuItem)
	{
		if (sender.tag != document.numberTag)
		{
			document.numberTag = sender.tag
		}
	}
	
	@IBAction func importAudioFiles(sender: NSMenuItem)
	{
		let openPanel: NSOpenPanel = NSOpenPanel ()
		openPanel.canChooseDirectories = true
		openPanel.canChooseFiles = false
		openPanel.allowsMultipleSelection = false
		openPanel.message = "Import all audio files from directory"
		
		openPanel.beginWithCompletionHandler { (result: Int) -> Void in
			if result == NSFileHandlingPanelOKButton
			{
				self.document.voice = Voice.init (url: openPanel.URL!)
			}
		}
	}
	
	// MARK: Overrides

	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear() {
			super.viewWillAppear()
		
		document = view.window!.windowController!.document as! Document
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}

