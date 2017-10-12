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

package com.tektonlabs.android.refugeapp.utils;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.support.v4.content.ContextCompat;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapFragment;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.LocalAddress;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.PlaceAutocompleteActivity;

import java.util.ArrayList;

public class MapManager implements OnMapReadyCallback {

    Context context;
    private MapFragment mMapFragment;
    public GoogleMap googleMap;
    private int fragmentId;
    private FragmentManager fragmentManager;
    ArrayList<Marker> markers = new ArrayList<>();
    private boolean infoWindowFlag;
    private GoogleMap.OnInfoWindowClickListener clickListener;
    private GoogleMap.OnMapLongClickListener onMapLongClickListener;
    private GoogleMap.OnCameraIdleListener onCameraIdleListener;
    private GoogleMap.OnCameraMoveListener onCameraMoveListener;
    private GoogleMap.OnCameraMoveStartedListener onCameraMoveStartedListener;
    OnMapReady mListenerMapReady;
    private LocalAddress localAddress;

    public MapManager(Context context, FragmentManager fragmentManager, int fragmentId,
                      GoogleMap.OnMapLongClickListener onMapLongClickListener, GoogleMap.OnCameraIdleListener onCameraIdleListener,
                      GoogleMap.OnCameraMoveListener onCameraMoveListener, GoogleMap.OnCameraMoveStartedListener onCameraMoveStartedListener) {
        this.context = context;
        this.fragmentId = fragmentId;
        this.fragmentManager = fragmentManager;
        this.onMapLongClickListener = onMapLongClickListener;
        this.onCameraIdleListener = onCameraIdleListener;
        this.onCameraMoveListener = onCameraMoveListener;
        this.onCameraMoveStartedListener = onCameraMoveStartedListener;
        mMapFragment = MapFragment.newInstance();
        FragmentTransaction fragmentTransaction =
                fragmentManager.beginTransaction();
        fragmentTransaction.add(fragmentId, mMapFragment);
        fragmentTransaction.commit();

        mMapFragment.getMapAsync(this);
    }

    public void setLocalAddress(LocalAddress localAddress) {
        this.localAddress = localAddress;
    }

    private void checkLocalAddress(GoogleMap googleMap, LocalAddress localAddress) {
        if (localAddress != null) {
            googleMap.clear();
            googleMap.addMarker(new MarkerOptions().position(new LatLng(localAddress.getLatitude(), localAddress.getLongitud())));
        }
    }

    private boolean checkPermissions() {
        if (ContextCompat.checkSelfPermission(context,
                Manifest.permission.ACCESS_COARSE_LOCATION)
                != PackageManager.PERMISSION_GRANTED) {
            return false;
        }
        return true;
    }

    @Override
    public void onMapReady(GoogleMap googleMap) {
        this.googleMap = googleMap;

        if(checkPermissions()){
            this.googleMap.setMyLocationEnabled(true);
        }

        setOnMapClickListener(onMapLongClickListener);
        setOnCameraIdleListener(onCameraIdleListener);
        setOnCamerMoveListener(onCameraMoveListener);
        setOnCamerMoveStartedListener(onCameraMoveStartedListener);

        checkLocalAddress(this.googleMap,localAddress);

        if (infoWindowFlag) {
            setOnInfoWindowClick(clickListener);
        }

        if (context instanceof PlaceAutocompleteActivity){
            ((PlaceAutocompleteActivity)context).updateMapWithAddress();
        }
        if(mListenerMapReady != null){
            mListenerMapReady.mapReady(googleMap);
        }
    }

    private void setOnCamerMoveStartedListener(GoogleMap.OnCameraMoveStartedListener onCameraMoveStartedListener) {
        googleMap.setOnCameraMoveStartedListener(onCameraMoveStartedListener);
    }

    private void setOnCamerMoveListener(GoogleMap.OnCameraMoveListener onCameraMoveListener) {
        googleMap.setOnCameraMoveListener(onCameraMoveListener);
    }

    public void setOnCameraIdleListener(GoogleMap.OnCameraIdleListener onCameraIdleListener){
        googleMap.setOnCameraIdleListener(onCameraIdleListener);
    }

    public void setOnMapReadyListener(OnMapReady eventListener){
        mListenerMapReady = eventListener;
    }

    public Marker getMarkers() {
        return markers.get(0);
    }

    public void addMarker(LatLng latLng) {
        markers.clear();
        googleMap.clear();
        markers.add(googleMap.addMarker(new MarkerOptions()
                .position(latLng)
        ));

        googleMap.animateCamera(CameraUpdateFactory.newLatLngZoom(latLng, 16.0f));

    }

    public void addMarker(MarkerOptions markerOptions) {
        markers.clear();
        googleMap.clear();
        markers.add(googleMap.addMarker(new MarkerOptions()
                .position(markerOptions.getPosition())
        ));

        googleMap.animateCamera(CameraUpdateFactory.newLatLngZoom(markerOptions.getPosition(), 16.0f));

    }

    public void enableCurrentLocation(boolean enableCurrentLocation) {
        if (Build.VERSION.SDK_INT >= 23) {
            if (checkAccessFineLocationPermission()) {
                googleMap.setMyLocationEnabled(enableCurrentLocation);
            }
        } else {
            googleMap.setMyLocationEnabled(enableCurrentLocation);
        }
    }

    public boolean isCurrentLocationEnabled() {
        return googleMap.isMyLocationEnabled();
    }

    @SuppressLint("NewApi")
    private boolean checkAccessFineLocationPermission() {
        String permission = Manifest.permission.ACCESS_FINE_LOCATION;
        int res = context.checkCallingOrSelfPermission(permission);
        return (res == PackageManager.PERMISSION_GRANTED);
    }

    private android.app.Fragment getCurrentFragment() {
        return fragmentManager.findFragmentById(fragmentId);
    }

    public void setInfoWindowClick(boolean flag, GoogleMap.OnInfoWindowClickListener clickListener) {
        this.infoWindowFlag = flag;
        this.clickListener = clickListener;
    }

    private void setOnInfoWindowClick(GoogleMap.OnInfoWindowClickListener clickListener) {
        googleMap.setOnInfoWindowClickListener(clickListener);
    }

    private void setOnMapClickListener(GoogleMap.OnMapLongClickListener clickListener) {
        googleMap.setOnMapLongClickListener(clickListener);
    }
}
