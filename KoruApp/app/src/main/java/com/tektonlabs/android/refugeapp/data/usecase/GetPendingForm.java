
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
package com.tektonlabs.android.refugeapp.data.usecase;

import com.tektonlabs.android.refugeapp.data.repositories.QuestionRepository;
import com.tektonlabs.android.refugeapp.data.repositories.callbacks.QuestionRepositoryCallback;
import com.tektonlabs.android.refugeapp.data.usecase.callbacks.PendingFormsUseCase;

import java.util.HashMap;

public class GetPendingForm extends BaseUseCase implements PendingFormsUseCase {

    private QuestionRepositoryCallback questionRepositoryCallback;
    private PendingFormsCallback pendingFormsCallback;
    public GetPendingForm(PendingFormsCallback pendingFormsCallback) {
        questionRepositoryCallback = new QuestionRepository(this);
        this.pendingFormsCallback = pendingFormsCallback;
    }

    @Override
    public void onDataFailure(Object object) {

    }

    public void getPendingForms() {
        questionRepositoryCallback.getPendingForms();
    }

    public void getAnyPendingForms(){
        questionRepositoryCallback.isThereAnyPendingFormLeft();
    }

    @Override
    public void getPendingForms(HashMap<Integer, Integer> pendingForms) {
        pendingFormsCallback.getPendingFormsCallback(pendingForms);
    }

    @Override
    public void getAnyPendingForms(boolean pendingForms) {
        pendingFormsCallback.getAnyPendingFormsCallback(pendingForms);
    }
}
