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

import com.tektonlabs.android.refugeapp.data.repositories.AutocompleteServicesRepository;
import com.tektonlabs.android.refugeapp.data.repositories.callbacks.AutocompleteServicesCallback;
import com.tektonlabs.android.refugeapp.data.usecase.callbacks.AutocompleteServicesUseCaseCallback;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.AutocompleteServicesViewDataResponse;
import java.util.List;

public class GetAutocompleteServices extends BaseUseCase implements AutocompleteServicesUseCaseCallback{

    private AutocompleteServicesViewDataResponse autocompleteServicesViewDataResponse;
    private AutocompleteServicesCallback autocompleteServicesCallback;

    public GetAutocompleteServices(AutocompleteServicesViewDataResponse autocompleteServicesViewDataResponse) {
        this.autocompleteServicesViewDataResponse = autocompleteServicesViewDataResponse;
        autocompleteServicesCallback = new AutocompleteServicesRepository(this);
    }

    @Override
    public void onDataFailure(Object object) {
        autocompleteServicesViewDataResponse.onServicesDataFailure(object);
    }

    @Override
    public void onAutocompleteServicesSuccess(List<String> services) {
        autocompleteServicesViewDataResponse.onServicesDataSuccess(services);
    }

    @Override
    public void onAutocompleteServicesFailure(Object object) {
        autocompleteServicesViewDataResponse.onServicesDataFailure(object);
    }

    public void getServices(String query){
        autocompleteServicesCallback.getAutoCompleteServices(query);
    }
}
