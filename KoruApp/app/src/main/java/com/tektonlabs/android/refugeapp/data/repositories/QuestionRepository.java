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

package com.tektonlabs.android.refugeapp.data.repositories;

import com.tektonlabs.android.refugeapp.data.callbacks.QuestionsDataSource;
import com.tektonlabs.android.refugeapp.data.db.QuestionsDbDataSource;
import com.tektonlabs.android.refugeapp.data.network.models.Questionnaire;
import com.tektonlabs.android.refugeapp.data.network.models.Service;
import com.tektonlabs.android.refugeapp.data.network.questions.QuestionRestDataSource;
import com.tektonlabs.android.refugeapp.data.repositories.callbacks.QuestionRepositoryCallback;
import com.tektonlabs.android.refugeapp.data.usecase.BaseUseCase;
import com.tektonlabs.android.refugeapp.data.usecase.GetServices;
import com.tektonlabs.android.refugeapp.data.usecase.PostAnswers;
import com.tektonlabs.android.refugeapp.data.usecase.callbacks.PendingFormsUseCase;
import com.tektonlabs.android.refugeapp.data.utils.PendingFormHelper;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class QuestionRepository implements QuestionRepositoryCallback {

    private QuestionsDataSource questionRestDataSource;
    private QuestionsDataSource questionDbDataSource;
    private BaseUseCase baseUseCase;

    public QuestionRepository(BaseUseCase baseUseCase) {
        this.baseUseCase = baseUseCase;
        questionRestDataSource = new QuestionRestDataSource();
        questionDbDataSource = new QuestionsDbDataSource();
    }


    @Override
    public void loadQuestions(final int shelterId) {
        questionRestDataSource.loadServices(new QuestionsDataSource.GetQuestionsCallback() {
            @Override
            public void onQuestionsLoaded(List<Service> services) {
                ((GetServices) baseUseCase).onServicesSuccess(services);
                saveServiceToLocalStorage(services, shelterId);
            }

            @Override
            public void onQuestionsNotAvailable(Object object) {
                loadServicesFromDb(shelterId);
            }
        }, shelterId);
    }

    private void loadServicesFromDb(int shelterId) {
        questionDbDataSource.loadServices(new QuestionsDataSource.GetQuestionsCallback() {
            @Override
            public void onQuestionsLoaded(List<Service> shelterList) {
                ((GetServices)  baseUseCase).onServicesSuccess(shelterList);
            }

            @Override
            public void onQuestionsNotAvailable(Object object) {
                baseUseCase.onDataFailure(object);
            }
        }, shelterId);
    }

    private void saveServiceToLocalStorage(List<Service> services, int shelterId) {
        questionDbDataSource.saveServices(services, shelterId);
    }

    @Override
    public void postAnswers(final int shelterId, final Questionnaire questionnaire) {
        long time = System.currentTimeMillis() / 1000L;
        questionnaire.setTime(time);
        questionRestDataSource.postAnswers(new QuestionsDataSource.GetAnswersCallback() {
            @Override
            public void onQuestionAnswersSuccess(String message) {
                ((PostAnswers) baseUseCase).onQuestionsAnswersSuccess(message, shelterId);
            }

            @Override
            public void onQuestionAnswersFailure(Object object) {
                baseUseCase.onDataFailure(object);
                saveAnswersToLocalStorage(shelterId, questionnaire);
            }
        }, shelterId, questionnaire);
    }

    public void postPendingAnswers(final int shelterId, final Questionnaire questionnaire) {
        questionRestDataSource.postAnswers(new QuestionsDataSource.GetAnswersCallback() {
            @Override
            public void onQuestionAnswersSuccess(String message) {
                ((QuestionsDbDataSource) questionDbDataSource).deleteQuestionnaireResolvedDb(questionnaire.getTime());
                ((PostAnswers) baseUseCase).onQuestionsAnswersSuccess(message, shelterId);
            }

            @Override
            public void onQuestionAnswersFailure(Object object) {
                baseUseCase.onDataFailure(object);
            }
        }, shelterId, questionnaire);
    }


    @Override
    public void postPendingAnswers() {
        HashMap<Questionnaire, Integer> sendAnswerBodies = ((QuestionsDbDataSource) questionDbDataSource).retrieveSavedAnswers();
        Iterator it = sendAnswerBodies.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry pair = (Map.Entry) it.next();
            postPendingAnswers((Integer) pair.getValue(), (Questionnaire) pair.getKey());
            it.remove();
        }
    }

    @Override
    public void getPendingForms() {
        HashMap<Questionnaire, Integer> sendAnswerBodies = ((QuestionsDbDataSource) questionDbDataSource).retrieveSavedAnswers();
        ((PendingFormsUseCase) baseUseCase).getPendingForms(PendingFormHelper.countPendingFormForEachShelter(sendAnswerBodies));
    }

    @Override
    public void isThereAnyPendingFormLeft() {
        ((PendingFormsUseCase) baseUseCase).getAnyPendingForms(((QuestionsDbDataSource) questionDbDataSource).areThereAnySavedAnswersLeft());
    }

    private void saveAnswersToLocalStorage(int shelterId, Questionnaire questionnaire) {
        questionDbDataSource.saveAnswers(shelterId, questionnaire);
    }


}
