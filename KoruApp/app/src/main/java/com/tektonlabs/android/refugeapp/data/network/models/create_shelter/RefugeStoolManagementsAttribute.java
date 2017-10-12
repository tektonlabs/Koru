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

package com.tektonlabs.android.refugeapp.data.network.models.create_shelter;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class RefugeStoolManagementsAttribute {
    @SerializedName("stool_management_id")
    @Expose
    private String stoolManagementId;

    public String getStoolManagementId() {
        return stoolManagementId;
    }

    public void setStoolManagementId(String stoolManagementId) {
        this.stoolManagementId = stoolManagementId;
    }
}
