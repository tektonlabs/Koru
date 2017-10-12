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

import android.content.Context;
import java.io.IOException;
import okhttp3.Authenticator;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.Route;

public class RefreshTokenAuthenticator implements Authenticator {


    public RefreshTokenAuthenticator(Context context) {

    }



    @Override
    public Request authenticate(Route route, Response response) throws IOException {

//        Call<UserResponse> call = SportsVentingApplication.getInstance().getSimpleAuthServices().refreshToken();
//
//        try {
//            String token = call.execute().body().getToken();
//
//            sharedPreferencesHelper.saveSession(token);
//            // Add new header to rejected request and retry it
//            return response.request().newBuilder()
//                    .header("Authorization","Bearer " +sharedPreferencesHelper.getSession())
//                    .header("Accept", "application/json")
//                    .build();
//        } catch (Exception e) {
            return null;
//        }
    }
}

