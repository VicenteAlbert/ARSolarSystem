//
//  AppDelegate.swift
//  ARSolarSystem
//
//  Created by Vicentiu Petreaca on 09/06/2019.
//  Copyright © 2019 Vicentiu Petreaca. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
        let ud = UserDefaults.standard
        if ud.bool(forKey: "wasDatabasePopulated") == false {
            if let url = Bundle.main.url(forResource: "planete", withExtension: "json"),
                let data = try? Data(contentsOf: url),
                let planets = try? JSONDecoder().decode([PlanetModel].self, from: data) {
                let bgContext = persistentContainer.newBackgroundContext()
                planets.forEach {
                    let entity = NSEntityDescription.entity(forEntityName: "Planet", in: bgContext)
                    let planet = NSManagedObject(entity: entity!, insertInto: bgContext) as? Planet
                    planet?.id = $0.id
                    planet?.name = $0.name
                    planet?.details = $0.details
                    planet?.url = $0.url
                    do {
                        try bgContext.save()
                        ud.setValue(true, forKey: "wasDatabasePopulated")
                    } catch { }
                }
            }
        }
        return true
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ARSolarSystem")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
