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
package com.tektonlabs.android.refugeapp.data.callbacks;

import com.tektonlabs.android.refugeapp.data.network.models.Shelter;
import com.tektonlabs.android.refugeapp.data.network.models.create_shelter.shelter_data.DataForShelterCreation;
import com.tektonlabs.android.refugeapp.data.usecase.GetShelterDataForCreation;

import java.util.List;

public interface SheltersDataSource {
    interface GetSheltersCallback{
        void onSheltersLoaded(List<Shelter> shelterList);
        void onSheltersFailure(Object object);
    }

    interface CreateShelterCallback{
        void onShelterCreated(Object object);
        void onShelterFailure(Object object);
    }

    interface GetShelterDataForCreationCallback{
        void onDataSuccess(DataForShelterCreation object);
        void onDataFailure(Object object);
    }

    void loadShelters(SheltersDataSource.GetSheltersCallback callback, String latitude, String longitude, int limit, int offset);
    void searchShelters(String text, SheltersDataSource.GetSheltersCallback callback);
    void saveShelters(List<Shelter> shelters);
    void createShelter(SheltersDataSource.CreateShelterCallback callback,com.tektonlabs.android.refugeapp.data.network.models.create_shelter.Shelter shelter);
    void getShelterDataForCreation(GetShelterDataForCreationCallback callback);
}
