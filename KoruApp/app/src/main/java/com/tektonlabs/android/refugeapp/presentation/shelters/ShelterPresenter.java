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

import com.tektonlabs.android.refugeapp.data.network.models.Shelter;
import com.tektonlabs.android.refugeapp.data.usecase.GetPendingForm;
import com.tektonlabs.android.refugeapp.data.usecase.GetShelters;
import com.tektonlabs.android.refugeapp.data.usecase.PostAnswers;
import com.tektonlabs.android.refugeapp.data.usecase.SearchShelter;
import com.tektonlabs.android.refugeapp.data.usecase.callbacks.PendingFormsUseCase;
import com.tektonlabs.android.refugeapp.presentation.questions.callbacks.AnsweredQuestionsDataResponse;
import com.tektonlabs.android.refugeapp.presentation.shelters.callbacks.SheltersViewContract;
import com.tektonlabs.android.refugeapp.presentation.shelters.callbacks.SheltersViewDataResponse;
import java.util.HashMap;
import java.util.List;

public class ShelterPresenter implements SheltersViewContract.UserActionsListener, SheltersViewDataResponse, AnsweredQuestionsDataResponse, PendingFormsUseCase.PendingFormsCallback {
    private static final int DEFAULT_LIMIT = 20;


    private SheltersViewContract.View view;
    private GetShelters getShelters;
    private PostAnswers postAnswers;
    private SearchShelter searchShelter;
    private int limit = DEFAULT_LIMIT;
    private int sheltersOffset = -DEFAULT_LIMIT;

    private GetPendingForm getPendingForm;
    private List<Shelter> shelterList;


    public ShelterPresenter(SheltersViewContract.View view) {
        this.view = view;
        getShelters = new GetShelters(this);
        postAnswers = new PostAnswers(this);
        searchShelter = new SearchShelter(this);
        getPendingForm = new GetPendingForm(this);
    }

    private void calculateCharactersPagination() {
        sheltersOffset = sheltersOffset + DEFAULT_LIMIT;
    }


    @Override
    public void requestSheltersData(String latitude, String longitude) {
        calculateCharactersPagination();
        getShelters.getShelters(latitude, longitude, limit, sheltersOffset);
    }

    @Override
    public void postPendingAnswers() {
        postAnswers.postPendingAnswers();
    }

    @Override
    public void searchShelters(String text) {
        searchShelter.searchShelters(text);
    }

    @Override
    public void resetOffset() {
        sheltersOffset = -DEFAULT_LIMIT;
    }

    public void isThereAnyPendingForms() {
        getPendingForm.getAnyPendingForms();
    }

    @Override
    public void onSheltersDataSuccess(List<Shelter> shelterList) {
        this.shelterList = shelterList;
        getPendingForm.getPendingForms();
    }

    @Override
    public void onSheltersDataFailure(Object object) {
        view.setNoSheltersData(object);
    }

    @Override
    public void onSheltersSearchSuccess(List<Shelter> shelterList) {
        view.setSheltersSearchResult(shelterList);
    }

    @Override
    public void onSheltersSearchDataFailure(Object message, String text) {
        view.setNoSheltersSearchResult(message, text);
    }

    @Override
    public void onAnyPendingForm(boolean pendingForms) {
        view.arePendingFormsLeft(pendingForms);
    }

    @Override
    public void onQuestionsAnsweredSuccess(Object object, int shelterId) {
        view.questionsAnsweredSuccess(object, shelterId);
    }


    @Override
    public void onQuestionsAnsweredFailure(Object object) {
        view.questionsAnsweredFailure(object);
    }


    @Override
    public void getPendingFormsCallback(HashMap<Integer, Integer> pendingForms) {
        for (HashMap.Entry<Integer, Integer> entry : pendingForms.entrySet()) {
            Integer key = entry.getKey();
            Integer value = entry.getValue();
            setPendingFormsPerShelter(key, value);
        }
        view.setSheltersData(shelterList);
    }

    @Override
    public void getAnyPendingFormsCallback(boolean pendingForms) {
        onAnyPendingForm(pendingForms);
    }

    private void setPendingFormsPerShelter(int shelterId, int pendingCount) {
        for (Shelter shelter : shelterList) {
            if (shelter.getId() == shelterId) {
                shelter.setPendingForms(pendingCount);
            } else {
                shelter.setPendingForms(0);
            }
        }
    }

}
