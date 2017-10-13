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
import Mapper

enum RefugeType: OptionItem {
    case openTends
    case school
    case church
    case other
    
    static let options: [RefugeType] = [.openTends, .school, .church, .other]
    
    var displayValue: String {
        switch self {
        case .openTends:
            return "Carpas en cambo abierto"
        case .school:
            return "Colegio"
        case .church:
            return "Iglesia"
        case .other:
            return "Otro"
        }
    }
    
    var value: String {
        switch self {
        case .openTends:
            return "open_tents"
        case .school:
            return "school"
        case .church:
            return "church"
        case .other:
            return "other"
        }
    }
}

enum InstitutionInChargeType: OptionItem {
    case centralGovernment
    case regionalGovernment
    case churchInstitution
    case municipality
    case communityOrganization
    case nonGovernmentalOrganization
    case other
    
    static let options: [InstitutionInChargeType] = [.centralGovernment, .regionalGovernment, .churchInstitution, .municipality, .communityOrganization, .nonGovernmentalOrganization, .other]
    
    var displayValue: String {
        switch self {
        case .centralGovernment:
            return "Gobierno Central"
        case .regionalGovernment:
            return "Gobierno Regional"
        case .churchInstitution:
            return "Iglesia"
        case .municipality:
            return "Municipalidad"
        case .communityOrganization:
            return "Organización Comunal"
        case .nonGovernmentalOrganization:
            return "Organización no Gubernamental"
        case .other:
            return "Otro"
        }
    }
    
    var value: String {
        switch self {
        case .centralGovernment:
            return "central_government"
        case .regionalGovernment:
            return "regional_government"
        case .churchInstitution:
            return "church_institution"
        case .municipality:
            return "municipality"
        case .communityOrganization:
            return "community_organization"
        case .nonGovernmentalOrganization:
            return "non_governmental_organization"
        case .other:
            return "other_institution"
        }
    }
    
}

enum EmergencyType: OptionItem {
    case earthquake
    case coldFrosty
    case landslideOverflowRiver
    case healthEmergency
    case fire
    
    static let options: [EmergencyType] = [.earthquake, .coldFrosty, .landslideOverflowRiver, .healthEmergency, .fire]
    
    var displayValue: String {
        switch self {
        case .earthquake:
            return "Terremoto"
        case .coldFrosty:
            return "Friaje/helada"
        case .landslideOverflowRiver:
            return "Huayco/desborde de río"
        case .healthEmergency:
            return "Emergencia sanitaria"
        case .fire:
            return "Incendio"
        }
    }
    
    var value: String {
        switch self {
        case .earthquake:
            return "earthquake"
        case .coldFrosty:
            return "cold_frosty"
        case .landslideOverflowRiver:
            return "landslide_overflow_river"
        case .healthEmergency:
            return "health_emergency"
        case .fire:
            return "fire"
        }
    }
}

enum PropertyType: OptionItem {
    case `private`
    case `public`
    case highways
    
     static let options: [PropertyType] = [.private, .public, .highways]
    
    var displayValue: String {
        switch self {
        case .private:
            return "Propiedad Privada"
        case .public:
            return "Propiedad Pública"
        case .highways:
            return "Vía Pública"
        }
    }
    
    var value: String {
        switch self {
        case .private:
            return "private_property"
        case .public:
            return "public_property"
        case .highways:
            return "highways"
        }
    }
}

enum AccessibilityType: OptionItem {
    case onFoot
    case only4x4
    case vehicular
    
    static let options: [AccessibilityType] = [.onFoot, .only4x4, .vehicular]
    
    var displayValue: String {
        switch self {
        case .onFoot:
            return "A pie"
        case .only4x4:
            return "Solo 4x4"
        case .vehicular:
            return "Vehicular"
        }
    }
    
    var value: String {
        switch self {
        case .onFoot:
            return "on_foot"
        case .only4x4:
            return "only_4x4"
        case .vehicular:
            return "vehicular"
        }
    }
}

enum VictimsProvenanceType: OptionItem {
    case sameCommunity
    case differentCommunities
    
    static let options: [VictimsProvenanceType] = [.sameCommunity, .differentCommunities]
    
    var displayValue: String {
        switch self {
        case .sameCommunity:
            return "De una misma comunidad"
        case .differentCommunities:
            return "De diferentes comunidades"
        }
    }
    
    var value: String {
        switch self {
        case .sameCommunity:
            return "same_community"
        case .differentCommunities:
            return "different_communities"
        }
    }
}

enum FloorType: OptionItem {
    case asphalted
    case unpaved
    
    static let options: [FloorType] = [.asphalted, .unpaved]

    
    var displayValue: String {
        switch self {
        case .asphalted:
            return "Asfaltado"
        case .unpaved:
            return "No asfaltado"
        }
    }
    
    var value: String {
        switch self {
        case .asphalted:
            return "asphalted"
        case .unpaved:
            return "unpaved"
        }
    }
    
}

enum RoofType: OptionItem {
    case outdoors
    case roofing
    
    static let options: [RoofType] = [.outdoors, .roofing]

    var displayValue: String {
        switch self {
        case .outdoors:
            return "Al aire libre"
        case .roofing:
            return "Techado"
        }
    }
    
    var value: String {
        switch self {
        case .outdoors:
            return "outdoors"
        case .roofing:
            return "roofing"
        }
    }
    
}


class RefugeForm {
    var name: String
    var latitude : String
    var longitude: String
    var address: String
    var city: String
    var countryISO: String
    var refugeType: RefugeType?
    var institutionInCharge: InstitutionInChargeType?
    var emergencyType: EmergencyType
    var propertyType: PropertyType?
    var accessibility: AccessibilityType?
    var victimsProvenance: VictimsProvenanceType?
    var floorType: FloorType?
    var roofType: RoofType?
    var numberOfFamilies: Int = 0
    var numberOfMaleChildrensUnder3: Int  = 0
    var numberOfFemaleChildrensUnder3: Int = 0
    var numberOfMalePeopleLessThanOrEqualsTo18: Int = 0
    var numberOfFemalePeopleLessThanOrEqualsTo18: Int  = 0
    var numberOfMalePeopleOlderThan18: Int = 0
    var numberOfFemalePeopleOlderThan18: Int  = 0
    var numberOfMaleOlderAdults: Int  = 0
    var numberOfFemaleOlderAdults: Int = 0
    var numberOfPregnantWomen: Int = 0
    var numberOfPeopleWithDisabilities: Int = 0
    var numberOfPets: Int = 0
    var numberOfFarmAnimals: Int = 0
    var numberOfCarps: Int = 0
    var numberOfToilets: Int = 0
    var numberOfWashbasins: Int = 0
    var numberOfShowers: Int = 0
    var numberOfTanks: Int = 0
    var numberOfLandfills: Int = 0
    var numberOfGarbageCollectionPoints: Int = 0
    var refugeAreas: [MultipleChoice]?
    var refugeCommittees: [String]?
    var refugeFoodManagements: [MultipleChoice]?
    var refugeHousingStatuses: [MultipleChoice]?
    var refugeLightManagements: [MultipleChoice]?
    var refugeServices: [MultipleChoice]?
    var refugeStoolManagements: [MultipleChoice]?
    var refugeWasteManagements: [MultipleChoice]?
    var refugeWaterManagements: [MultipleChoice]?
    var primaryContact: Contact?
    var secondaryContacts: [Contact]?
    var censusTaker: EnumeratorUser {
        return EnumeratorUserManager.sharedInstance.currentEnumeratorUser!
    }
    
    init(name: String, latitude: String, longitude: String, address: String, city: String, countryISO: String, emergencyType: EmergencyType) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.city = city
        self.countryISO = countryISO
        self.emergencyType = emergencyType
    }
    
    
}
