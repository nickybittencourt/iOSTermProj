//
//  QuotesListViewController.swift
//  KanyeWithMe
//
//  Created by Nicholas Bittencourt  on 2020-11-27.
//

import Foundation
import UIKit
import CoreData

class QuotesListViewController: UIViewController {
    
    var quotesList: [Quote] = []
    @IBOutlet weak var quotesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let quoteFetch: NSFetchRequest<Quote> = Quote.fetchRequest()
        
        do {
            
            quotesList = try context.fetch(quoteFetch)
            
        } catch {
            print("Error")
        }
        
        quotesTableView.reloadData()
    }
}

extension QuotesListViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return quotesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) 
        
        cell.textLabel?.text = quotesList[indexPath.row].quote
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let quote = quotesList[indexPath.row]
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            context.delete(quote)
            quotesList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            appDelegate.saveContext()
        }
    }
}

extension QuotesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}

extension QuotesListViewController: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        
        if let indexPath = quotesTableView.indexPathForSelectedRow {
            
            quotesTableView.deselectRow(at: indexPath, animated: true)
        }
    }
}



































