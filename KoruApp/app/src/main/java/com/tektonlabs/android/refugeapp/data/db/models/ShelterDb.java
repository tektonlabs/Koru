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

package com.tektonlabs.android.refugeapp.data.db.models;

import android.support.annotation.NonNull;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;
import com.tektonlabs.android.refugeapp.data.network.models.Country;

import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey;


public class ShelterDb extends RealmObject implements Comparable<ShelterDb>{

    @PrimaryKey
    private Integer id;

    private String name;

    private String longitude;

    private String latitude;

    private String status;

    private String address;

    private String city;

    private CountryDb country;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLongitude() {
        return longitude;
    }

    public void setLongitude(String longitude) {
        this.longitude = longitude;
    }

    public String getLatitude() {
        return latitude;
    }

    public void setLatitude(String latitude) {
        this.latitude = latitude;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public CountryDb getCountry() {
        return country;
    }

    public void setCountry(CountryDb country) {
        this.country = country;
    }

    @Override
    public int compareTo(@NonNull ShelterDb o) {
        return (this.name.toLowerCase()).compareTo(o.name.toLowerCase());
    }
}
