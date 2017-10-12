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

package com.tektonlabs.android.refugeapp.data.repositories;

import com.tektonlabs.android.refugeapp.data.callbacks.SheltersDataSource;
import com.tektonlabs.android.refugeapp.data.db.SheltersDbDataSource;
import com.tektonlabs.android.refugeapp.data.network.models.Shelter;
import com.tektonlabs.android.refugeapp.data.network.models.create_shelter.shelter_data.DataForShelterCreation;
import com.tektonlabs.android.refugeapp.data.network.shelters.ShelterRestDataSource;
import com.tektonlabs.android.refugeapp.data.repositories.callbacks.ShelterRepositoryCallback;
import com.tektonlabs.android.refugeapp.data.usecase.BaseUseCase;
import com.tektonlabs.android.refugeapp.data.usecase.CreateShelter;
import com.tektonlabs.android.refugeapp.data.usecase.GetShelterDataForCreation;
import com.tektonlabs.android.refugeapp.data.usecase.GetShelters;
import com.tektonlabs.android.refugeapp.data.usecase.SearchShelter;
import java.util.Collections;
import java.util.List;

public class ShelterRepository implements ShelterRepositoryCallback {

    private SheltersDataSource sheltersRestDataSource;
    private SheltersDataSource sheltersDbDataSource;
    private BaseUseCase baseUseCase;

    public ShelterRepository(BaseUseCase baseUseCase) {
        this.baseUseCase = baseUseCase;
        sheltersRestDataSource = new ShelterRestDataSource();
        sheltersDbDataSource = new SheltersDbDataSource();
    }

    @Override
    public void loadShelters(final String latitude, final String longitude, final int limit, final int offset) {
        sheltersRestDataSource.loadShelters(new SheltersDataSource.GetSheltersCallback() {
            @Override
            public void onSheltersLoaded(List<Shelter> shelterList) {
                if (latitude.isEmpty() && longitude.isEmpty()) Collections.sort(shelterList);
                ((GetShelters) baseUseCase).onSheltersSuccess(shelterList);
                saveLocalShelters(shelterList);
            }

            @Override
            public void onSheltersFailure(Object object) {
                loadSheltersFromDb(latitude, longitude, limit, offset);
            }
        }, latitude, longitude, limit, offset);
    }

    private void loadSheltersFromDb(String latitude, String longitude, int limit, int offset) {
        sheltersDbDataSource.loadShelters(new SheltersDataSource.GetSheltersCallback() {
            @Override
            public void onSheltersLoaded(List<Shelter> shelterList) {
                Collections.sort(shelterList);
                ((GetShelters) baseUseCase).onSheltersSuccess(shelterList);
            }

            @Override
            public void onSheltersFailure(Object object) {
                baseUseCase.onDataFailure(object);
            }
        }, latitude, longitude, limit, offset);
    }


    private void saveLocalShelters(List<Shelter> shelters) {
        sheltersDbDataSource.saveShelters(shelters);
    }

    @Override
    public void searchShelters(final String text) {
        sheltersRestDataSource.searchShelters(text, new SheltersDataSource.GetSheltersCallback() {
            @Override
            public void onSheltersLoaded(List<Shelter> shelterList) {
                ((SearchShelter) baseUseCase).onSheltersSuccess(shelterList);
            }

            @Override
            public void onSheltersFailure(Object object) {
                searchLocalShelters(text);
            }
        });
    }

    @Override
    public void createShelter(com.tektonlabs.android.refugeapp.data.network.models.create_shelter.Shelter shelter) {
        sheltersRestDataSource.createShelter(new SheltersDataSource.CreateShelterCallback() {
            @Override
            public void onShelterCreated(Object object) {
                ((CreateShelter) baseUseCase).createShelterSuccessCallback((String) object);
            }

            @Override
            public void onShelterFailure(Object object) {
                baseUseCase.onDataFailure(object);
            }
        }, shelter);
    }

    @Override
    public void getDataForShelterCreation() {
        sheltersRestDataSource.getShelterDataForCreation(new SheltersDataSource.GetShelterDataForCreationCallback() {
            @Override
            public void onDataSuccess(DataForShelterCreation object) {
                ((GetShelterDataForCreation)baseUseCase).getShelterDataSuccess(object);
            }

            @Override
            public void onDataFailure(Object object) {
                (baseUseCase).onDataFailure(object);
            }
        });
    }

    private void searchLocalShelters(String text) {
        sheltersDbDataSource.searchShelters(text, new SheltersDataSource.GetSheltersCallback() {
            @Override
            public void onSheltersLoaded(List<Shelter> shelterList) {
                ((SearchShelter) baseUseCase).onSheltersSuccess(shelterList);
            }

            @Override
            public void onSheltersFailure(Object object) {
                baseUseCase.onDataFailure(object);
            }
        });
    }
}
