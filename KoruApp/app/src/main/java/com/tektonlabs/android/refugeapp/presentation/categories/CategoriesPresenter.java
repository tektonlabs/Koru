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

package com.tektonlabs.android.refugeapp.presentation.categories;

import com.tektonlabs.android.refugeapp.data.network.models.Question;
import com.tektonlabs.android.refugeapp.data.network.models.Service;
import com.tektonlabs.android.refugeapp.data.usecase.GetServices;
import com.tektonlabs.android.refugeapp.presentation.categories.callbacks.CategoriesViewContract;
import com.tektonlabs.android.refugeapp.presentation.categories.callbacks.ServiceViewDataResponse;

import java.util.List;

public class CategoriesPresenter implements CategoriesViewContract.UserActionsListener, ServiceViewDataResponse {

    private CategoriesViewContract.View view;
    private GetServices getServices;

    public CategoriesPresenter(CategoriesViewContract.View view) {
        this.view = view;
        getServices = new GetServices(this);
    }


    @Override
    public void onServicesDataSuccess(List<Service> services) {
        for (Service service : services) {
            for (Question question : service.getQuestions()) {
                question.setServiceName(service.getName());
            }
        }
        view.onServicesDataSuccess(services);
    }

    @Override
    public void onServicesDataFailure(Object object) {
        view.onServicesDataFailure(object);
    }

    @Override
    public void requestServices(int shelterId) {
        getServices.getServices(shelterId);
    }

}
