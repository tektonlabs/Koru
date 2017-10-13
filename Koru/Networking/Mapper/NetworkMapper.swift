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

class NetworkMapper {
    
    func bodyRefungeForm(from refugeForm: RefugeForm) -> [String: Any] {
        var body = [String: Any]()
        body["name"] = refugeForm.name
        body["latitude"] = refugeForm.latitude
        body["longitude"] = refugeForm.longitude
        body["address"] = refugeForm.address
        body["city"] = refugeForm.city
        body["country_iso"] = refugeForm.countryISO
        body["emergency_type"] = refugeForm.emergencyType.value
        
        if let refugeType = refugeForm.refugeType {
            body["refuge_type"] = refugeType.value
        } else {
            body["refuge_type"] = ""
        }
        
        if let institutionInCharge = refugeForm.institutionInCharge {
            body["institution_in_charge"] = institutionInCharge.value
        } else {
            body["institution_in_charge"] = ""
        }
        
        if let propertyType = refugeForm.propertyType {
            body["property_type"] = propertyType.value
        } else {
            body["property_type"] = ""
        }
        
        if let accessibility = refugeForm.accessibility {
            body["accessibility"] = accessibility.value
        } else {
            body["accessibility"] = ""
        }
        
        if let victimsProvenance = refugeForm.victimsProvenance {
            body["victims_provenance"] = victimsProvenance.value
        } else {
            body["victims_provenance"] = ""
        }
        
        if let floorType = refugeForm.floorType {
            body["floor_type"] = floorType.value
        } else {
            body["floor_type"] = ""
        }
        
        if let roofType = refugeForm.roofType {
            body["roof_type"] = roofType.value
        } else {
            body["roof_type"] = ""
        }

        body["number_of_families"] = refugeForm.numberOfFamilies
        body["number_of_children_under_3_male"] = refugeForm.numberOfMaleChildrensUnder3
        body["number_of_children_under_3_female"] = refugeForm.numberOfFemaleChildrensUnder3
        body["number_of_people_less_than_or_equals_to_18_male"] = refugeForm.numberOfMalePeopleLessThanOrEqualsTo18
        body["number_of_people_less_than_or_equals_to_18_female"] = refugeForm.numberOfFemalePeopleLessThanOrEqualsTo18
        body["number_of_people_older_than_18_male"] = refugeForm.numberOfMalePeopleOlderThan18
        body["number_of_people_older_than_18_female"] = refugeForm.numberOfFemalePeopleOlderThan18
        body["number_of_older_adults_male"] = refugeForm.numberOfMaleOlderAdults
        body["number_of_older_adults_female"] = refugeForm.numberOfFemaleOlderAdults
        body["number_of_pregnant_women"] = refugeForm.numberOfPregnantWomen
        body["number_of_people_with_disabilities"] = refugeForm.numberOfPeopleWithDisabilities
        body["number_of_pets"] = refugeForm.numberOfPets
        body["number_of_farm_animals"] = refugeForm.numberOfFarmAnimals
        body["number_of_carp"] = refugeForm.numberOfCarps
        body["number_of_toilets"] = refugeForm.numberOfToilets
        body["number_of_washbasins"] = refugeForm.numberOfWashbasins
        body["number_of_showers"] = refugeForm.numberOfShowers
        body["number_of_tanks"] = refugeForm.numberOfTanks
        body["number_of_landfills"] = refugeForm.numberOfLandfills
        body["number_of_garbage_collection_points"] = refugeForm.numberOfGarbageCollectionPoints
        
        if let primaryContact = refugeForm.primaryContact {
            body["primary_contact"] = bodyContactForm(from: primaryContact)
        }
        
        if let secondaryContacts = refugeForm.secondaryContacts, secondaryContacts.count > 0 {
            body["secondary_contacts"] = bodyContactArrayForm(from: secondaryContacts)
        }
        
        body["census_taker"] = bodyCensusTaker(from: refugeForm.censusTaker)
        body["refuge_areas_attributes"] = bodyRefugeAreasArray(from: refugeForm.refugeAreas!)
        body["refuge_committees_attributes"] = bodyCommitteesArray(from: refugeForm.refugeCommittees!)
        body["refuge_food_managements_attributes"] = bodyRefugeFoodManagements(from: refugeForm.refugeFoodManagements!)
        body["refuge_housing_statuses_attributes"] = bodyRefugeHousingManagements(from: refugeForm.refugeHousingStatuses!)
        
        body["refuge_light_managements_attributes"] = bodyRefugeLightsManagements(from: refugeForm.refugeLightManagements!)
        
        body["refuge_services_attributes"] = bodyRefugeServicesManagements(from: refugeForm.refugeServices!)
        
        body["refuge_stool_managements_attributes"] = bodyRefugeStoolManagements(from: refugeForm.refugeStoolManagements!)
        
        body["refuge_waste_managements_attributes"] = bodyRefugeWasteManagements(from: refugeForm.refugeWasteManagements!)
        
        body["refuge_water_managements_attributes"] = bodyRefugeWaterManagements(from: refugeForm.refugeWaterManagements!)
        
       return body
    }
    private func bodyRefugeWaterManagements(from refugeWaterArray: [MultipleChoice]) -> [[String: Any]] {
        var body = [[String: Any]]()
        body = refugeWaterArray.map { bodyRefugeWater(from: $0) }
        return body
    }
    
    private func bodyRefugeWater(from refugeWater: MultipleChoice) -> [String: Any] {
        var body = [String: Any]()
        
        body["water_management_id"] = refugeWater.id
        return body
    }
    
    
    private func bodyRefugeWasteManagements(from refugeWasteArray: [MultipleChoice]) -> [[String: Any]] {
        var body = [[String: Any]]()
        body = refugeWasteArray.map { bodyRefugeWaste(from: $0) }
        return body
    }
    
    private func bodyRefugeWaste(from refugeWaste: MultipleChoice) -> [String: Any] {
        var body = [String: Any]()
        body["waste_management_id"] = refugeWaste.id
        return body
    }
    

    private func bodyRefugeStoolManagements(from refugeStoolArray: [MultipleChoice]) -> [[String: Any]] {
        var body = [[String: Any]]()
        body = refugeStoolArray.map { bodyRefugeStool(from: $0) }
        return body
    }
    
    private func bodyRefugeStool(from refugeStool: MultipleChoice) -> [String: Any] {
        var body = [String: Any]()
        body["stool_management_id"] = refugeStool.id
        return body
    }
    
    private func bodyRefugeServicesManagements(from refugeServiceArray: [MultipleChoice]) -> [[String: Any]] {
        var body = [[String: Any]]()
        body = refugeServiceArray.map { bodyRefugeServise(from: $0) }
        return body
    }
    
    private func bodyRefugeServise(from refugeService: MultipleChoice) -> [String: Any] {
        var body = [String: Any]()
        body["service_id"] = refugeService.id
        return body
    }
    
    
    private func bodyRefugeLightsManagements(from refugeLightArray: [MultipleChoice]) -> [[String: Any]] {
        var body = [[String: Any]]()
        body = refugeLightArray.map { bodyRefugeLight(from: $0) }
        return body
    }
    
    private func bodyRefugeLight(from refugeLight: MultipleChoice) -> [String: Any] {
        var body = [String: Any]()
        body["light_management_id"] = refugeLight.id
        return body
    }
    
    
    private func bodyRefugeHousingManagements(from refugeHousingArray: [MultipleChoice]) -> [[String: Any]] {
        var body = [[String: Any]]()
        body = refugeHousingArray.map {bodyRefugeHouse(from: $0)}
        return body
    }
    
    private func bodyRefugeHouse(from refugeHouse: MultipleChoice) -> [String: Any] {
        var body = [String: Any]()
        body["housing_status_id"] = refugeHouse.id
        return body
    }
    
    private func bodyRefugeFoodManagements(from refugeFoodArray: [MultipleChoice]) -> [[String: Any]] {
        var body = [[String: Any]]()
        body = refugeFoodArray.map { bodyRefugeFood(from: $0) }
        return body
    }
    
    private func bodyRefugeFood(from refugeFood: MultipleChoice) -> [String: Any] {
        var body = [String: Any]()
        body["food_management_id"] = refugeFood.id
        return body
    }

    
    private func bodyCommitteesArray(from committeesArray: [String]) -> [[String: Any]] {
        var body = [[String: Any]]()
        if committeesArray.count > 0 {
            body = committeesArray.map { bodyCommittee(from: $0) }
        } else {
            var array = [[String: Any]]()
            array.append([String: Any]())
            body = array
        }
        return body
    }
    
    private func bodyCommittee(from committeessName: String) -> [String: Any] {
        var body = [String: Any]()
        body["committee_name"] = committeessName
        return body
    }
    
    private func bodyRefugeAreasArray(from refugeAreasArray: [MultipleChoice]) -> [[String: Any]] {
        var body = [[String: Any]]()
        body = refugeAreasArray.map { bodyRefugeAreas(from: $0) }
        return body
    }
    
    private func bodyRefugeAreas(from refugeAreas: MultipleChoice) -> [String: Any] {
        var body = [String: Any]()
        body["area_id"] = refugeAreas.id
        return body
    }
    
    private func bodyCensusTaker(from censusTaker: EnumeratorUser) -> [String: Any] {
        var body = [String: Any]()
        body["dni"] = censusTaker.nationalPersonID
        body["phone"] = censusTaker.cellphone
        body["institution"] = censusTaker.institution
        return body
    }
    
    
    private func bodyContactArrayForm(from contactArray: [Contact]) -> [[String: Any]] {
        var body = [[String: Any]]()
        body = contactArray.map { bodyContactForm(from: $0)}
        return body
    }
    
    private func bodyContactForm(from contact: Contact) -> [String: Any] {
        var body = [String: Any]()
        body["first_name"] = contact.firstName
        body["last_name"] = contact.firstName
        body["phone"] = contact.phone
        body["email"] = contact.email
        return body
    }
    
    func bodySortedQuestionArray(from sortedQuestions: [SortedQuestion]) -> [[String: Any]] {
        var body = [[String: Any]]()
        body = sortedQuestions.map { bodySortedQuestion(from: $0) }
        return body
    }
    
    private func bodySortedQuestion(from sortedQuestion: SortedQuestion) -> [String: Any] {
        var body = [String: Any]()
        body["id"] = sortedQuestion.id
        body["question_type"] = sortedQuestion.questionType
        if  (sortedQuestion.subQuestions?.count)! > 0 {
            body["sub_questions"] = sortedQuestion.subQuestions.map { bodyQuestionArray(from: $0)}
        } else {
            body["answers"] = sortedQuestion.answerArray.map { bodyAnswerArray(from: $0)}

        }
        return body
    }
    
    private func bodyAnswerArray(from answers: [Answer]) -> [[String: Any]] {
        var body = [[String: Any]]()
        for answer in answers {
            if answer.selected == true && answer.value != ""  {
                 body.append(bodyAnswerWithIdAndValue(from: answer))
            } else if answer.value != "" && answer.value != nil {
                body.append(bodyAnswerWithValue(from: answer))
            } else if answer.selected == true {
                body.append(bodyAnswer(from: answer))
            }
        }
        return body
    }
    
    private func bodyAnswer(from answer: Answer) -> [String: Any] {
        var body = [String: Any]()
        body["selected_id"] = answer.id
        return body
    }
    
    private func bodyAnswerWithIdAndValue(from answer: Answer) -> [String: Any] {
        var body = [String: Any]()
        body["selected_id"] = answer.id
        body["answer_value"] = answer.value

        return body
    }
    
    private func bodyAnswerWithValue(from answer: Answer) -> [String: Any] {
        var body = [String: Any]()
        body["answer_value"] = answer.value
        return body
    }
    
    private func bodyQuestionArray(from questions: [Question]) -> [[String: Any]] {
        var body = [[String: Any]]()
        body = questions.map { bodyQuestion(from: $0) }
        return body
    }
    
    
    private func bodyQuestion(from question: Question) -> [String: Any] {
        var body = [String: Any]()
        body["id"] = question.id
        body["question_type"] = question.questionType
        body["answers"] = question.answerArray.map { bodyAnswerArray(from: $0)}
        
        return body
    }

}
