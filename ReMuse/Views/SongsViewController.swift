//
//  SongsViewController.swift
//  ReMuse
//
//  Created by ctc316 on 2018/11/4.
//  Copyright © 2018年 ctc316. All rights reserved.
//

import AVFoundation
import MediaPlayer
import UIKit

class SongsViewController: UITableViewController {
    
    var albumName: String!
    var artistName: String!
    var songsList = [MPMediaItem]()
    var sampleSongList = [AVPlayerItem]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = Bundle.main.url(forResource: "Soundtracks", withExtension: "bundle"), let bundle = Bundle(url: url) {
            
            for song in ["Bloodstream", "Bohemian Rhapsody", "Highway to Hell", "Smoke On The Water", "Take Me to Church", "The Magic Flute - Queen of the Night", "Thinking Out Loud", "Wonderwall"] {
                if let fileurl = bundle.url(forResource: song, withExtension: "mp3") {
                    sampleSongList.append(AVPlayerItem(url: fileurl))
                }
            }
        }
        
        let songsQuery = MPMediaQuery.songs()
        if let items = songsQuery.items {
            songsList = items
            tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String {
        if section == 0 {
            return "Sample Songs"
        }
        return "Your Songs"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45.0
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        returnedView.backgroundColor = UIColor.darkGray
        
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.size.width, height: 25))
        if section == 0 {
            label.text = "From Sample Songs"
        }
        else {
            label.text = "From Your iTunes Library"
        }
        label.textColor = UIColor.white
        label.font = label.font.withSize(16)
        returnedView.addSubview(label)
        
        return returnedView
    }
    
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return sampleSongList.count
        }
        return songsList.count
    }
    
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SongCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ??
            UITableViewCell(style: .default,
                            reuseIdentifier: cellIdentifier)
        
        if indexPath.section == 0 {
            let song: AVPlayerItem = sampleSongList[(indexPath as NSIndexPath).row]
            let metadataList = song.asset.metadata
            for item in metadataList {
                guard let key = item.commonKey?.rawValue, let value = item.value else {
                    continue
                }
                switch key {
                    case "title" : cell.textLabel?.text = value as? String
                    case "artist" : cell.detailTextLabel?.text = value as? String
                    default:
                        break
                }
            }
            return cell
        }
            
        else {
            let song: MPMediaItem = songsList[(indexPath as NSIndexPath).row]
            let songTitle = song.value(forProperty: MPMediaItemPropertyTitle) as? String ?? ""
            let songArtist = song.value(forProperty: MPMediaItemPropertyArtist) as? String ?? ""

            cell.textLabel?.text = songTitle
            cell.detailTextLabel?.text = songArtist
            
            return cell
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        if segue.identifier == "SongSegue" {
//            if let indexPath = tableView.indexPathForSelectedRow {
//                if let songVC = segue.destination as? SongViewController {
//                    songVC.song = songsList[(indexPath as NSIndexPath).row]
//                    songVC.title = songVC.song!.value(forProperty: MPMediaItemPropertyTitle) as? String
//                }
//            }
//        }
        
    }
}
