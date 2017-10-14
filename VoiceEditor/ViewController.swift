	//
//  Copyright © 2015 Rivergate Software. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextDelegate
{
//	var speakWithAudioFiles: Bool {
//		get {return document.useAudioFiles}
//		set {document.useAudioFiles = newValue}
//	}
	
	let speakWithAudioFilesAudioFiles = "speakAudio"
	
	@IBOutlet weak var document: Document!

	@IBOutlet var languageTextField: NSTextField!
	@IBOutlet var localeTextField: NSTextField!
	@IBOutlet var voiceNameTextField: NSTextField!
	@IBOutlet var handText: NSTextField!
	
	override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool
	{
		
		return true
	}
	
	// MARK: Delegate functions
	
	// MARK: Actions
	
	@IBAction func editLanguage(_ sender: NSTextField)
	{
		document.language = sender.stringValue
	}
	
	@IBAction func editLocale(_ sender: NSTextField)
	{
		document.locale = sender.stringValue
	}
	
	@IBAction func editVoiceName(_ sender: NSTextField)
	{
		document.voiceName = sender.stringValue
	}
	
	@IBAction func generate(_ sender: AnyObject)
	{
		document.generateScores()
	}
	
	@IBAction func speakHand(_ sender: NSTextField)
	{
		document.speakHandText(sender.stringValue)
	}
	
	@IBAction func speak(_ sender: AnyObject)
	{
		document.speakHandText(handText.stringValue)
	}
	
	@IBAction func importAudioFiles(_ sender: NSMenuItem)
	{
		let openPanel: NSOpenPanel = NSOpenPanel ()
		openPanel.canChooseDirectories = true
		openPanel.canChooseFiles = false
		openPanel.allowsMultipleSelection = false
		openPanel.message = "Import all audio files from directory"
		
		openPanel.begin { (result: Int) -> Void in
			if result == NSFileHandlingPanelOKButton
			{
				self.document.generateScores()
				self.document.generateDurations (openPanel.url!)
				self.voiceNameTextField.stringValue = self.document.voiceName
			}
		}
	}
	
	@IBAction func exportAudioFolder(_ sender: NSMenuItem)
	{
		let savePanel: NSSavePanel = NSSavePanel ()
		savePanel.canCreateDirectories = true
		savePanel.message = "Export audio folder"
		savePanel.nameFieldStringValue = self.document.voiceName
		
		savePanel.begin { (result: Int) -> Void in
			if result == NSFileHandlingPanelOKButton
			{
				self.document.exportAudioFolder (savePanel.url!)
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
//		speakWithAudioFiles = self.document.useAudioFiles
	}
}

