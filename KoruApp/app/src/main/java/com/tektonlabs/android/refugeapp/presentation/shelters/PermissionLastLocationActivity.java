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
import android.location.Location;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import com.tektonlabs.android.refugeapp.R;
import java.util.List;
import pub.devrel.easypermissions.AfterPermissionGranted;
import pub.devrel.easypermissions.AppSettingsDialog;
import pub.devrel.easypermissions.EasyPermissions;

public class PermissionLastLocationActivity extends AppCompatActivity implements EasyPermissions.PermissionCallbacks, LastKnownLocationManager.LastKnownLocationListener {
    private static final int LOCATION_PERMISSION = 123;

    private LastKnownLocationManager lastKnownLocationManager;
    protected Location location;
    protected ShelterPresenter shelterPresenter;
    protected OnScrollSheltersListener onScrollSheltersListener;


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        lastKnownLocationManager = new LastKnownLocationManager(getApplicationContext(), this);
        requestLocationPermission();
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        EasyPermissions.onRequestPermissionsResult(requestCode, permissions, grantResults, this);
    }

    @AfterPermissionGranted(LOCATION_PERMISSION)
    private void requestLocationPermission() {
        String[] perms = {Manifest.permission.ACCESS_FINE_LOCATION};
        if (EasyPermissions.hasPermissions(this, perms)) {
            lastKnownLocationManager.buildGoogleApiConnection();
        } else {
            EasyPermissions.requestPermissions(this, getString(R.string.location_permission),
                    LOCATION_PERMISSION, perms);
        }
    }


    @Override
    public void onPermissionsGranted(int requestCode, List<String> perms) {
        lastKnownLocationManager.buildGoogleApiConnection();
    }

    @Override
    public void onPermissionsDenied(int requestCode, List<String> perms) {
        shelterPresenter.requestSheltersData("", "");
        if (EasyPermissions.somePermissionPermanentlyDenied(this, perms)) {
            new AppSettingsDialog.Builder(this).build().show();
        }
    }

    @Override
    public void onLocationReady(Location location) {
        this.location = location;
        if (location != null) {
            shelterPresenter.requestSheltersData(String.valueOf(location.getLatitude()), String.valueOf(location.getLongitude()));
        } else {
            shelterPresenter.requestSheltersData("", "");
        }
    }



    @Override
    public void onConnectionSuspended() {
        shelterPresenter.requestSheltersData("", "");
    }

    @Override
    public void onConnectionFailed() {
        shelterPresenter.requestSheltersData("", "");
    }

    @Override
    public void onGoogleApiConnected() {

    }

}
