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

package com.tektonlabs.android.refugeapp.data.network.shelters;

import com.google.gson.JsonObject;
import com.tektonlabs.android.refugeapp.RefugeApp;
import com.tektonlabs.android.refugeapp.data.callbacks.SheltersDataSource;
import com.tektonlabs.android.refugeapp.data.network.ApiErrorBuilder;
import com.tektonlabs.android.refugeapp.data.network.Services;
import com.tektonlabs.android.refugeapp.data.network.models.ApiErrorBody;
import com.tektonlabs.android.refugeapp.data.network.models.Shelter;
import com.tektonlabs.android.refugeapp.data.network.models.create_shelter.shelter_data.DataForShelterCreation;

import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class ShelterRestDataSource implements SheltersDataSource {

    private Services services;

    public ShelterRestDataSource() {
        services = RefugeApp.getInstance().getServices();
    }

    @Override
    public void loadShelters(final GetSheltersCallback callback, String latitude, String longitude, int limit, int offset) {
        services.getShelters(latitude, longitude, limit, offset).enqueue(new Callback<List<Shelter>>() {
            @Override
            public void onResponse(Call<List<Shelter>> call, Response<List<Shelter>> response) {
                if (response.isSuccessful()) {
                    callback.onSheltersLoaded(response.body());
                } else {
                    try {
                        ApiErrorBody apiErrorBody = ApiErrorBuilder.buildApiError(response);
                        callback.onSheltersFailure(apiErrorBody);
                    } catch (Exception e) {
                        callback.onSheltersFailure(e);
                    }
                }
            }

            @Override
            public void onFailure(Call<List<Shelter>> call, Throwable t) {
                callback.onSheltersFailure(t);
            }
        });
    }

    @Override
    public void searchShelters(String text, final GetSheltersCallback callback) {
        services.searchShelters(text).enqueue(new Callback<List<Shelter>>() {
            @Override
            public void onResponse(Call<List<Shelter>> call, Response<List<Shelter>> response) {
                if (response.isSuccessful()) {
                    callback.onSheltersLoaded(response.body());
                } else {
                    try {
                        ApiErrorBody apiErrorBody = ApiErrorBuilder.buildApiError(response);
                        callback.onSheltersFailure(apiErrorBody);
                    } catch (Exception e) {
                        callback.onSheltersFailure(e);
                    }
                }
            }

            @Override
            public void onFailure(Call<List<Shelter>> call, Throwable t) {
                callback.onSheltersFailure(t);
            }
        });
    }

    @Override
    public void saveShelters(List<Shelter> shelters) {
        //Only local
    }

    @Override
    public void createShelter(final SheltersDataSource.CreateShelterCallback callback, com.tektonlabs.android.refugeapp.data.network.models.create_shelter.Shelter shelter) {
        services.creteShelter(shelter).enqueue(new Callback<JsonObject>() {
            @Override
            public void onResponse(Call<JsonObject> call, Response<JsonObject> response) {
                if (response.isSuccessful()) {
                    callback.onShelterCreated(response.body().get("success").toString());
                }
            }

            @Override
            public void onFailure(Call<JsonObject> call, Throwable t) {
                callback.onShelterFailure(t.getMessage());
            }
        });
    }

    @Override
    public void getShelterDataForCreation(final GetShelterDataForCreationCallback callback) {
        services.getShelterDataForCreation().enqueue(new Callback<DataForShelterCreation>() {
            @Override
            public void onResponse(Call<DataForShelterCreation> call, Response<DataForShelterCreation> response) {
                callback.onDataSuccess(response.body());
            }

            @Override
            public void onFailure(Call<DataForShelterCreation> call, Throwable t) {
                callback.onDataFailure(t.getMessage());
            }
        });
    }

}
