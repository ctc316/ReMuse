//
//  ViewController.swift
//  ReMuse
//
//  Created by ctc316 on 2018/10/18.
//  Copyright © 2018年 ctc316. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var songs:[SongView] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        songs = createSongViews()
        setupScrollView(songs: songs)
        
        pageControl.numberOfPages = songs.count
        pageControl.currentPage = 0
        
        view.bringSubviewToFront(pageControl)
    }
    
    func createSongViews() -> [SongView] {
        let song1:SongView = Bundle.main.loadNibNamed("SongView", owner: self, options: nil)?.first as! SongView
        song1.imageView.image = UIImage(named: "song1")
        song1.nameLabel.text = "Song 1"
        
        let song2:SongView = Bundle.main.loadNibNamed("SongView", owner: self, options: nil)?.first as! SongView
        song2.imageView.image = UIImage(named: "song2")
        song2.nameLabel.text = "Song 2"
        
        let song3:SongView = Bundle.main.loadNibNamed("SongView", owner: self, options: nil)?.first as! SongView
        song3.imageView.image = UIImage(named: "song3")
        song3.nameLabel.text = "Song 3"
        
        return [song1, song2, song3]
    }
    
    func setupScrollView(songs: [SongView]) {
        scrollView.frame = CGRect(x: 0, y: 58, width: view.frame.width, height: view.frame.height * 2 / 3)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(songs.count), height: view.frame.height * 2 / 3)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< songs.count {
            songs[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            scrollView.addSubview(songs[i])
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
//        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
//        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
//
//        // vertical
//        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
//        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
//
//        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
//        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
//
//
//        /*
//         * below code changes the background color of view on paging the scrollview
//         */
//        //        self.scrollView(scrollView, didScrollToPercentageOffset: percentageHorizontalOffset)
//
//
//        /*
//         * below code scales the imageview on paging the scrollview
//         */
//        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
//
//        if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
//
//            songs[0].imageView.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
//            songs[1].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.25, y: percentOffset.x/0.25)
//
//        } else if(percentOffset.x > 0.25 && percentOffset.x <= 0.50) {
//            songs[1].imageView.transform = CGAffineTransform(scaleX: (0.50-percentOffset.x)/0.25, y: (0.50-percentOffset.x)/0.25)
//            songs[2].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.50, y: percentOffset.x/0.50)
//
//        } else if(percentOffset.x > 0.50 && percentOffset.x <= 0.75) {
//            songs[2].imageView.transform = CGAffineTransform(scaleX: (0.75-percentOffset.x)/0.25, y: (0.75-percentOffset.x)/0.25)
//            songs[3].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.75, y: percentOffset.x/0.75)
//
//        } else if(percentOffset.x > 0.75 && percentOffset.x <= 1) {
//            songs[3].imageView.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/0.25, y: (1-percentOffset.x)/0.25)
//            songs[4].imageView.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
//        }
    }

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
}

