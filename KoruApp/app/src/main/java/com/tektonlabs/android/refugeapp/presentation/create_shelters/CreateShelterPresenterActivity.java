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

import com.tektonlabs.android.refugeapp.data.network.models.create_shelter.shelter_data.DataForShelterCreation;
import com.tektonlabs.android.refugeapp.data.usecase.GetShelterDataForCreation;
import com.tektonlabs.android.refugeapp.data.usecase.callbacks.GetShelterDataForCreationUseCase;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.interfaces.CreateShelterViewContractActivity;

public class CreateShelterPresenterActivity implements CreateShelterViewContractActivity.UserActionListener, GetShelterDataForCreationUseCase.GetShelterDataForCreationUseCaseCallback {

    private CreateShelterViewContractActivity.View view;
    private GetShelterDataForCreation getShelterDataForCreation;

    public CreateShelterPresenterActivity(CreateShelterViewContractActivity.View view) {
        this.view = view;
        getShelterDataForCreation = new GetShelterDataForCreation(this);
    }

    @Override
    public void requestData() {
        getShelterDataForCreation.getShelterDataForCreation();
    }

    @Override
    public void createShelterSuccessCallback(DataForShelterCreation data) {
        view.onDataSuccess(data);
    }

    @Override
    public void createShelterFailureCallback(String message) {
        view.onDataFailure(message);
    }
}
