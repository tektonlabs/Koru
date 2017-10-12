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

package com.tektonlabs.android.refugeapp.data.usecase;

import com.tektonlabs.android.refugeapp.data.network.models.create_shelter.shelter_data.DataForShelterCreation;
import com.tektonlabs.android.refugeapp.data.repositories.ShelterRepository;
import com.tektonlabs.android.refugeapp.data.repositories.callbacks.ShelterRepositoryCallback;
import com.tektonlabs.android.refugeapp.data.usecase.callbacks.GetShelterDataForCreationUseCase;

public class GetShelterDataForCreation extends BaseUseCase implements GetShelterDataForCreationUseCase {

    private GetShelterDataForCreationUseCaseCallback getShelterDataForCreationUseCaseCallback;
    private ShelterRepositoryCallback shelterRepository;

    public GetShelterDataForCreation(GetShelterDataForCreationUseCaseCallback getShelterDataForCreationUseCaseCallback) {
        this.getShelterDataForCreationUseCaseCallback = getShelterDataForCreationUseCaseCallback;
        shelterRepository = new ShelterRepository(this);
    }


    public void getShelterDataForCreation() {
        shelterRepository.getDataForShelterCreation();
    }

    @Override
    public void onDataFailure(Object object) {
        getShelterDataForCreationUseCaseCallback.createShelterFailureCallback((String)object);
    }

    @Override
    public void getShelterDataSuccess(DataForShelterCreation object) {
        getShelterDataForCreationUseCaseCallback.createShelterSuccessCallback(object);
    }
}
