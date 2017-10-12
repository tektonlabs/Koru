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

package com.tektonlabs.android.refugeapp.presentation.shelters;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.Looper;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.ActivityCompat;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.places.Places;

import static android.content.Context.LOCATION_SERVICE;

public class LastKnownLocationManager implements GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener, LocationListener {


    private GoogleApiClient googleApiClient;
    private LastKnownLocationListener lastKnownLocationListener;
    private Context context;
    private LocationManager locationManager;

    public LastKnownLocationManager(Context context, LastKnownLocationListener lastKnownLocationListener) {
        this.context = context;
        this.lastKnownLocationListener = lastKnownLocationListener;
    }

    public void buildGoogleApiConnection() {
        if (googleApiClient == null) {
            googleApiClient = new GoogleApiClient.Builder(context)
                    .addConnectionCallbacks(this)
                    .addOnConnectionFailedListener(this)
                    .addApi(LocationServices.API)
                    .addApi(Places.GEO_DATA_API)
                    .build();
            googleApiClient.connect();
        } else {
            googleApiClient.connect();
        }
        lastKnownLocationListener.onGoogleApiConnected();
    }

    public GoogleApiClient getGoogleApiClient() {
        return googleApiClient;
    }

    public String getProviderName() {
        Criteria criteria = new Criteria();
        criteria.setPowerRequirement(Criteria.POWER_LOW);
        criteria.setAccuracy(Criteria.ACCURACY_MEDIUM);
        criteria.setSpeedRequired(false);
        criteria.setAltitudeRequired(false);
        criteria.setBearingRequired(false);
        criteria.setCostAllowed(false);
        return locationManager.getBestProvider(criteria, false);
    }

    public void buildLocationManager() {
        if (ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED
                && ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            return;
        }
        locationManager = (LocationManager) context.getSystemService(LOCATION_SERVICE);
        locationManager.requestSingleUpdate(getProviderName(), this, Looper.getMainLooper());
    }


    @Override
    public void onConnected(@Nullable Bundle bundle) {
        if (ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            return;
        }
        lastKnownLocationListener.onGoogleApiConnected();
        Location lastKnownLocation = LocationServices.FusedLocationApi.getLastLocation(
                googleApiClient);
        lastKnownLocationListener.onLocationReady(lastKnownLocation);
        if (lastKnownLocation == null) {
            buildLocationManager();
        }
    }


    @Override
    public void onConnectionSuspended(int i) {
        lastKnownLocationListener.onConnectionSuspended();
    }

    @Override
    public void onConnectionFailed(@NonNull ConnectionResult connectionResult) {
        lastKnownLocationListener.onConnectionFailed();
    }

    @Override
    public void onLocationChanged(Location location) {
        lastKnownLocationListener.onLocationReady(location);
    }

    @Override
    public void onStatusChanged(String s, int i, Bundle bundle) {
    }

    @Override
    public void onProviderEnabled(String s) {
        if (ActivityCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            return;
        }
        Location lastKnownLocation = LocationServices.FusedLocationApi.getLastLocation(
                googleApiClient);
        lastKnownLocationListener.onLocationReady(lastKnownLocation);
    }

    @Override
    public void onProviderDisabled(String s) {

    }

    public interface LastKnownLocationListener {
        void onLocationReady(Location location);

        void onConnectionSuspended();

        void onConnectionFailed();

        void onGoogleApiConnected();
    }
}
