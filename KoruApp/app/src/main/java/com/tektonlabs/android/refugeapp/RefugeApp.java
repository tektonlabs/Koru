/*
 * ===========================================================================
 * Koru GPL Source Code
 * Copyright (C) 2017 Tekton Labs
 * This file is part of the Koru GPL Source Code.
 * Koru Source Code is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Koru Source Code is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Koru Source Code. If not, see <http://www.gnu.org/licenses/>.
 * ===========================================================================
 */

package com.tektonlabs.android.refugeapp;

import android.app.Application;
import com.crashlytics.android.Crashlytics;
import com.tektonlabs.android.refugeapp.data.network.RequestManager;
import com.tektonlabs.android.refugeapp.data.network.Services;
import io.fabric.sdk.android.Fabric;
import io.realm.Realm;
import io.realm.RealmConfiguration;

public class RefugeApp extends Application {

    private Services services, authServices;
    private static RefugeApp instance;


    public static RefugeApp getInstance() {
        return instance;
    }


    @Override
    public void onCreate() {
        super.onCreate();
        Fabric.with(this, new Crashlytics());
        instance = this;
        services = new RequestManager().getWebServices();
        Realm.init(this);
        RealmConfiguration realmConfiguration = new RealmConfiguration.Builder().build();
        Realm.setDefaultConfiguration(realmConfiguration);
//        if(BuildConfig.REPORT_CRASHES){
//            Fabric.with(this, new Crashlytics());
//        }

    }

    public Services getServices() {
        return services;
    }

    public Services getAuthServices() {
        if (authServices == null){
            setAuthServices();
        }
        return authServices;
    }

    public void setAuthServices() {
        this.authServices = new RequestManager(this, true).getWebServices();
    }

    public Services getSimpleAuthServices() {
        return new RequestManager(this, false).getWebServices();
    }
}
