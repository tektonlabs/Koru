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


package com.tektonlabs.android.refugeapp.presentation.create_shelters.interfaces;

import com.tektonlabs.android.refugeapp.presentation.create_shelters.Contact;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.LocalAddress;

import java.util.ArrayList;
import java.util.List;

public interface CreateShelterViewContract {
    interface FirstStepView extends BaseStepView {
        void nameTextEmpty();

        void shelterTypeEmpty();

        void organizationEmpty();

        void emergencyTypeEmpty();

        void addressEmpty();
    }

    interface SecondStepView extends BaseStepView {
        void propertyEmpty();

        void accessibilityEmpty();

        void victimsEmpty();
    }

    interface ThirdStepView extends BaseStepView {
        void primaryContactEmpty();
    }


    interface FifthStepView extends BaseStepView {
        void floorEmpty();

        void roofEmpty();
    }

    interface SixthStepView extends BaseStepView {

    }

    interface View {
        void onShelterCreated(String message);

        void onShelterFailure(String message);

        void onServicesAutocompleteSuccess(List<String> data);

        void onServicesAutocompleteFailure(Object object);
    }

    interface UserActionListener {

        void getServices(String query);

        boolean validateFirstStep(String name, String shelterType, String organization,
                                  String emergencyType, LocalAddress address, String dni,
                                  String phone, String institution);

        boolean validateSecondStep(String property_type, String accessibility, String victims);

        boolean validateThirdStep(Contact contact, ArrayList<Contact> secondarys);

        boolean validateFifthStep(String floor, String roof);

        void optionalFieldsSecondStep(ArrayList<String> committeePresence);

        void optionalFieldsFourthStep(String family, String numberPregnant, String numberHandicapped, String numberPets, String numberFarmAnimals,
                                      ArrayList<String> typeOfService, ArrayList<String> housesStatus, String maleChildren, String femaleChildren,
                                      String maleUnder18, String femaleUnder18, String maleAbove18, String femaleAbove18, String maleElderly, String femaleElderly);

        void optionalFieldsFifthStep(String numberOfToilet, String numberOfTents, String numberOfSinks, String numberOfShowers,
                                     String numberOfTanks, String numberOfTrashCans, String numberOfTrashContainer, ArrayList<String> presenceOf);

        void optionalFieldsSixthStep(ArrayList<String> light, ArrayList<String> water, ArrayList<String> fecesHandling, ArrayList<String> wasteManagement,
                                     ArrayList<String> foodAndBeverages);

        void createShelter();
    }

    interface FourthStepView extends BaseStepView {
    }
}
