	//
//  Copyright © 2015 Rivergate Software. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextDelegate
{	
	@IBOutlet weak var document: Document!

	@IBOutlet var languageTextField: NSTextField!
	@IBOutlet var localeTextField: NSTextField!
	@IBOutlet var voiceNameTextField: NSTextField!
	
	override func validateMenuItem(menuItem: NSMenuItem) -> Bool
	{
		
		return true
	}
	
	// MARK: Delegate functions
	
	// MARK: Actions
	
	@IBAction func editLanguage(sender: NSTextField)
	{
		document.language = sender.stringValue
	}
	
	@IBAction func editLocale(sender: NSTextField)
	{
		document.locale = sender.stringValue
	}
	
	@IBAction func editVoiceName(sender: NSTextField)
	{
		document.voiceName = sender.stringValue
	}
	
	@IBAction func generate(sender: AnyObject)
	{
		document.generateScores()
	}
	
	@IBAction func speakHand(sender: NSTextField)
	{
		document.speakHandText(sender.stringValue)
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
				self.document.generateDurations (openPanel.URL!)
				self.document.generateScores()
				self.voiceNameTextField.stringValue = self.document.voiceName
			}
		}
	}
	
	@IBAction func exportAudioFolder(sender: NSMenuItem)
	{
		let savePanel: NSSavePanel = NSSavePanel ()
		savePanel.canCreateDirectories = true
		savePanel.message = "Export audio folder"
		savePanel.nameFieldStringValue = self.document.voiceName
		
		savePanel.beginWithCompletionHandler { (result: Int) -> Void in
			if result == NSFileHandlingPanelOKButton
			{
				self.document.exportAudioFolder (savePanel.URL!)
			}
		}
	}
	
	// MARK: Overrides

	override func viewWillAppear()
	{
		super.viewWillAppear()
		
		document = view.window!.windowController!.document as! Document
		languageTextField.stringValue = self.document.language
		localeTextField.stringValue = self.document.locale
		voiceNameTextField.stringValue = self.document.voiceName
	}
}

