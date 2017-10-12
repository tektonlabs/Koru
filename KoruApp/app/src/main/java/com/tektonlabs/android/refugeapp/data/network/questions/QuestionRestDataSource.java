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

package com.tektonlabs.android.refugeapp.data.network.questions;

import com.google.gson.JsonObject;
import com.tektonlabs.android.refugeapp.RefugeApp;
import com.tektonlabs.android.refugeapp.data.callbacks.QuestionsDataSource;
import com.tektonlabs.android.refugeapp.data.network.RequestManager;
import com.tektonlabs.android.refugeapp.data.network.Services;
import com.tektonlabs.android.refugeapp.data.network.models.ApiErrorBody;
import com.tektonlabs.android.refugeapp.data.network.models.Questionnaire;
import com.tektonlabs.android.refugeapp.data.network.models.QuestionnaireToSend;
import com.tektonlabs.android.refugeapp.data.network.models.Service;
import com.tektonlabs.android.refugeapp.utils.QuestionsToSendFactory;

import java.lang.annotation.Annotation;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Converter;
import retrofit2.Response;

public class QuestionRestDataSource implements QuestionsDataSource {
    private Services services;


    public QuestionRestDataSource() {
        services = RefugeApp.getInstance().getServices();
    }

    @Override
    public void loadServices(final QuestionsDataSource.GetQuestionsCallback callback, int shelterId) {
        services.getQuestions(shelterId + "").enqueue(new Callback<List<Service>>() {
            @Override
            public void onResponse(Call<List<Service>> call, Response<List<Service>> response) {
                if (response.isSuccessful()) {
                    callback.onQuestionsLoaded(response.body());
                } else {
                    try {
                        Converter<ResponseBody, ApiErrorBody> converter = RequestManager.getRetrofit().responseBodyConverter(ApiErrorBody.class, new Annotation[0]);
                        ApiErrorBody apiErrorBody = converter.convert(response.errorBody());
                        callback.onQuestionsNotAvailable(apiErrorBody);
                    } catch (Exception e) {
                        callback.onQuestionsNotAvailable(e);
                    }
                }
            }

            @Override
            public void onFailure(Call<List<Service>> call, Throwable t) {
                callback.onQuestionsNotAvailable(t);
            }
        });
    }

    @Override
    public void postAnswers(final GetAnswersCallback callback, int shelterId, Questionnaire questionnaire) {
        QuestionnaireToSend questionnaireToSend = new QuestionnaireToSend();
        questionnaireToSend.setTime(questionnaire.getTime());
        questionnaireToSend.setDni(questionnaire.getDni());
        questionnaireToSend.setQuestions(QuestionsToSendFactory.buildQuestionsToSend(questionnaire.getQuestions()));

        services.postSendAnswers(shelterId + "", questionnaireToSend).enqueue(new Callback<JsonObject>() {
            @Override
            public void onResponse(Call<JsonObject> call, Response<JsonObject> response) {
                if (response.isSuccessful()) {
                    callback.onQuestionAnswersSuccess(response.message());
                } else {
                    try {
                        Converter<ResponseBody, ApiErrorBody> converter = RequestManager.getRetrofit().responseBodyConverter(ApiErrorBody.class, new Annotation[0]);
                        ApiErrorBody apiErrorBody = converter.convert(response.errorBody());
                        callback.onQuestionAnswersFailure(apiErrorBody);
                    } catch (Exception e) {
                        callback.onQuestionAnswersFailure(e);
                    }
                }
            }

            @Override
            public void onFailure(Call<JsonObject> call, Throwable t) {
                callback.onQuestionAnswersFailure(t);
            }
        });
    }

    @Override
    public void saveServices(List<Service> services, int shelterId) {
        /*
         * Only for Local DB
         */
    }

    @Override
    public void saveAnswers(int shelterId, Questionnaire questionnaire) {
        /*
         * Only for Local DB
         */
    }

}
