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
import android.support.annotation.NonNull;

import com.google.gson.ExclusionStrategy;
import com.google.gson.FieldAttributes;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.tektonlabs.android.refugeapp.BuildConfig;


import java.io.IOException;
import java.util.TimeZone;
import java.util.concurrent.TimeUnit;

import io.realm.RealmObject;
import okhttp3.Interceptor;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class RequestManager {

    private static Services defaultRequestManager;
    private static Retrofit retrofit;

    public RequestManager() {
        retrofit = generateRetrofit();
        defaultRequestManager = retrofit.create(Services.class);
    }

    public RequestManager(Context context, boolean doRefreshToken) {
        retrofit = doRefreshToken ? generateRetrofit(context) : generateSimpleRetrofit(context);
        defaultRequestManager = retrofit.create(Services.class);
    }


    public Services getWebServices(){
        return defaultRequestManager;
    }

    private static Retrofit generateRetrofit() {
        Gson gson = new GsonBuilder()
                .setExclusionStrategies(new ExclusionStrategy() {
                    @Override
                    public boolean shouldSkipField(FieldAttributes f) {
                        return f.getDeclaringClass().equals(RealmObject.class);
                    }

                    @Override
                    public boolean shouldSkipClass(Class<?> clazz) {
                        return false;
                    }
                })
                .create();

        final OkHttpClient client = getOkHttpClient();
        Retrofit.Builder builder = new Retrofit.Builder()
                .baseUrl(BuildConfig.BASE_API_URL);
        builder = builder.addConverterFactory(GsonConverterFactory.create(gson));
        return builder.client(client).build();
    }

    /**
     * Generates a Retrofit API client the corresponding headers, URl, and converter
     *
     * @return personalized Retrofit.
     */
    private static Retrofit generateRetrofit(final Context context) {
        Gson gson = new GsonBuilder()
                .setExclusionStrategies(new ExclusionStrategy() {
                    @Override
                    public boolean shouldSkipField(FieldAttributes f) {
                        return f.getDeclaringClass().equals(RealmObject.class);
                    }

                    @Override
                    public boolean shouldSkipClass(Class<?> clazz) {
                        return false;
                    }
                })
                .create();

        final OkHttpClient client = getOkHttpClient(context);
        Retrofit.Builder builder = new Retrofit.Builder()
                .baseUrl(BuildConfig.BASE_API_URL);
        builder = builder.addConverterFactory(GsonConverterFactory.create(gson));
        return builder.client(client).build();
    }


    /**
     * Generates a Retrofit API client the corresponding headers, URl, and converter.
     * With an OkHttpClient without the option to refresh token if it expires.
     *
     * @return personalized Retrofit.
     */
    private static Retrofit generateSimpleRetrofit(final Context context) {
        Gson gson = new GsonBuilder()
                .setExclusionStrategies(new ExclusionStrategy() {
                    @Override
                    public boolean shouldSkipField(FieldAttributes f) {
                        return f.getDeclaringClass().equals(RealmObject.class);
                    }

                    @Override
                    public boolean shouldSkipClass(Class<?> clazz) {
                        return false;
                    }
                })
                .create();
        final OkHttpClient client = getSimpleOkHttpClient(context);
        Retrofit.Builder builder = new Retrofit.Builder()
                .baseUrl(BuildConfig.BASE_API_URL);
        builder = builder.addConverterFactory(GsonConverterFactory.create(gson));
        return builder.client(client).build();
    }

    /**
     * Generates OkHttpClient instance with configured timeouts and auth/logging interceptors
     *
     * @return OkHttpClient
     */
    @NonNull
    private static OkHttpClient getOkHttpClient() {
        OkHttpClient.Builder builder = new OkHttpClient().newBuilder()
                .readTimeout(20, TimeUnit.SECONDS)
                .connectTimeout(20, TimeUnit.SECONDS);

        //For adding logs of APIs requests & responses
        if (BuildConfig.SHOW_LOG) {
            HttpLoggingInterceptor interceptor = new HttpLoggingInterceptor();
            interceptor.setLevel(HttpLoggingInterceptor.Level.BODY);
            builder.addInterceptor(interceptor);
        }

        //General interceptor
        builder.addInterceptor(new Interceptor() {
            @Override
            public Response intercept(Chain chain) throws IOException {
                Request original = chain.request();

                Request.Builder requestBuilder = original.newBuilder()
                        .method(original.method(), original.body());
                return chain.proceed(requestBuilder.build());
            }
        });

        return builder.build();
    }

    private static OkHttpClient getOkHttpClient(final Context context) {
        RefreshTokenAuthenticator authAuthenticator = new RefreshTokenAuthenticator(context);

        OkHttpClient.Builder builder = new OkHttpClient().newBuilder()
                .readTimeout(20, TimeUnit.SECONDS)
                .connectTimeout(20, TimeUnit.SECONDS)
                .authenticator(authAuthenticator);



        //General interceptor with authorization token
        builder.addInterceptor(new Interceptor() {
            @Override
            public Response intercept(Chain chain) throws IOException {
                Request original = chain.request();
                String token = getAuthToken(context);

                Request.Builder requestBuilder = original.newBuilder()
                        .addHeader("Authorization", token)
                        .addHeader("Time-Zone", TimeZone.getDefault().getID())
                        .method(original.method(), original.body());
                return chain.proceed(requestBuilder.build());
            }
        });

        //For adding logs of APIs requests & responses
        if (BuildConfig.SHOW_LOG) {
            HttpLoggingInterceptor interceptor = new HttpLoggingInterceptor();
            interceptor.setLevel(HttpLoggingInterceptor.Level.BODY);
            builder.addInterceptor(interceptor);
        }

        return builder.build();
    }

    /**
     * Generates an OkHttpClient without the option to refresh token if it expires.
     * Useful in case you want to get the new refreshed token
     * @param context Context where the method was called from
     * @return OkHttpClient without refresh token option
     */
    private static OkHttpClient getSimpleOkHttpClient(final Context context) {
        OkHttpClient.Builder builder = new OkHttpClient().newBuilder()
                .readTimeout(20, TimeUnit.SECONDS)
                .connectTimeout(20, TimeUnit.SECONDS);

        //General interceptor with authorization token
        builder.addInterceptor(new Interceptor() {
            @Override
            public Response intercept(Chain chain) throws IOException {
                Request original = chain.request();
                String token = getAuthToken(context);

                Request.Builder requestBuilder = original.newBuilder()
                        .addHeader("Authorization", token)
                        .addHeader("Time-Zone", TimeZone.getDefault().getID())
                        .method(original.method(), original.body());
                return chain.proceed(requestBuilder.build());
            }
        });

        //For adding logs of APIs requests & responses
        if (BuildConfig.SHOW_LOG) {
            HttpLoggingInterceptor interceptor = new HttpLoggingInterceptor();
            interceptor.setLevel(HttpLoggingInterceptor.Level.BODY);
            builder.addInterceptor(interceptor);
        }

        return builder.build();
    }

    private static String getAuthToken(Context context) {
        return "";
    }

    public static Retrofit getRetrofit() {
        return retrofit;
    }
}
