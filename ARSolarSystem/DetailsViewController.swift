//
//  DetailsViewController.swift
//  ARSolarSystem
//
//  Created by Vicentiu Petreaca on 19/06/2019.
//  Copyright © 2019 Vicentiu Petreaca. All rights reserved.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {

    var planetId: String!

    private var url = ""

    @IBOutlet weak var detailsLabel: UILabel! {
        didSet {
            detailsLabel.text = "Detalii"
        }
    }


    @IBOutlet weak var detailsTextView: UITextView!

    @IBAction func moreInfoTapped() {
        let urlObj = URL(string: url)!
        UIApplication.shared.open(urlObj, options: [:], completionHandler: nil)
    }
    
    @IBAction func closeButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        let appDel = (UIApplication.shared.delegate as! AppDelegate)
        let fetchRequest = NSFetchRequest<Planet>(entityName: "Planet")
        fetchRequest.predicate = NSPredicate(format: "id = %@", planetId)
        do {
            if let planet = try appDel.persistentContainer.viewContext.fetch(fetchRequest).first {
                detailsTextView.text = planet.details
                url = planet.url
                navigationItem.title = planet.name
            }
        } catch {
            print("Failed fetch")
        }

    }
}
