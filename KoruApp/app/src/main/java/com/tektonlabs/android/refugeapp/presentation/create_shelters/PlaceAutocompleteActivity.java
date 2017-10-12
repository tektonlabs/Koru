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


package com.tektonlabs.android.refugeapp.presentation.create_shelters;

import android.content.Intent;
import android.location.Address;
import android.location.Geocoder;
import android.location.Location;
import android.support.annotation.NonNull;
import android.support.design.widget.TextInputLayout;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.AdapterView;
import android.widget.AutoCompleteTextView;
import android.widget.Button;
import android.widget.Toast;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.api.ResultCallback;
import com.google.android.gms.location.places.AutocompletePrediction;
import com.google.android.gms.location.places.Place;
import com.google.android.gms.location.places.PlaceBuffer;
import com.google.android.gms.location.places.Places;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;
import com.tektonlabs.android.refugeapp.R;
import com.tektonlabs.android.refugeapp.presentation.shelters.LastKnownLocationManager;
import com.tektonlabs.android.refugeapp.utils.Constants;
import com.tektonlabs.android.refugeapp.utils.MapManager;
import com.tektonlabs.android.refugeapp.utils.PlaceAutocompleteAdapter;
import com.tektonlabs.android.refugeapp.utils.UIHelper;
import com.tektonlabs.android.refugeapp.utils.Utils;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnEditorAction;

public class PlaceAutocompleteActivity extends AppCompatActivity implements GoogleMap.OnMapLongClickListener, GoogleApiClient.OnConnectionFailedListener,
        GoogleMap.OnCameraIdleListener, GoogleMap.OnCameraMoveListener, GoogleMap.OnCameraMoveStartedListener, LastKnownLocationManager.LastKnownLocationListener,
        PlaceAutocompleteAdapter.PlacesConnection {

    @BindView(R.id.et_address)
    AutoCompleteTextView et_address;
    @BindView(R.id.til_address)
    TextInputLayout til_address;
    @BindView(R.id.btn_done)
    Button btn_done;

    GoogleApiClient mGoogleApiClient;

    private LastKnownLocationManager lastKnownLocationManager;

    private PlaceAutocompleteAdapter mAdapter;
    final LatLngBounds LIMA_BOUNDS = new LatLngBounds(new LatLng(-12.0525727, -77.0452337), new LatLng(-12.0525727, -77.0452337));

    public MapManager mapManager;
    private LatLng currentLatLng = new LatLng(-12.0525727, -77.0452337);
    private LocalAddress localAddress;
    private static final String TAG = "Autocomplete";
    private String country;
    private String city;
    private Toast toast;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_place_autocomplete);
        ButterKnife.bind(this);

        if (getSupportActionBar() != null) {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            getSupportActionBar().setTitle(getString(R.string.google_map_activity_title));
        }

        mapManager = new MapManager(this, this.getFragmentManager(), R.id.map, this, this, this, this);
        toast = Toast.makeText(getApplicationContext(), getString(R.string.connection_error), Toast.LENGTH_SHORT);

        getExtras();

        setupView();
    }

    private void getExtras() {
        if (getIntent().getExtras() != null) {
            localAddress = (LocalAddress) getIntent().getExtras().getSerializable(Constants.EXTRA_ADDRESS);
            if (localAddress != null) {
                mapManager.setLocalAddress(localAddress);
                et_address.setText(localAddress.getAddress());
                btn_done.setEnabled(true);
            } else {
                lastKnownLocationManager = new LastKnownLocationManager(getApplicationContext(), this);
            }
        }
    }

    private void setupView() {
        btn_done.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                updateAddress();
            }
        });
        btn_done.setEnabled(false);
        et_address.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                btn_done.setEnabled(false);
            }

            @Override
            public void afterTextChanged(Editable s) {
//                btn_done.setEnabled(!s.toString().trim().isEmpty());
            }
        });
        //Totally Custom
        lastKnownLocationManager = new LastKnownLocationManager(getApplicationContext(), this);
        lastKnownLocationManager.buildGoogleApiConnection();
    }

    @OnEditorAction(R.id.et_address)
    boolean onEditorAction(int id) {
        if (id == EditorInfo.IME_ACTION_DONE || id == EditorInfo.IME_NULL) {
            UIHelper.hideKeyboardActivity(this);
            return true;
        }
        return false;
    }

    @OnClick(R.id.btn_cancel)
    public void btn_cancel() {
        finish();
    }

    @Override
    public void onMapLongClick(LatLng latLng) {
        updateCurrentLatLng(latLng);
        updateEditText();
    }

    private void updateEditText() {
        Geocoder geocoder;
        List<Address> addresses = new ArrayList<>();
        geocoder = new Geocoder(PlaceAutocompleteActivity.this, Locale.getDefault());

        try {
            addresses = geocoder.getFromLocation(currentLatLng.latitude, currentLatLng.longitude, 1);
        } catch (IOException e) {
            e.printStackTrace();
        }

        if (!addresses.isEmpty()) {
            country = addresses.get(0).getCountryCode();
            city = addresses.get(0).getLocality();
            localAddress = new LocalAddress();
            localAddress.setLatitude(currentLatLng.latitude);
            localAddress.setLongitud(currentLatLng.longitude);
            localAddress.setCity(city);
            localAddress.setCountry(country);
            localAddress.setAddress(addresses.get(0).getAddressLine(0) != null ? addresses.get(0).getAddressLine(0) : "");
            et_address.setText(localAddress.getAddress());
        }
    }

    @Override
    public void onConnectionFailed(@NonNull ConnectionResult connectionResult) {
        Utils.showToast(PlaceAutocompleteActivity.this, getString(R.string.general_error));
    }

    private void updateCurrentLatLng(LatLng latLng) {
        currentLatLng = latLng;
        mapManager.addMarker(latLng);
    }

    @SuppressWarnings("ConstantConditions")
    private void updateAddress() {
        boolean cancel = false;
        View focusView = null;

        // Reset errors.
        til_address.setError(null);

        // Store values at the time of the login attempt.
        String address = til_address.getEditText().getText().toString();

        // Check for nonempty data.
        if (TextUtils.isEmpty(address) || currentLatLng == null) {
            til_address.setError(getString(R.string.error_address_empty));
            focusView = et_address;
            cancel = true;
        }

        if (cancel) {
            focusView.requestFocus();
        } else {
            returnAddress();
        }
        UIHelper.hideKeyboardActivity(this);
    }

    private void returnAddress() {
        localAddress = new LocalAddress();
        localAddress.setAddress(et_address.getText().toString());
        localAddress.setLatitude(currentLatLng.latitude);
        localAddress.setLongitud(currentLatLng.longitude);
        localAddress.setCity(city);
        localAddress.setCountry(country);

        Intent finishIntent = new Intent();
        finishIntent.putExtra(Constants.EXTRA_ADDRESS, localAddress);
        setResult(RESULT_OK, finishIntent);
        finish();
    }

    //CUSTOM place autocomplete setup
    /**
     * Listener that handles selections from suggestions from the AutoCompleteTextView that
     * displays Place suggestions.
     * Gets the place id of the selected item and issues a request to the Places Geo Data API
     * to retrieve more details about the place.
     *
     * @see com.google.android.gms.location.places.GeoDataApi#getPlaceById(com.google.android.gms.common.api.GoogleApiClient,
     * String...)
     */
    private AdapterView.OnItemClickListener mAutocompleteClickListener
            = new AdapterView.OnItemClickListener() {
        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
            /*
             Retrieve the place ID of the selected item from the Adapter.
             The adapter stores each Place suggestion in a AutocompletePrediction from which we
             read the place ID and title.
              */
            final AutocompletePrediction item = mAdapter.getItem(position);
            final String placeId = item.getPlaceId();
            final CharSequence primaryText = item.getPrimaryText(null);
            Log.i(TAG, "Autocomplete item selected: " + primaryText);

            Places.GeoDataApi.getPlaceById(mGoogleApiClient, placeId).setResultCallback(new ResultCallback<PlaceBuffer>() {
                @Override
                public void onResult(@NonNull PlaceBuffer places) {
                    currentLatLng = places.get(0).getLatLng();
                    city = places.get(0).getName().toString();
                    updateCityAndCountry();
                }
            });

            /*
             Issue a request to the Places Geo Data API to retrieve a Place object with additional
             details about the place.
              */
            PendingResult<PlaceBuffer> placeResult = Places.GeoDataApi
                    .getPlaceById(mGoogleApiClient, placeId);
            placeResult.setResultCallback(mUpdatePlaceDetailsCallback);
            Log.i(TAG, "Called getPlaceById to get Place details for " + placeId);
            btn_done.setEnabled(true);
        }
    };

    private void updateCityAndCountry() {
        Geocoder geocoder;
        List<Address> addresses = new ArrayList<>();
        geocoder = new Geocoder(PlaceAutocompleteActivity.this, Locale.getDefault());

        try {
            addresses = geocoder.getFromLocation(currentLatLng.latitude, currentLatLng.longitude, 1);
        } catch (IOException e) {
            e.printStackTrace();
        }

        if (!addresses.isEmpty()) {
            country = addresses.get(0).getCountryCode();
            if (addresses.get(0).getLocality() != null) {
                city = addresses.get(0).getLocality();
            }
        }
    }

    /**
     * Callback for results from a Places Geo Data API query that shows the first place result in
     * the details view on screen.
     */
    private ResultCallback<PlaceBuffer> mUpdatePlaceDetailsCallback
            = new ResultCallback<PlaceBuffer>() {
        @Override
        public void onResult(PlaceBuffer places) {
            if (!places.getStatus().isSuccess()) {
                // Request did not complete successfully
                Log.e(TAG, "Place query did not complete. Error: " + places.getStatus().toString());
                places.release();
                return;
            }
            // Get the Place object from the buffer.
            final Place place = places.get(0);

            updateCurrentLatLng(place.getLatLng());

            Log.i(TAG, "Place details received: " + place.getName());

            places.release();
        }
    };

    public void updateMapWithAddress() {
        if (localAddress != null) {
            if (localAddress.getLongitud() != null && localAddress.getLatitude() != null) {
                if (!(localAddress.getLatitude() == 0 && localAddress.getLongitud() == 0)) {
                    updateCurrentLatLng(new LatLng(localAddress.getLatitude(), localAddress.getLongitud()));
                }
            }
        }
    }

    @Override
    public void onCameraIdle() {
    }

    @Override
    public void onCameraMove() {
    }

    @Override
    public void onCameraMoveStarted(int i) {
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                finish();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    @Override
    public void onLocationReady(Location location) {
        if (localAddress == null) {
            if (location != null) {
                updateCurrentLatLng(new LatLng(location.getLatitude(), location.getLongitude()));
            }
            localAddress = new LocalAddress();
            updateEditText();
        }
    }

    @Override
    public void onConnectionSuspended() {

    }

    @Override
    public void onConnectionFailed() {

    }

    @Override
    public void onGoogleApiConnected() {
        mGoogleApiClient = lastKnownLocationManager.getGoogleApiClient();
        et_address.setOnItemClickListener(mAutocompleteClickListener);
        mAdapter = new PlaceAutocompleteAdapter(this, mGoogleApiClient, LIMA_BOUNDS, null, this);
        et_address.setAdapter(mAdapter);
    }

    @Override
    public void notConnected() {
        btn_done.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (!toast.getView().isShown()) {
                    toast.show();
                }
            }
        });
    }

    @Override
    public void isConnected() {
        btn_done.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                updateAddress();
            }
        });
    }
}