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

package com.tektonlabs.android.refugeapp.data.network;

import com.google.gson.JsonObject;
import com.tektonlabs.android.refugeapp.data.network.models.QuestionnaireToSend;
import com.tektonlabs.android.refugeapp.data.network.models.Service;
import com.tektonlabs.android.refugeapp.data.network.models.Shelter;
import com.tektonlabs.android.refugeapp.data.network.models.create_shelter.autocomplete.AutocompleteResponse;
import com.tektonlabs.android.refugeapp.data.network.models.create_shelter.shelter_data.DataForShelterCreation;
import java.util.List;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.Path;
import retrofit2.http.Query;

public interface Services {
    @GET(Urls.SERVICE_QUESTIONS)
    Call<List<Service>> getQuestions(@Path("refuge_id") String refuge_id);


    @GET(Urls.SERVICE_SHELTERS)
    Call<List<Shelter>> getShelters(@Query("lat") String latitude, @Query("long") String longitude, @Query("limit") int limit, @Query("offset") int offset);

    @POST(Urls.SEND_ANSWERS)
    Call<JsonObject> postSendAnswers(@Path("refuge_id") String refuge_id, @Body QuestionnaireToSend questionary);

    @GET(Urls.SEARCH_SHELTERS)
    Call<List<Shelter>> searchShelters(@Query("query") String searchQuery);

    @POST(Urls.CREATE_SHELTER)
    Call<JsonObject> creteShelter(@Body com.tektonlabs.android.refugeapp.data.network.models.create_shelter.Shelter shelter);

    @GET(Urls.GET_DATA_FOR_CREATION)
    Call<DataForShelterCreation> getShelterDataForCreation();

    @GET(Urls.GET_DATA_FOR_AUTOCOMPLETE)
    Call<List<AutocompleteResponse>> getServicesForAutocomplete(@Query("filter") String query);

}
