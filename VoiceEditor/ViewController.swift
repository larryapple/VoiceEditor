//
//  Copyright © 2015 Rivergate Software. All rights reserved.
//

import Cocoa

class ViewController: NSViewController
{	
	@IBOutlet weak var document: Document!
	
	override func validateMenuItem(menuItem: NSMenuItem) -> Bool
	{
		var tag: Int = menuItem.tag
		if tag > 0 && tag < 50
		{
			menuItem.state = tag == document.currentTest ? NSOnState : NSOffState
		}
		
		else if tag >= 50
		{
			tag -= 50
			menuItem.state =  tag == document.numberTag ? NSOnState : NSOffState
		}
		
		return true
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
	
	@IBAction func startTest(sender: NSButton)
	{
		if document.isBusy()
		{
			document.stopTest()
		}
		else
		{
			document.startTest()
		}
	}
	
	@IBAction func includeAnd(sender: NSMenuItem)
	{
		document.includeAnd = !document.includeAnd
		sender.state = document.includeAnd ? NSOnState : NSOffState
	}
	
	@IBAction func useContinueNumbers(sender: NSMenuItem)
	{
		document.useContinueNumbers = !document.useContinueNumbers
		sender.state = document.useContinueNumbers ? NSOnState : NSOffState
	}
	
	@IBAction func useSingleNumber(sender: NSMenuItem)
	{
		document.useSingleNumber = !document.useSingleNumber
		sender.state = document.useSingleNumber ? NSOnState : NSOffState
	}
	
	@IBAction func cyclePhrases(sender: NSMenuItem)
	{
		document.cyclePhrases = !document.cyclePhrases
		sender.state = document.cyclePhrases ? NSOnState : NSOffState
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

	override func viewWillAppear() {
			super.viewWillAppear()
		
		document = view.window!.windowController!.document as! Document
	}

}

