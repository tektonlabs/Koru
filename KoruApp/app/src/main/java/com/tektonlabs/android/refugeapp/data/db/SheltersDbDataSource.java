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

package com.tektonlabs.android.refugeapp.data.db;

import android.util.Log;

import com.tektonlabs.android.refugeapp.data.callbacks.SheltersDataSource;
import com.tektonlabs.android.refugeapp.data.db.models.ShelterDb;
import com.tektonlabs.android.refugeapp.data.db.models.mappers.DbModelsMapper;
import com.tektonlabs.android.refugeapp.data.db.models.mappers.NetworkModelsMapper;
import com.tektonlabs.android.refugeapp.data.network.models.Shelter;
import com.tektonlabs.android.refugeapp.utils.PaginationHelper;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import io.realm.Case;
import io.realm.Realm;
import io.realm.RealmResults;
import io.realm.Sort;

public class SheltersDbDataSource implements SheltersDataSource {


    private List<List<Shelter>> paginatedResult;

    public SheltersDbDataSource() {
    }


    @Override
    public void loadShelters(GetSheltersCallback callback, String latitude, String longitude, int limit, int offset) {
        final Realm realm = Realm.getDefaultInstance();
        RealmResults<ShelterDb> result = realm.where(ShelterDb.class).findAllSorted("name", Sort.ASCENDING);
        if (result.size() > 0) {
            ArrayList<ShelterDb> list = new ArrayList<>(result);
            Collections.sort(list);
            callback.onSheltersLoaded(PaginationHelper.getListOfElements(createPages(list), limit, offset));
        } else {
            callback.onSheltersFailure("Data not available");
        }
        realm.close();
    }

    private List<List<Shelter>> createPages(ArrayList<ShelterDb> result) {
        if (paginatedResult == null) {
            paginatedResult = PaginationHelper.getPages(DbModelsMapper.sheltersDbToSheltersList(result), 20);
        }
        return paginatedResult;
    }

    @Override
    public void searchShelters(String text, GetSheltersCallback callback) {
        final Realm realm = Realm.getDefaultInstance();
        RealmResults<ShelterDb> result = realm.where(ShelterDb.class)
                .equalTo("name", text, Case.INSENSITIVE)
                .or()
                .contains("name", text, Case.INSENSITIVE).findAll();
        callback.onSheltersLoaded(DbModelsMapper.sheltersDbToSheltersList(new ArrayList<>(result)));
    }

    @Override
    public void saveShelters(List<Shelter> shelters) {
        final Realm realm = Realm.getDefaultInstance();
        final List<ShelterDb> sheltersDb = NetworkModelsMapper.sheltersListToSheltersDbList(shelters);
        realm.executeTransactionAsync(new Realm.Transaction() {
            @Override
            public void execute(Realm realm) {
                realm.copyToRealmOrUpdate(sheltersDb);
            }
        }, new Realm.Transaction.OnSuccess() {
            @Override
            public void onSuccess() {
                realm.close();
            }
        }, new Realm.Transaction.OnError() {
            @Override
            public void onError(Throwable error) {
                Log.e("Error", "onError Db Save" + error.toString());
                realm.close();
            }
        });
    }

    @Override
    public void createShelter(CreateShelterCallback callback, com.tektonlabs.android.refugeapp.data.network.models.create_shelter.Shelter shelter) {
        //only for rest
    }

    @Override
    public void getShelterDataForCreation(GetShelterDataForCreationCallback callback) {
        //only for rest
    }
}
