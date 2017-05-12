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
        let alert = UIAlertController(title: "Choose type", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: DictionaryType.words.rawValue, style: UIAlertActionStyle.default, handler: { (action) in
            self.currentType = .words
            self.changeDictionary()
        }))
        
        alert.addAction(UIAlertAction(title: DictionaryType.verbs.rawValue, style: UIAlertActionStyle.default, handler: { (action) in
            self.currentType = .verbs
            self.changeDictionary()
        }))
        
        alert.addAction(UIAlertAction(title: DictionaryType.idioms.rawValue, style: UIAlertActionStyle.default, handler: { (action) in
            self.currentType = .idioms
            self.changeDictionary()
        }))
        
        alert.addAction(UIAlertAction(title: DictionaryType.phrases.rawValue, style: UIAlertActionStyle.default, handler: { (action) in
            self.currentType = .phrases
            self.changeDictionary()
        }))
        
        alert.addAction(UIAlertAction(title: DictionaryType.textsVideos.rawValue, style: UIAlertActionStyle.default, handler: { (action) in
            self.currentType = .textsVideos
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
            title = "🇷🇺 ➝ 🇬🇧"
            break
            
            case .rus:
            currentLanguge = .eng
            title = "🇬🇧 ➝ 🇷🇺"
            break
        }
        
        tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubtitleCell", for: indexPath) as! SubtitleCell
        let item = currentWords[indexPath.row]
        
        if currentType == .textsVideos
        {
            cell.labelTitle.text = item["eng"]
            cell.labelSubTitle.text = nil
        }
        else
        {
            cell.labelTitle.text = currentLanguge == .eng ? item["eng"] : item["rus"]
            
            if showTranslation {
                cell.labelSubTitle.text = currentLanguge == .eng ? item["rus"] : item["eng"]
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
            let detailVC:DetailViewController = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            navigationController?.pushViewController(detailVC, animated: true)
            
            let item = currentWords[indexPath.row]
            detailVC.titleScreen = item["eng"]!
            
            var link = "https://www.lang-kit.ru/em3"
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

