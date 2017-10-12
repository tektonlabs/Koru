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

import com.tektonlabs.android.refugeapp.data.callbacks.AutocompleteServicesDataSource;
import com.tektonlabs.android.refugeapp.data.network.services.AutocompleteServicesRestDataSource;
import com.tektonlabs.android.refugeapp.data.repositories.callbacks.AutocompleteServicesCallback;
import com.tektonlabs.android.refugeapp.data.usecase.BaseUseCase;
import com.tektonlabs.android.refugeapp.data.usecase.GetAutocompleteServices;

import java.util.List;

public class AutocompleteServicesRepository implements AutocompleteServicesCallback {

    private AutocompleteServicesDataSource autocompleteServicesRestDataSource;
    private BaseUseCase baseUseCase;

    public AutocompleteServicesRepository(BaseUseCase baseUseCase) {
        this.baseUseCase = baseUseCase;
        autocompleteServicesRestDataSource = new AutocompleteServicesRestDataSource();

    }

    @Override
    public void getAutoCompleteServices(String query) {
        autocompleteServicesRestDataSource.getAutocompleteServices(new AutocompleteServicesDataSource.GetAutocompleteServicesCallback(){
            @Override
            public void onServicesSuccess(List<String> data) {
                ((GetAutocompleteServices) baseUseCase).onAutocompleteServicesSuccess(data);
            }

            @Override
            public void onServicesFailure(String message) {
                baseUseCase.onDataFailure(message);
            }
        },query);
    }
}
