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

package com.tektonlabs.android.refugeapp.data.network.models.create_shelter.shelter_data;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.io.Serializable;
import java.util.ArrayList;

public class DataForShelterCreation implements Serializable{
    @SerializedName("committees")
    @Expose
    public ArrayList<MultipleChoice> committeesPresence = null;
    @SerializedName("services")
    @Expose
    public ArrayList<MultipleChoice> services = null;
    @SerializedName("housing_statuses")
    @Expose
    public ArrayList<MultipleChoice> housingStatuses = null;
    @SerializedName("areas")
    @Expose
    public ArrayList<MultipleChoice> areas = null;
    @SerializedName("light_managements")
    @Expose
    public ArrayList<MultipleChoice> lightManagements = null;
    @SerializedName("water_managements")
    @Expose
    public ArrayList<MultipleChoice> waterManagements = null;
    @SerializedName("stool_managements")
    @Expose
    public ArrayList<MultipleChoice> stoolManagements = null;
    @SerializedName("waste_managements")
    @Expose
    public ArrayList<MultipleChoice> wasteManagements = null;
    @SerializedName("food_managements")
    @Expose
    public ArrayList<MultipleChoice> foodManagements = null;
}
