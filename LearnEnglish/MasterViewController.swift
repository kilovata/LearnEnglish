//
//  MasterViewController.swift
//  LearnEnglish
//
//  Created by kilovata on 5/11/17.
//  Copyright © 2017 Kilovata. All rights reserved.
//

import UIKit

enum DictionaryType: String
{
    case words
    case verbs
    case idioms
    case phrases
    case textsVideos = "texts & videos"
}

enum Language: String
{
    case eng
    case rus
}

class MasterViewController: UITableViewController
{
    var currentWords = [[String : String]]()
    var currentType = DictionaryType.words
    var currentLanguge = Language.eng
    var showTranslation = true
    var link = "https://www.lang-kit.ru/em3"
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "🇬🇧 ➝ 🇷🇺"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(changeWordTypes))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(changeMainLanguage))
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.tableFooterView = UIView()
        
        setupDictionary()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func setupDictionary()
    {
        if let path = Bundle.main.path(forResource: currentType.rawValue, ofType: "plist") {
            currentWords = NSArray(contentsOfFile: path) as! [[String : String]]
        }
    }
    
    func changeWordTypes()
    {
        let alert = UIAlertController(title: "Choose dictionary", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: DictionaryType.words.rawValue, style: UIAlertActionStyle.default, handler: { (action) in
            self.currentType = .words
            self.updateTitle()
            self.changeDictionary()
        }))
        
        alert.addAction(UIAlertAction(title: DictionaryType.verbs.rawValue, style: UIAlertActionStyle.default, handler: { (action) in
            self.currentType = .verbs
            self.updateTitle()
            self.changeDictionary()
        }))
        
        alert.addAction(UIAlertAction(title: DictionaryType.idioms.rawValue, style: UIAlertActionStyle.default, handler: { (action) in
            self.currentType = .idioms
            self.updateTitle()
            self.changeDictionary()
        }))
        
        alert.addAction(UIAlertAction(title: DictionaryType.phrases.rawValue, style: UIAlertActionStyle.default, handler: { (action) in
            self.currentType = .phrases
            self.updateTitle()
            self.changeDictionary()
        }))
        
        alert.addAction(UIAlertAction(title: DictionaryType.textsVideos.rawValue, style: UIAlertActionStyle.default, handler: { (action) in
            self.currentType = .textsVideos
            self.updateTitle()
            self.changeDictionary()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
            self.dismiss(animated: true, completion: {
                
            })
        }))
            
        present(alert, animated: true) { 
            
        }
    }
    
    func changeMainLanguage()
    {
        switch currentLanguge
        {
            case .eng:
            currentLanguge = .rus
            break
            
            case .rus:
            currentLanguge = .eng
            break
        }
        
        updateTitle()
        tableView.reloadData()
    }
    
    func updateTitle()
    {
        if currentType == .textsVideos
        {
            title = ""
            navigationItem.rightBarButtonItem = nil
        }
        else
        {
            switch currentLanguge
            {
            case .eng:
                title = "🇷🇺 ➝ 🇬🇧"
                break
                
            case .rus:
                title = "🇬🇧 ➝ 🇷🇺"
                break
            }
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(changeMainLanguage))
        }
    }

    func changeDictionary()
    {
        setupDictionary()
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return currentWords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SubtitleCell.self), for: indexPath) as! SubtitleCell
        let item = currentWords[indexPath.row]
        let textNum = "\(indexPath.row + 1). "
        
        if currentType == .textsVideos
        {
            cell.labelTitle.text = textNum + item[Language.eng.rawValue]!
            cell.labelSubTitle.text = nil
        }
        else
        {
            let text = currentLanguge == .eng ? item[Language.eng.rawValue] : item[Language.rus.rawValue]
            cell.labelTitle.text = textNum + text!
            
            if showTranslation {
                cell.labelSubTitle.text = currentLanguge == .eng ? item[Language.rus.rawValue] : item[Language.eng.rawValue]
            } else {
                cell.labelSubTitle.text = nil
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if currentType == .textsVideos
        {
            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let detailVC:DetailViewController = storyBoard.instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as! DetailViewController
            navigationController?.pushViewController(detailVC, animated: true)
            
            let item = currentWords[indexPath.row]
            detailVC.titleScreen = item[Language.eng.rawValue]!
            
            if indexPath.row > 0 {
                link = link.appending("\(indexPath.row + 1)")
            }
            print(link)
            detailVC.link = link
        }
        else
        {
            showTranslation = !showTranslation
        }
        
        tableView.reloadData()
    }
}

