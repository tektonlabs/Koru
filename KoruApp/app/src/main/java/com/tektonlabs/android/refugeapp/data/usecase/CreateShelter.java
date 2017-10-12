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

import com.tektonlabs.android.refugeapp.data.network.models.create_shelter.Shelter;
import com.tektonlabs.android.refugeapp.data.repositories.ShelterRepository;
import com.tektonlabs.android.refugeapp.data.repositories.callbacks.ShelterRepositoryCallback;
import com.tektonlabs.android.refugeapp.data.usecase.callbacks.CreateShelterUseCase;

public class CreateShelter extends BaseUseCase implements CreateShelterUseCase.CreateShelterUseCaseCallback {

    private CreateShelterUseCase.CreateShelterUseCaseCallback createShelterUseCaseCallback;
    private ShelterRepositoryCallback shelterRepositoryCallback;

    public CreateShelter(CreateShelterUseCase.CreateShelterUseCaseCallback createShelterUseCaseCallback) {
        this.createShelterUseCaseCallback = createShelterUseCaseCallback;
        shelterRepositoryCallback = new ShelterRepository(this);

    }

    public void createShelterToSend(Shelter shelter) {
            shelterRepositoryCallback.createShelter(shelter);
    }

    @Override
    public void onDataFailure(Object object) {
        createShelterUseCaseCallback.createShelterFailureCallback((String)object);
    }

    @Override
    public void createShelterSuccessCallback(String message) {
        createShelterUseCaseCallback.createShelterSuccessCallback(message);
    }

    @Override
    public void createShelterFailureCallback(String message) {
        createShelterUseCaseCallback.createShelterFailureCallback(message);
    }
}
