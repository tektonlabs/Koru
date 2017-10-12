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

package com.tektonlabs.android.refugeapp.data.network.models.create_shelter;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.List;

public class Shelter {
    @SerializedName("name")
    @Expose
    private String name;
    @SerializedName("latitude")
    @Expose
    private String latitude;
    @SerializedName("longitude")
    @Expose
    private String longitude;
    @SerializedName("address")
    @Expose
    private String address;
    @SerializedName("city")
    @Expose
    private String city;
    @SerializedName("country_iso")
    @Expose
    private String countryId;
    @SerializedName("refuge_type")
    @Expose
    private String refugeType;
    @SerializedName("institution_in_charge")
    @Expose
    private String institutionInCharge;
    @SerializedName("emergency_type")
    @Expose
    private String emergencyType;
    @SerializedName("property_type")
    @Expose
    private String propertyType;
    @SerializedName("accessibility")
    @Expose
    private String accessibility;
    @SerializedName("victims_provenance")
    @Expose
    private String victimsProvenance;
    @SerializedName("floor_type")
    @Expose
    private String floorType;
    @SerializedName("roof_type")
    @Expose
    private String roofType;
    @SerializedName("number_of_families")
    @Expose
    private String numberOfFamilies;
    @SerializedName("number_of_pregnant_women")
    @Expose
    private String numberOfPregnantWomen;
    @SerializedName("number_of_children_under_3_male")
    @Expose
    private String number_of_children_under_3_male;
    @SerializedName("number_of_children_under_3_female")
    @Expose
    private String number_of_children_under_3_female;
    @SerializedName("number_of_people_less_than_or_equals_to_18_male")
    @Expose
    private String number_of_people_less_than_or_equals_to_18_male;
    @SerializedName("number_of_people_less_than_or_equals_to_18_female")
    @Expose
    private String number_of_people_less_than_or_equals_to_18_female;
    @SerializedName("number_of_people_older_than_18_male")
    @Expose
    private String number_of_people_older_than_18_male;
    @SerializedName("number_of_people_older_than_18_female")
    @Expose
    private String number_of_people_older_than_18_female;
    @SerializedName("number_of_older_adults_male")
    @Expose
    private String number_of_older_adults_male;
    @SerializedName("number_of_older_adults_female")
    @Expose
    private String number_of_older_adults_female;
    @SerializedName("number_of_people_with_disabilities")
    @Expose
    private String numberOfPeopleWithDisabilities;
    @SerializedName("number_of_pets")
    @Expose
    private String numberOfPets;
    @SerializedName("number_of_farm_animals")
    @Expose
    private String numberOfFarmAnimals;
    @SerializedName("number_of_carp")
    @Expose
    private String numberOfCarp;
    @SerializedName("number_of_toilets")
    @Expose
    private String numberOfToilets;
    @SerializedName("number_of_washbasins")
    @Expose
    private String numberOfWashbasins;
    @SerializedName("number_of_showers")
    @Expose
    private String numberOfShowers;
    @SerializedName("number_of_tanks")
    @Expose
    private String numberOfTanks;
    @SerializedName("number_of_landfills")
    @Expose
    private String numberOfLandfills;
    @SerializedName("number_of_garbage_collection_points")
    @Expose
    private String numberOfGarbageCollectionPoints;
    @SerializedName("refuge_areas_attributes")
    @Expose
    private List<RefugeAreasAttribute> refugeAreasAttributes = null;
    @SerializedName("refuge_committees_attributes")
    @Expose
    private List<RefugeCommitteesAttribute> refugeCommitteesAttributes = null;
    @SerializedName("refuge_food_managements_attributes")
    @Expose
    private List<RefugeFoodManagementsAttribute> refugeFoodManagementsAttributes = null;
    @SerializedName("refuge_housing_statuses_attributes")
    @Expose
    private List<RefugeHousingStatusesAttribute> refugeHousingStatusesAttributes = null;
    @SerializedName("refuge_light_managements_attributes")
    @Expose
    private List<RefugeLightManagementsAttribute> refugeLightManagementsAttributes = null;
    @SerializedName("refuge_services_attributes")
    @Expose
    private List<RefugeServicesAttribute> refugeServicesAttributes = null;
    @SerializedName("refuge_stool_managements_attributes")
    @Expose
    private List<RefugeStoolManagementsAttribute> refugeStoolManagementsAttributes = null;
    @SerializedName("refuge_waste_managements_attributes")
    @Expose
    private List<RefugeWasteManagementsAttribute> refugeWasteManagementsAttributes = null;
    @SerializedName("refuge_water_managements_attributes")
    @Expose
    private List<RefugeWaterManagementsAttribute> refugeWaterManagementsAttributes = null;
    @SerializedName("primary_contact")
    @Expose
    private ShelterContact shelterContact;
    @SerializedName("secondary_contacts")
    @Expose
    private List<ShelterContact> secondaryShelterContacts = null;
    @SerializedName("census_taker")
    @Expose
    private CensusTaker censusTaker = null;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLatitude() {
        return latitude;
    }

    public void setLatitude(String latitude) {
        this.latitude = latitude;
    }

    public String getLongitude() {
        return longitude;
    }

    public void setLongitude(String longitude) {
        this.longitude = longitude;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getCountryId() {
        return countryId;
    }

    public void setCountryId(String countryId) {
        this.countryId = countryId;
    }

    public String getRefugeType() {
        return refugeType;
    }

    public void setRefugeType(String refugeType) {
        this.refugeType = refugeType;
    }

    public String getInstitutionInCharge() {
        return institutionInCharge;
    }

    public void setInstitutionInCharge(String institutionInCharge) {
        this.institutionInCharge = institutionInCharge;
    }

    public String getEmergencyType() {
        return emergencyType;
    }

    public void setEmergencyType(String emergencyType) {
        this.emergencyType = emergencyType;
    }

    public String getPropertyType() {
        return propertyType;
    }

    public void setPropertyType(String propertyType) {
        this.propertyType = propertyType;
    }

    public String getAccessibility() {
        return accessibility;
    }

    public void setAccessibility(String accessibility) {
        this.accessibility = accessibility;
    }

    public String getVictimsProvenance() {
        return victimsProvenance;
    }

    public void setVictimsProvenance(String victimsProvenance) {
        this.victimsProvenance = victimsProvenance;
    }

    public String getFloorType() {
        return floorType;
    }

    public void setFloorType(String floorType) {
        this.floorType = floorType;
    }

    public String getRoofType() {
        return roofType;
    }

    public void setRoofType(String roofType) {
        this.roofType = roofType;
    }

    public String getNumberOfFamilies() {
        return numberOfFamilies;
    }

    public void setNumberOfFamilies(String numberOfFamilies) {
        this.numberOfFamilies = numberOfFamilies;
    }

    public String getNumberOfPregnantWomen() {
        return numberOfPregnantWomen;
    }

    public void setNumberOfPregnantWomen(String numberOfPregnantWomen) {
        this.numberOfPregnantWomen = numberOfPregnantWomen;
    }

    public String getNumberOfPeopleWithDisabilities() {
        return numberOfPeopleWithDisabilities;
    }

    public void setNumberOfPeopleWithDisabilities(String numberOfPeopleWithDisabilities) {
        this.numberOfPeopleWithDisabilities = numberOfPeopleWithDisabilities;
    }

    public String getNumberOfPets() {
        return numberOfPets;
    }

    public void setNumberOfPets(String numberOfPets) {
        this.numberOfPets = numberOfPets;
    }

    public String getNumberOfFarmAnimals() {
        return numberOfFarmAnimals;
    }

    public void setNumberOfFarmAnimals(String numberOfFarmAnimals) {
        this.numberOfFarmAnimals = numberOfFarmAnimals;
    }

    public String getNumberOfCarp() {
        return numberOfCarp;
    }

    public void setNumberOfCarp(String numberOfCarp) {
        this.numberOfCarp = numberOfCarp;
    }

    public String getNumberOfToilets() {
        return numberOfToilets;
    }

    public void setNumberOfToilets(String numberOfToilets) {
        this.numberOfToilets = numberOfToilets;
    }

    public String getNumberOfWashbasins() {
        return numberOfWashbasins;
    }

    public void setNumberOfWashbasins(String numberOfWashbasins) {
        this.numberOfWashbasins = numberOfWashbasins;
    }

    public String getNumberOfShowers() {
        return numberOfShowers;
    }

    public void setNumberOfShowers(String numberOfShowers) {
        this.numberOfShowers = numberOfShowers;
    }

    public String getNumberOfTanks() {
        return numberOfTanks;
    }

    public void setNumberOfTanks(String numberOfTanks) {
        this.numberOfTanks = numberOfTanks;
    }

    public String getNumberOfLandfills() {
        return numberOfLandfills;
    }

    public void setNumberOfLandfills(String numberOfLandfills) {
        this.numberOfLandfills = numberOfLandfills;
    }

    public String getNumberOfGarbageCollectionPoints() {
        return numberOfGarbageCollectionPoints;
    }

    public void setNumberOfGarbageCollectionPoints(String numberOfGarbageCollectionPoints) {
        this.numberOfGarbageCollectionPoints = numberOfGarbageCollectionPoints;
    }

    public List<RefugeAreasAttribute> getRefugeAreasAttributes() {
        return refugeAreasAttributes;
    }

    public void setRefugeAreasAttributes(List<RefugeAreasAttribute> refugeAreasAttributes) {
        this.refugeAreasAttributes = refugeAreasAttributes;
    }

    public List<RefugeCommitteesAttribute> getRefugeCommitteesAttributes() {
        return refugeCommitteesAttributes;
    }

    public void setRefugeCommitteesAttributes(List<RefugeCommitteesAttribute> refugeCommitteesAttributes) {
        this.refugeCommitteesAttributes = refugeCommitteesAttributes;
    }

    public List<RefugeFoodManagementsAttribute> getRefugeFoodManagementsAttributes() {
        return refugeFoodManagementsAttributes;
    }

    public void setRefugeFoodManagementsAttributes(List<RefugeFoodManagementsAttribute> refugeFoodManagementsAttributes) {
        this.refugeFoodManagementsAttributes = refugeFoodManagementsAttributes;
    }

    public List<RefugeHousingStatusesAttribute> getRefugeHousingStatusesAttributes() {
        return refugeHousingStatusesAttributes;
    }

    public void setRefugeHousingStatusesAttributes(List<RefugeHousingStatusesAttribute> refugeHousingStatusesAttributes) {
        this.refugeHousingStatusesAttributes = refugeHousingStatusesAttributes;
    }

    public List<RefugeLightManagementsAttribute> getRefugeLightManagementsAttributes() {
        return refugeLightManagementsAttributes;
    }

    public void setRefugeLightManagementsAttributes(List<RefugeLightManagementsAttribute> refugeLightManagementsAttributes) {
        this.refugeLightManagementsAttributes = refugeLightManagementsAttributes;
    }

    public List<RefugeServicesAttribute> getRefugeServicesAttributes() {
        return refugeServicesAttributes;
    }

    public void setRefugeServicesAttributes(List<RefugeServicesAttribute> refugeServicesAttributes) {
        this.refugeServicesAttributes = refugeServicesAttributes;
    }

    public List<RefugeStoolManagementsAttribute> getRefugeStoolManagementsAttributes() {
        return refugeStoolManagementsAttributes;
    }

    public void setRefugeStoolManagementsAttributes(List<RefugeStoolManagementsAttribute> refugeStoolManagementsAttributes) {
        this.refugeStoolManagementsAttributes = refugeStoolManagementsAttributes;
    }

    public List<RefugeWasteManagementsAttribute> getRefugeWasteManagementsAttributes() {
        return refugeWasteManagementsAttributes;
    }

    public void setRefugeWasteManagementsAttributes(List<RefugeWasteManagementsAttribute> refugeWasteManagementsAttributes) {
        this.refugeWasteManagementsAttributes = refugeWasteManagementsAttributes;
    }

    public List<RefugeWaterManagementsAttribute> getRefugeWaterManagementsAttributes() {
        return refugeWaterManagementsAttributes;
    }

    public void setRefugeWaterManagementsAttributes(List<RefugeWaterManagementsAttribute> refugeWaterManagementsAttributes) {
        this.refugeWaterManagementsAttributes = refugeWaterManagementsAttributes;
    }

    public ShelterContact getShelterContact() {
        return shelterContact;
    }

    public void setShelterContact(ShelterContact shelterContact) {
        this.shelterContact = shelterContact;
    }

    public List<ShelterContact> getSecondaryShelterContacts() {
        return secondaryShelterContacts;
    }

    public void setSecondaryShelterContacts(List<ShelterContact> secondaryShelterContacts) {
        this.secondaryShelterContacts = secondaryShelterContacts;
    }

    public CensusTaker getCensusTaker() {
        return censusTaker;
    }

    public void setCensusTaker(CensusTaker censusTaker) {
        this.censusTaker = censusTaker;
    }

    public String getNumber_of_children_under_3_male() {
        return number_of_children_under_3_male;
    }

    public void setNumber_of_children_under_3_male(String number_of_children_under_3_male) {
        this.number_of_children_under_3_male = number_of_children_under_3_male;
    }

    public String getNumber_of_children_under_3_female() {
        return number_of_children_under_3_female;
    }

    public void setNumber_of_children_under_3_female(String number_of_children_under_3_female) {
        this.number_of_children_under_3_female = number_of_children_under_3_female;
    }

    public String getNumber_of_people_less_than_or_equals_to_18_male() {
        return number_of_people_less_than_or_equals_to_18_male;
    }

    public void setNumber_of_people_less_than_or_equals_to_18_male(String number_of_people_less_than_or_equals_to_18_male) {
        this.number_of_people_less_than_or_equals_to_18_male = number_of_people_less_than_or_equals_to_18_male;
    }

    public String getNumber_of_people_less_than_or_equals_to_18_female() {
        return number_of_people_less_than_or_equals_to_18_female;
    }

    public void setNumber_of_people_less_than_or_equals_to_18_female(String number_of_people_less_than_or_equals_to_18_female) {
        this.number_of_people_less_than_or_equals_to_18_female = number_of_people_less_than_or_equals_to_18_female;
    }

    public String getNumber_of_people_older_than_18_male() {
        return number_of_people_older_than_18_male;
    }

    public void setNumber_of_people_older_than_18_male(String number_of_people_older_than_18_male) {
        this.number_of_people_older_than_18_male = number_of_people_older_than_18_male;
    }

    public String getNumber_of_people_older_than_18_female() {
        return number_of_people_older_than_18_female;
    }

    public void setNumber_of_people_older_than_18_female(String number_of_people_older_than_18_female) {
        this.number_of_people_older_than_18_female = number_of_people_older_than_18_female;
    }

    public String getNumber_of_older_adults_male() {
        return number_of_older_adults_male;
    }

    public void setNumber_of_older_adults_male(String number_of_older_adults_male) {
        this.number_of_older_adults_male = number_of_older_adults_male;
    }

    public String getNumber_of_older_adults_female() {
        return number_of_older_adults_female;
    }

    public void setNumber_of_older_adults_female(String number_of_older_adults_female) {
        this.number_of_older_adults_female = number_of_older_adults_female;
    }
}
