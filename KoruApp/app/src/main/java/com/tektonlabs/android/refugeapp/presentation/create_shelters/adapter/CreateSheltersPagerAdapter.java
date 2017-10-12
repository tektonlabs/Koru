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

package com.tektonlabs.android.refugeapp.presentation.create_shelters.adapter;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.util.Log;

import com.tektonlabs.android.refugeapp.data.network.models.create_shelter.shelter_data.DataForShelterCreation;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.fragments.CreateShelterStep1Fragment;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.fragments.CreateShelterStep2Fragment;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.fragments.CreateShelterStep3Fragment;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.fragments.CreateShelterStep4Fragment;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.fragments.CreateShelterStep5Fragment;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.fragments.CreateShelterStep6Fragment;

import java.util.List;

public class CreateSheltersPagerAdapter extends FragmentPagerAdapter {

    private static final int PAGE_COUNT = 6;
    private DataForShelterCreation dataForShelterCreation;

    public CreateSheltersPagerAdapter(FragmentManager fm, DataForShelterCreation dataForShelterCreation) {
        super(fm);
        this.dataForShelterCreation = dataForShelterCreation;
    }

    @Override
    public Fragment getItem(int position) {
        switch (position){
            case 0:
                return new CreateShelterStep1Fragment();
            case 1:
                return CreateShelterStep2Fragment.newInstance(dataForShelterCreation.committeesPresence);
            case 2:
                return new CreateShelterStep3Fragment();
            case 3:
                return CreateShelterStep4Fragment.newInstance(dataForShelterCreation.services,dataForShelterCreation.housingStatuses);
            case 4:
                return CreateShelterStep5Fragment.newInstance(dataForShelterCreation.areas);
            case 5:
                return CreateShelterStep6Fragment.newInstance(dataForShelterCreation.lightManagements,dataForShelterCreation.waterManagements,dataForShelterCreation.stoolManagements,
                                                                dataForShelterCreation.wasteManagements,dataForShelterCreation.foodManagements);
            default:
                return new CreateShelterStep1Fragment();
        }
    }

    @Override
    public int getCount() {
        return PAGE_COUNT;
    }

    public void setDataToadapter(List<String> data) {

    }
}
