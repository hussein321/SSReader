//
//  ArticleCollectionView.swift
//  Rsreader
//
//  Created by hoseen on 3/19/16.
//  Copyright © 2016 hoseen. All rights reserved.
//

import UIKit

private let reuseIdentifier = "articleCell"

class ArticleCollectionView: UICollectionViewController {
    var articles = [Article]()
    var currentArticle = Article()
    var parsedElement = ""
    var currentImageUrl = ""
    
    
    var  xmlparser : NSXMLParser!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let urlString = NSURL(string :"http://techcrunch.com/feed/")
       // let urlRequst = NSURLRequest(URL: urlString!)
        let task = NSURLSession.sharedSession().dataTaskWithURL(urlString!){
            (data,response, error) in
            if error != nil {
                print(error?.localizedDescription)
            }
            
            self.xmlparser = NSXMLParser(data: data!)
            self.xmlparser.delegate = self
            self.xmlparser.parse()
            

            
        }
        task.resume()
        
        
        
        
        
       /* let queue : NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(urlRequst, queue: queue, completionHandler: {
            (response, data, error)-> Void in
            if error != nil {
                print(error?.localizedDescription)
            }
            
    self.xmlparser = NSXMLParser(data: data!)
            self.xmlparser.delegate = self
            self.xmlparser.parse()
         
        
    })*/

    
       
       


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        let flowout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flowout.invalidateLayout()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if segue.identifier == "showDetails" {
            let controler = segue.destinationViewController as! DetailViewController
            let indexpath = sender as! NSIndexPath
            controler.currentArticle = articles[indexpath.row]
        }
        
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return articles.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let article = articles[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ArticleCell
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)){
            if article.imageurl.isEmpty{
                return
            }
            let imgurl = NSURL(string : article.imageurl)
            if imgurl == nil {
                return
            }
            let imagedata = NSData(contentsOfURL: imgurl!)
            if imagedata == nil {
                return
            }
            let currentImg = UIImage(data: imagedata!)
            dispatch_async(dispatch_get_main_queue()){
                cell.imageView.image = currentImg
                
            }
            
        }
        
        cell.titleLable.text = article.title
        
    
    
        return cell
    }

}






extension ArticleCollectionView : NSXMLParserDelegate  {
    
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "item"{
            currentArticle = Article()
            return
                     }
        if elementName == "title"{
            parsedElement = "title"
        }
        if elementName == "link"{
            parsedElement = "link"
        }
        if elementName == "media:content"{
            currentImageUrl = attributeDict["url"] as String!
            
        }
   
        
        
        
         }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
         let str = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if parsedElement == "title"{
            if currentArticle.title.isEmpty{
                currentArticle.title = str
                //print(currentArticle.title)
            }
        }
        if parsedElement == "link"{
            if currentArticle.url.isEmpty{
                currentArticle.url = str
            }
        }
        
        
        
        
        
        
        
        
        
        
    }
    
   /* func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
      /* if elementName != "item"{
        return
        }*/
        articles.append(currentArticle)
        print(articles.count)
    }*/
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName != "item"{
            return
        }
        
        currentArticle.imageurl = currentImageUrl
        articles.append(currentArticle)
       
    }
    
    
    func parserDidEndDocument(parser: NSXMLParser) {
        
        
        dispatch_async(dispatch_get_main_queue()){
        
        self.collectionView!.reloadData()
            //print(self.articles.count)
       }
        
    }
    
}


extension ArticleCollectionView {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout : UICollectionViewLayout , sizeForItemAtIndexPath indexpath : NSIndexPath) -> CGSize {
        
        let width = CGRectGetWidth(collectionView.bounds)
        var colums = 2
        var gaps = 1
        
        if UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation){
            colums = 3
            gaps = 2
            
        }
        
        let temwidth = width - CGFloat(gaps)
        let totalywidth = temwidth / CGFloat(colums)
        
        return CGSize(width: totalywidth, height: totalywidth)
        
    }
    
    

        func collectionView(collectionView: UICollectionView, layout collectionViewLayout : UICollectionViewLayout , insetForSectionAtIndex section : Int) -> UIEdgeInsets {
            
            
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout : UICollectionViewLayout , minimumLineSpacingForSectionAtIndex section : Int) -> CGFloat {
        return CGFloat(1)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout : UICollectionViewLayout , minimumInteritemSpacingForSectionAtIndex section : Int) -> CGFloat {
        return CGFloat(1)
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //self.prepareForSegue("showDetails", sender: indexPath)
        self.performSegueWithIdentifier("showDetails", sender: indexPath)
    }

    
}









