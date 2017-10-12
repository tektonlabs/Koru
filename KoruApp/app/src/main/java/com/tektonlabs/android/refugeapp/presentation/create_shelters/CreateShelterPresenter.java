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


package com.tektonlabs.android.refugeapp.presentation.create_shelters;

import android.text.TextUtils;

import com.tektonlabs.android.refugeapp.data.network.models.create_shelter.CensusTaker;
import com.tektonlabs.android.refugeapp.data.network.models.create_shelter.RefugeAreasAttribute;
import com.tektonlabs.android.refugeapp.data.network.models.create_shelter.RefugeCommitteesAttribute;
import com.tektonlabs.android.refugeapp.data.network.models.create_shelter.RefugeFoodManagementsAttribute;
import com.tektonlabs.android.refugeapp.data.network.models.create_shelter.RefugeHousingStatusesAttribute;
import com.tektonlabs.android.refugeapp.data.network.models.create_shelter.RefugeLightManagementsAttribute;
import com.tektonlabs.android.refugeapp.data.network.models.create_shelter.RefugeServicesAttribute;
import com.tektonlabs.android.refugeapp.data.network.models.create_shelter.RefugeStoolManagementsAttribute;
import com.tektonlabs.android.refugeapp.data.network.models.create_shelter.RefugeWasteManagementsAttribute;
import com.tektonlabs.android.refugeapp.data.network.models.create_shelter.RefugeWaterManagementsAttribute;
import com.tektonlabs.android.refugeapp.data.network.models.create_shelter.Shelter;
import com.tektonlabs.android.refugeapp.data.network.models.create_shelter.ShelterContact;
import com.tektonlabs.android.refugeapp.data.usecase.CreateShelter;
import com.tektonlabs.android.refugeapp.data.usecase.GetAutocompleteServices;
import com.tektonlabs.android.refugeapp.data.usecase.callbacks.AutocompleteServicesUseCaseCallback;
import com.tektonlabs.android.refugeapp.data.usecase.callbacks.CreateShelterUseCase;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.interfaces.BaseStepView;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.interfaces.CreateShelterViewContract;
import com.tektonlabs.android.refugeapp.utils.Utils;

import java.util.ArrayList;
import java.util.List;

public class CreateShelterPresenter implements CreateShelterViewContract.UserActionListener, CreateShelterUseCase.CreateShelterUseCaseCallback, AutocompleteServicesViewDataResponse {

    private BaseStepView baseStepView;
    private CreateShelterViewContract.View view;

    private CreateShelter createShelter;
    private GetAutocompleteServices getAutocompleteServices;

    private Shelter shelter = new Shelter();


    public void setBaseStepView(BaseStepView baseStepView) {
        this.baseStepView = baseStepView;
    }

    public CreateShelterPresenter(BaseStepView baseStepView, CreateShelterViewContract.View view) {
        this.baseStepView = baseStepView;
        this.view = view;
        createShelter = new CreateShelter(this);
        getAutocompleteServices = new GetAutocompleteServices(this);
    }


    @Override
    public void getServices(String query) {
        getAutocompleteServices.getServices(query);
    }

    @Override
    public boolean validateFirstStep(String name, String shelterType, String organization, String emergencyType, LocalAddress address, String dni,
                                     String phone, String institution) {
        boolean cancel = false;
        CreateShelterViewContract.FirstStepView firstStepView = (CreateShelterViewContract.FirstStepView) baseStepView;
        if (TextUtils.isEmpty(name)) {
            cancel = true;
            firstStepView.nameTextEmpty();
        }
//        if (TextUtils.isEmpty(shelterType)) {
//            cancel = true;
//            firstStepView.shelterTypeEmpty();
//        }
//        if (TextUtils.isEmpty(organization)) {
//            cancel = true;
//            firstStepView.organizationEmpty();
//        }
        if (TextUtils.isEmpty(emergencyType)) {
            cancel = true;
            firstStepView.emergencyTypeEmpty();
        }

        if (address != null && TextUtils.isEmpty(address.getAddress())) {
            cancel = true;
            firstStepView.addressEmpty();
        }

        if (address == null) {
            cancel = true;
            firstStepView.addressEmpty();
        }
        if (!cancel) {
            shelter.setName(name);
            shelter.setRefugeType(Utils.shelterTypeToSend(shelterType));
            shelter.setInstitutionInCharge(Utils.organizationToSend(organization));
            shelter.setEmergencyType(Utils.emergencyToSend(emergencyType));
            shelter.setAddress(address.getAddress());
            shelter.setLatitude(String.valueOf(address.getLatitude()));
            shelter.setLongitude(String.valueOf(address.getLongitud()));
            shelter.setCity((address.getCity() != null && address.getCity().isEmpty()) ? "" : address.getCity());
            shelter.setCountryId(address.getCountry()
            );

            CensusTaker censusTaker = new CensusTaker();
            censusTaker.setDni(dni);
            censusTaker.setPhone(phone);
            censusTaker.setInstitution(institution);

            shelter.setCensusTaker(censusTaker);
        }

        return cancel;
    }

    @Override
    public boolean validateSecondStep(String property_type, String accessibility, String victims) {
        boolean cancel = false;
        CreateShelterViewContract.SecondStepView secondStepView = (CreateShelterViewContract.SecondStepView) baseStepView;

//        if (TextUtils.isEmpty(property_type)) {
//            cancel = true;
//            secondStepView.propertyEmpty();
//        }
//        if (TextUtils.isEmpty(accessibility)) {
//            cancel = true;
//            secondStepView.accessibilityEmpty();
//        }
//        if (TextUtils.isEmpty(victims)) {
//            cancel = true;
//            secondStepView.victimsEmpty();
//        }

        if (!cancel) {
            shelter.setPropertyType(Utils.propertyToSend(property_type));
            shelter.setAccessibility(Utils.accessibilityToSend(accessibility));
            shelter.setVictimsProvenance(Utils.victimcsToSend(victims));
        }

        return cancel;
    }

    @Override
    public boolean validateThirdStep(Contact contact, ArrayList<Contact> secondaries) {
        boolean cancel = false;
        CreateShelterViewContract.ThirdStepView thirdStepView = (CreateShelterViewContract.ThirdStepView) baseStepView;

//        if (contact == null) {
//            cancel = true;
//            thirdStepView.primaryContactEmpty();
//        }

        if (!cancel && contact!=null) {
            ShelterContact shelterContact = new ShelterContact();
            shelterContact.setFirstName(contact.getName());
            shelterContact.setEmail(contact.getEmail());
            shelterContact.setPhone(contact.getPhone());
            shelterContact.setLastName(contact.getName());
            shelter.setShelterContact(shelterContact);
            List<ShelterContact> secondaryContacts = new ArrayList<>();
            for (Contact c : secondaries) {
                ShelterContact secondaryContact = new ShelterContact();
                secondaryContact.setFirstName(c.getName());
                secondaryContact.setPhone(c.getPhone());
                secondaryContact.setEmail(c.getEmail());
                secondaryContact.setLastName(c.getName());
                secondaryContacts.add(secondaryContact);
            }
            shelter.setSecondaryShelterContacts(secondaryContacts);
        }

        return cancel;
    }

    @Override
    public boolean validateFifthStep(String floor, String roof) {
        CreateShelterViewContract.FifthStepView fifhStepView = (CreateShelterViewContract.FifthStepView) baseStepView;

        boolean cancel = false;

//        if (TextUtils.isEmpty(floor)) {
//            cancel = true;
//            fifhStepView.floorEmpty();
//        }
//        if (TextUtils.isEmpty(roof)) {
//            cancel = true;
//            fifhStepView.roofEmpty();
//        }

        if (!cancel) {
            shelter.setFloorType(Utils.floorToSend(floor));
            shelter.setRoofType(Utils.roofToSend(roof));

        }

        return cancel;
    }

    @Override
    public void optionalFieldsSecondStep(ArrayList<String> committeePresence) {
        shelter.setRefugeCommitteesAttributes(setShelterComittees(committeePresence));
    }

    @Override
    public void optionalFieldsFourthStep(String family, String numberPregnant,
                                         String numberHandicapped, String numberPets,
                                         String numberFarmAnimals, ArrayList<String> typeOfService,
                                         ArrayList<String> housesStatus, String maleChildren, String femaleChildren,
                                         String maleUnder18, String femaleUnder18, String maleAbove18,
                                         String femaleAbove18, String maleElderly, String femaleElderly) {
        shelter.setNumberOfFamilies(family.isEmpty() ? "0" : family);
        shelter.setNumberOfPregnantWomen(numberPregnant.isEmpty() ? "0" : numberPregnant);
        shelter.setNumberOfPeopleWithDisabilities(numberHandicapped.isEmpty() ? "0" : numberHandicapped);
        shelter.setNumberOfPets(numberPets.isEmpty() ? "0" : numberPets);
        shelter.setNumberOfFarmAnimals(numberFarmAnimals.isEmpty() ? "0" : numberFarmAnimals);
        shelter.setNumber_of_children_under_3_male(maleChildren.isEmpty() ? "0" : maleChildren);
        shelter.setNumber_of_children_under_3_female(femaleChildren.isEmpty() ? "0" : femaleChildren);
        shelter.setNumber_of_people_less_than_or_equals_to_18_male(maleUnder18.isEmpty() ? "0" : maleUnder18);
        shelter.setNumber_of_people_less_than_or_equals_to_18_female(femaleUnder18.isEmpty() ? "0" : femaleUnder18);
        shelter.setNumber_of_people_older_than_18_male(maleAbove18.isEmpty() ? "0" : maleAbove18);
        shelter.setNumber_of_people_older_than_18_female(femaleAbove18.isEmpty() ? "0" : femaleAbove18);
        shelter.setNumber_of_older_adults_male(maleElderly.isEmpty() ? "0" : maleElderly);
        shelter.setNumber_of_older_adults_female(femaleElderly.isEmpty() ? "0" : femaleElderly);
        shelter.setRefugeServicesAttributes(setServiceType(typeOfService));
        shelter.setRefugeHousingStatusesAttributes(setShelterHOusesStatus(housesStatus));
    }

    @Override
    public void optionalFieldsFifthStep(String numberOfToilet, String numberOfTents, String numberOfSinks, String numberOfShowers, String numberOfTanks, String numberOfTrashCans, String numberOfTrashContainer, ArrayList<String> presenceOf) {
        shelter.setNumberOfToilets(numberOfToilet.isEmpty() ? "0" : numberOfToilet);
        shelter.setNumberOfCarp(numberOfTents.isEmpty() ? "0" : numberOfTents);
        shelter.setNumberOfWashbasins(numberOfSinks.isEmpty() ? "0" : numberOfSinks);
        shelter.setNumberOfShowers(numberOfShowers.isEmpty() ? "0" : numberOfShowers);
        shelter.setNumberOfTanks(numberOfTanks.isEmpty() ? "0" : numberOfTanks);
        shelter.setNumberOfLandfills(numberOfTrashContainer.isEmpty() ? "0" : numberOfTrashContainer);
        shelter.setNumberOfGarbageCollectionPoints(numberOfTrashCans.isEmpty() ? "0" : numberOfTrashCans);
        shelter.setRefugeAreasAttributes(setShelterAreas(presenceOf));
    }

    @Override
    public void optionalFieldsSixthStep(ArrayList<String> light, ArrayList<String> water, ArrayList<String> fecesHandling, ArrayList<String> wasteManagement, ArrayList<String> foodAndBeverages) {
        shelter.setRefugeLightManagementsAttributes(setShelterLight(light));
        shelter.setRefugeWaterManagementsAttributes(setShelterWater(water));
        shelter.setRefugeStoolManagementsAttributes(setShelterStool(fecesHandling));
        shelter.setRefugeWasteManagementsAttributes(setShelterWaste(wasteManagement));
        shelter.setRefugeFoodManagementsAttributes(setShelterFood(foodAndBeverages));
    }

    private List<RefugeCommitteesAttribute> setShelterComittees(ArrayList<String> committeePresence) {
        List<RefugeCommitteesAttribute> comittees = new ArrayList<>();
        for (String s : committeePresence) {
            RefugeCommitteesAttribute refugeComittee = new RefugeCommitteesAttribute();
            refugeComittee.setCommitteeId(s);
            comittees.add(refugeComittee);
        }
        return comittees;
    }

    private List<RefugeHousingStatusesAttribute> setShelterHOusesStatus(ArrayList<String> housesStatus) {
        List<RefugeHousingStatusesAttribute> housingStatusesAttributes = new ArrayList<>();
        for (String s : housesStatus) {
            RefugeHousingStatusesAttribute refugeHousingStatusesAttribute = new RefugeHousingStatusesAttribute();
            refugeHousingStatusesAttribute.setHousingStatusId(s);
            housingStatusesAttributes.add(refugeHousingStatusesAttribute);
        }
        return housingStatusesAttributes;
    }

    private List<RefugeServicesAttribute> setServiceType(ArrayList<String> typeOfService) {
        List<RefugeServicesAttribute> serviceTypes = new ArrayList<>();
        for (String s : typeOfService) {
            RefugeServicesAttribute refugeServicesAttribute = new RefugeServicesAttribute();
            refugeServicesAttribute.setServiceId(s);
            serviceTypes.add(refugeServicesAttribute);
        }
        return serviceTypes;
    }

    private List<RefugeLightManagementsAttribute> setShelterLight(ArrayList<String> light) {
        List<RefugeLightManagementsAttribute> shelterLight = new ArrayList<>();
        for (String s : light) {
            RefugeLightManagementsAttribute refugeLightManagementsAttribute = new RefugeLightManagementsAttribute();
            refugeLightManagementsAttribute.setLightManagementId(s);
            shelterLight.add(refugeLightManagementsAttribute);
        }
        return shelterLight;
    }

    private List<RefugeWaterManagementsAttribute> setShelterWater(ArrayList<String> water) {
        List<RefugeWaterManagementsAttribute> shelterWater = new ArrayList<>();
        for (String s : water) {
            RefugeWaterManagementsAttribute refugeWaterManagementsAttribute = new RefugeWaterManagementsAttribute();
            refugeWaterManagementsAttribute.setWaterManagementId(s);
            shelterWater.add(refugeWaterManagementsAttribute);
        }
        return shelterWater;
    }

    private List<RefugeStoolManagementsAttribute> setShelterStool(ArrayList<String> fecesHandling) {
        List<RefugeStoolManagementsAttribute> shelterFeces = new ArrayList<>();
        for (String s : fecesHandling) {
            RefugeStoolManagementsAttribute refugeStoolManagementsAttribute = new RefugeStoolManagementsAttribute();
            refugeStoolManagementsAttribute.setStoolManagementId(s);
            shelterFeces.add(refugeStoolManagementsAttribute);
        }
        return shelterFeces;
    }

    private List<RefugeWasteManagementsAttribute> setShelterWaste(ArrayList<String> wasteManagement) {
        List<RefugeWasteManagementsAttribute> shelterWaste = new ArrayList<>();
        for (String s : wasteManagement) {
            RefugeWasteManagementsAttribute refugeWasteManagementsAttribute = new RefugeWasteManagementsAttribute();
            refugeWasteManagementsAttribute.setWasteManagementId(s);
            shelterWaste.add(refugeWasteManagementsAttribute);
        }
        return shelterWaste;
    }

    private List<RefugeFoodManagementsAttribute> setShelterFood(ArrayList<String> foodAndBeverages) {
        List<RefugeFoodManagementsAttribute> shelterFood = new ArrayList<>();
        for (String s : foodAndBeverages) {
            RefugeFoodManagementsAttribute refugeFoodManagementsAttribute = new RefugeFoodManagementsAttribute();
            refugeFoodManagementsAttribute.setFoodManagementId(s);
            shelterFood.add(refugeFoodManagementsAttribute);
        }
        return shelterFood;
    }

    private List<RefugeAreasAttribute> setShelterAreas(ArrayList<String> presenceOf) {
        List<RefugeAreasAttribute> areas = new ArrayList<>();
        for (String s : presenceOf) {
            RefugeAreasAttribute refugeAreasAttribute = new RefugeAreasAttribute();
            refugeAreasAttribute.setAreaId(s);
            areas.add(refugeAreasAttribute);
        }
        return areas;
    }

    @Override
    public void createShelter() {
        createShelter.createShelterToSend(shelter);
    }

    @Override
    public void createShelterSuccessCallback(String message) {
        view.onShelterCreated(message);
    }

    @Override
    public void createShelterFailureCallback(String message) {
        view.onShelterFailure(message);
    }


    @Override
    public void onServicesDataSuccess(List<String> data) {
        view.onServicesAutocompleteSuccess(data);
    }

    @Override
    public void onServicesDataFailure(Object object) {
        view.onServicesAutocompleteFailure(object);
    }
}