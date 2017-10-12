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

import com.tektonlabs.android.refugeapp.data.network.models.ApiErrorBody;

import java.lang.annotation.Annotation;

import okhttp3.ResponseBody;
import retrofit2.Converter;
import retrofit2.Response;

public class ApiErrorBuilder {
    public static ApiErrorBody buildApiError(Response response) throws Exception {
        Converter<ResponseBody, ApiErrorBody> converter = RequestManager.getRetrofit().responseBodyConverter(ApiErrorBody.class, new Annotation[0]);
        return converter.convert(response.errorBody());
    }
}
