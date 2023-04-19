import SwiftUI
import CoreData

// CoreData controller
struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        do {
            try viewContext.save()
        } catch {
            // fatal error
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        // Creating the entity
        let memoryEntity = NSEntityDescription()
        memoryEntity.name = "Memory"
        memoryEntity.managedObjectClassName = "Memory"
        
        // create the attributes and append them to entity
        let idAttribute = NSAttributeDescription()
        idAttribute.name = "id"
        idAttribute.type = .uuid
        memoryEntity.properties.append(idAttribute)
        
        let nameAttribute = NSAttributeDescription()
        nameAttribute.name = "name"
        nameAttribute.type = .string
        memoryEntity.properties.append(nameAttribute)
        
        let imageAttribute = NSAttributeDescription()
        imageAttribute.name = "image"
        imageAttribute.type = .binaryData
        memoryEntity.properties.append(imageAttribute)
        
        let colorAttribute = NSAttributeDescription()
        colorAttribute.name = "color"
        colorAttribute.type = .transformable
        memoryEntity.properties.append(colorAttribute)
        
        let dateAttribute = NSAttributeDescription()
        dateAttribute.name = "date"
        dateAttribute.type = .date
        memoryEntity.properties.append(dateAttribute)
        
        
        // create Core Data model
        let model = NSManagedObjectModel()
        model.entities = [memoryEntity]
        
        // container
        container = NSPersistentContainer(name: "Memories1", managedObjectModel: model)
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // load error
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
