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

package com.tektonlabs.android.refugeapp.data.network.services;

import com.tektonlabs.android.refugeapp.RefugeApp;
import com.tektonlabs.android.refugeapp.data.callbacks.AutocompleteServicesDataSource;
import com.tektonlabs.android.refugeapp.data.network.Services;
import com.tektonlabs.android.refugeapp.data.network.models.create_shelter.autocomplete.AutocompleteResponse;

import java.util.ArrayList;
import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class AutocompleteServicesRestDataSource implements AutocompleteServicesDataSource {
    private Services services;

    public AutocompleteServicesRestDataSource() {
        services = RefugeApp.getInstance().getServices();
    }

    @Override
    public void getAutocompleteServices(final GetAutocompleteServicesCallback callback, String query) {
        services.getServicesForAutocomplete(query).enqueue(new Callback<List<AutocompleteResponse>>() {
            @Override
            public void onResponse(Call<List<AutocompleteResponse>> call, Response<List<AutocompleteResponse>> response) {
                if(response.isSuccessful()){
                    List<String> data = new ArrayList<>();

                    for (AutocompleteResponse a : response.body()){
                        data.add(a.getName());
                    }

                    callback.onServicesSuccess(data);
                }
            }

            @Override
            public void onFailure(Call<List<AutocompleteResponse>> call, Throwable t) {
                callback.onServicesFailure(t.getMessage());
            }
        });
    }
}
