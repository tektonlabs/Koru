/* 

=========================================================================== 
Koru GPL Source Code 
Copyright (C) 2017 Tekton Labs
This file is part of the Koru GPL Source Code.
Koru Source Code is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by 
the Free Software Foundation, either version 3 of the License, or 
(at your option) any later version. 

Koru Source Code is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details. 

You should have received a copy of the GNU General Public License 
along with Koru Source Code. If not, see <http://www.gnu.org/licenses/>. 
=========================================================================== 

*/

import Foundation
import CoreData


class RefugePersistence: NSObject {
    
    var dataController = DataController()
    var managedContext: NSManagedObjectContext
    
    override init() {
        managedContext = dataController.managedObjectContext
    }
    
    func fetchAllRefugeWith()-> [Refuge] {
        
        var listRefugeMO = [Refuge]()
        
        let fetchRequest = NSFetchRequest<RefugeMO>(entityName: "Refuge")
        
        fetchRequest.predicate = NSPredicate(value: true)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            if results.count > 0 {
                for index in 0..<results.count {
                    let refugeMO = results[index]
                    let refuge = Refuge(refugeMO: refugeMO)
                    listRefugeMO.append(refuge)
                }
            }            
        } catch let error as NSError {
            print("Error sync CoreData: \(error)")
        }
        
        return listRefugeMO
        
    }
    
    func fetchAllRefuge()-> [Refuge] {
        
        var listRefugeMO = [Refuge]()
        
        let fetchRequest = NSFetchRequest<RefugeMO>(entityName: "Refuge")
        
        
        fetchRequest.predicate = NSPredicate(value: true)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            if results.count >  0 {
                for index in 0...results.count - 1 {
                    let refugeMO = results[index]
                    let refuge = Refuge(refugeMO: refugeMO)
                    listRefugeMO.append(refuge)
                }
            }
        } catch let error as NSError {
            print("Error sync CoreData: \(error)")
        }
        
        return listRefugeMO
    }

    func fetchAllRefugeMO() -> [RefugeMO] {
        var listRefugeMO = [RefugeMO]()
        
        let fetchRequest = NSFetchRequest<RefugeMO>(entityName: "Refuge")
        
        
        fetchRequest.predicate = NSPredicate(value: true)
        
        do {
            listRefugeMO = try managedContext.fetch(fetchRequest)
            
            
        } catch let error as NSError {
            print("Error sync CoreData: \(error)")
        }
        
        return listRefugeMO
    }
    
    func fetch(refuge: Refuge, withCompletion completion: (_ refugeMO: RefugeMO) -> Void){
        let fetchRequest = NSFetchRequest<RefugeMO>(entityName: "Refuge")
        fetchRequest.predicate = NSPredicate(value: true)
        do {
            let result = try managedContext.fetch(fetchRequest)
            for index in 0...result.count - 1 {
                let refugeMO = result[index]
                if refugeMO.id == Int64(refuge.id!) {
                    completion(refugeMO)
                    return
                }
            }
        } catch let error as NSError {
            print("Error sync CoreData: \(error)")
        }
    }
    
    func fetchRefugeWithCategory(refuge: Refuge) -> Refuge {
        let fetchRequest = NSFetchRequest<RefugeMO>(entityName: "Refuge")
        fetchRequest.predicate = NSPredicate(value: true)
        var ref: Refuge!
        do {
            let result = try managedContext.fetch(fetchRequest)
            for index in 0...result.count - 1 {
                let refugeMO = result[index]
                if refugeMO.id == Int64(refuge.id!) {
                    ref = Refuge(refugeMO: refugeMO)
                }
            }
        } catch let error as NSError {
            print("Error sync CoreData: \(error)")
        }
        return ref
    }
    
    func create(refuge: Refuge, withCompletion completion: @escaping (Bool) -> Void) {
        if !verifyData(refuge: refuge) {
                let newRefuge = NSEntityDescription.insertNewObject(forEntityName: "Refuge", into: managedContext) as! RefugeMO
                let newCountry = NSEntityDescription.insertNewObject(forEntityName: "Country", into: managedContext) as! CountryMO
        
                newCountry.id = Int64(refuge.country!.id!)
                newCountry.iso = refuge.country?.iso
                newCountry.name = refuge.country?.name
    
                newRefuge.id = Int64(refuge.id!)
                newRefuge.name = refuge.name
                newRefuge.city = refuge.city
                newRefuge.latitude = refuge.latitude
                newRefuge.longitude = refuge.latitude
                newRefuge.address = refuge.address
                newRefuge.status = refuge.status
                newRefuge.count = newCountry
                newRefuge.catego = nil
            
            do {
                try managedContext.save()
            
                completion(true)
            
            } catch {
                completion(false)
            }
        }
    }
    
    func verifyData(refuge: Refuge) -> Bool {
        let fetchRequest = NSFetchRequest<RefugeMO>(entityName: "Refuge")
        var exist = false
        
        fetchRequest.predicate = NSPredicate(value: true)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            if results.count > 0 {
                exist = results.filter { return Int64(refuge.id!) == $0.id }.count == 1
            }
        
        } catch let error as NSError {
            print("Error sync CoreData: \(error)")
        }
        
        return exist
    }
    
    // Update refuge with category
    func updateRefuge(with categories: [Category], refuge: Refuge, withCompletion completion: (Bool) -> Void) {
        fetch(refuge: refuge) { refugeMO in
        if let categoriesMO = refugeMO.catego?.allObjects as! [CategoryMO]? {
        if categoriesMO.count == 0 {
        for category in categories {
            let newCategory = NSEntityDescription.insertNewObject(forEntityName: "Category", into: managedContext) as! CategoryMO
            newCategory.id = Int64(category.id!)
            newCategory.level = category.level
            newCategory.name = category.name
        
            if let sortedQuestionArray = category.sortedQuestionArray {
                for (_,sortedQuestion) in sortedQuestionArray.enumerated() {
                let newSortedQuestion = NSEntityDescription.insertNewObject(forEntityName: "SortedQuestion", into: managedContext) as! SortedQuestionMO
                    newSortedQuestion.id = Int64(sortedQuestion.id!)
                    newSortedQuestion.text = sortedQuestion.text
                    newSortedQuestion.questionType = sortedQuestion.questionType
                    newSortedQuestion.maxValue = sortedQuestion.maxValue
                    newSortedQuestion.minValue = sortedQuestion.minValue
                    
                    if let subQuestionArray =  sortedQuestion.subQuestions {
                        for (_,subQuestion) in subQuestionArray.enumerated() {
                            let newSubQuestion = NSEntityDescription.insertNewObject(forEntityName: "SortedQuestion", into: managedContext) as! SortedQuestionMO
                            newSubQuestion.id = Int64(subQuestion.id!)
                            newSubQuestion.text = subQuestion.text
                            newSubQuestion.maxValue = subQuestion.maxValue
                            newSubQuestion.minValue = subQuestion.minValue
                            newSubQuestion.questionType = subQuestion.questionType
                            
                            if let answerArray = subQuestion.answerArray {
                                for (_,answer) in answerArray.enumerated() {
                                    let newAnswer = NSEntityDescription.insertNewObject(forEntityName: "Answer", into: managedContext) as! AnswerMO
                                    newAnswer.id = Int64(answer.id!)
                                    newAnswer.name = answer.name
                                    newAnswer.createdAt = answer.createdAt
                                    newAnswer.updatedUp = answer.updatedAt
                                    if let withValue = answer.withValue {
                                        newAnswer.withValue = withValue
                                    }
                                    if let selected = answer.selected {
                                        newAnswer.selected = selected
                                    }
                                    
                                    newSubQuestion.addToAnswer(newAnswer)
                                }
                            }
                            newSortedQuestion.addToSubquest(newSubQuestion)
                        }
                    }
                    if let answerArray = sortedQuestion.answerArray {
                        for (_,answer) in answerArray.enumerated() {
                            let newAnswer = NSEntityDescription.insertNewObject(forEntityName: "Answer", into: managedContext) as! AnswerMO
                            newAnswer.id = Int64(answer.id!)
                            newAnswer.name = answer.name
                            newAnswer.createdAt = answer.createdAt
                            newAnswer.updatedUp = answer.updatedAt
                            if let withValue = answer.withValue {
                                newAnswer.withValue = withValue
                            }
                            if let selected = answer.selected {
                                newAnswer.selected = selected
                            }
                            newSortedQuestion.addToAnswer(newAnswer)
                        }
                    }                    
                    newCategory.addToSortedques(newSortedQuestion)
                }
            }
            refugeMO.addToCatego(newCategory)
        }
            }
            }
        do {
            try managedContext.save()
            
            completion(true)
            
        } catch {
            completion(false)
        }
    
        }
    }
    
    
    
    func updateRefugeWith(pending sortedQuestionArray: [SortedQuestion], refugeSelected: Refuge,dni: String, date: Int, withCompletion completion: (Bool) -> Void) {
        fetch(refuge: refugeSelected) { refugeMO in
            let newPendendigShortedQuestion = NSEntityDescription.insertNewObject(forEntityName: "Pending", into: managedContext) as! PendingMO
            newPendendigShortedQuestion.dni = dni
            newPendendigShortedQuestion.date = Int64(date)
            
                for (_,sortedQuestion) in sortedQuestionArray.enumerated() {
                    let newSortedQuestion = NSEntityDescription.insertNewObject(forEntityName: "SortedQuestion", into: managedContext) as! SortedQuestionMO
                    newSortedQuestion.id = Int64(sortedQuestion.id!)
                    newSortedQuestion.text = sortedQuestion.text
                    newSortedQuestion.questionType = sortedQuestion.questionType
                    newSortedQuestion.maxValue = sortedQuestion.maxValue
                    newSortedQuestion.minValue = sortedQuestion.minValue
                    
                    if let subQuestionArray =  sortedQuestion.subQuestions {
                        for (_,subQuestion) in subQuestionArray.enumerated() {
                            let newSubQuestion = NSEntityDescription.insertNewObject(forEntityName: "SortedQuestion", into: managedContext) as! SortedQuestionMO
                            newSubQuestion.id = Int64(subQuestion.id!)
                            newSubQuestion.text = subQuestion.text
                            newSubQuestion.maxValue = subQuestion.maxValue
                            newSubQuestion.minValue = subQuestion.minValue
                            newSubQuestion.questionType = subQuestion.questionType
                            
                            if let answerArray = subQuestion.answerArray {
                                for (_,answer) in answerArray.enumerated() {
                                    let newAnswer = NSEntityDescription.insertNewObject(forEntityName: "Answer", into: managedContext) as! AnswerMO
                                    newAnswer.id = Int64(answer.id!)
                                    newAnswer.name = answer.name
                                    newAnswer.createdAt = answer.createdAt
                                    newAnswer.updatedUp = answer.updatedAt
                                    newAnswer.withValue = answer.withValue!
                                    newAnswer.value = answer.value
                                    
                                    if let selected = answer.selected {
                                        newAnswer.selected = selected
                                    }
                                    newSubQuestion.addToAnswer(newAnswer)
                                }
                            }
                            newSortedQuestion.addToSubquest(newSubQuestion)
                        }
                    }
                    if let answerArray = sortedQuestion.answerArray {
                        for (_,answer) in answerArray.enumerated() {
                            let newAnswer = NSEntityDescription.insertNewObject(forEntityName: "Answer", into: managedContext) as! AnswerMO
                            newAnswer.id = Int64(answer.id!)
                            newAnswer.name = answer.name
                            newAnswer.createdAt = answer.createdAt
                            newAnswer.updatedUp = answer.updatedAt
                            if let withValue = answer.withValue {
                                newAnswer.withValue = withValue
                            }
                            newAnswer.value = answer.value
                            
                            if let selected = answer.selected {
                                newAnswer.selected = selected
                            }
                            newSortedQuestion.addToAnswer(newAnswer)
                        }
                    }
                    newPendendigShortedQuestion.addToSortedQues(newSortedQuestion)
                }
                refugeMO.addToPending(newPendendigShortedQuestion)
            }
        
        do {
            try managedContext.save()
            
            completion(true)
    
        } catch {
            completion(false)
        }
    }
    
    
    func deletePendingForm(refuge: Refuge, pending: PendingQuestionForm) {
        fetch(refuge: refuge) { refugeMO in
            let pendingsForm = refugeMO.pending?.allObjects as! [PendingMO]
                for pendingMO in pendingsForm {
                    if Int(pendingMO.date) == pending.date {
                        refugeMO.removeFromPending(pendingMO)
                    }
                }
            }
        
        saveChanges()
        
        if verifyPendingForm() == false {
            NotificationManager.sharedInstance.postNotificationSendAllQuestionForm()
        }
        
    }
    
    func verifyPendingForm() -> Bool {
        let refugesMO = fetchAllRefugeMO()
        var theArePending = false
        for refuge in refugesMO {
            let pendings = refuge.pending?.allObjects as! [PendingMO]
            if pendings.count > 0 {
                theArePending = true
                break
            }
        }
        return theArePending
    }


    func searchRefuges(with text: String) ->  [Refuge] {
        print(text)
        var listRefugeMO = [Refuge]()
        
        let fetchRequest = NSFetchRequest<RefugeMO>(entityName: "Refuge")
        
        fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", "\(text)")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
                for index in results {
                    let refuge = Refuge(refugeMO: index)
                    listRefugeMO.append(refuge)
                
            }
        } catch let error as NSError {
            print("Error sync CoreData: \(error)")
        }
        
        return listRefugeMO
    }
    
    
    func deleteAll() {
        let fetchRequest = NSFetchRequest<RefugeMO>(entityName: "Refuge")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult> )
        // Create Batch Delete Request
        do {
            try managedContext.execute(deleteRequest)
            
        } catch {
            // Error Handling
        }
    }
    
   
    
    
    func saveChanges(){
        do{
            print("Saving in managedContext: \(managedContext)")
            try managedContext.save()
            
        } catch let error as NSError {
            // failure
            print(error)
        }
    }
}

