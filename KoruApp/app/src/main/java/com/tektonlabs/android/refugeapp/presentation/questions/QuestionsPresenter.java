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

package com.tektonlabs.android.refugeapp.presentation.questions;

import com.tektonlabs.android.refugeapp.data.network.models.Questionnaire;
import com.tektonlabs.android.refugeapp.data.usecase.PostAnswers;
import com.tektonlabs.android.refugeapp.presentation.questions.callbacks.AnsweredQuestionsDataResponse;
import com.tektonlabs.android.refugeapp.presentation.questions.callbacks.QuestionsViewContract;

public class QuestionsPresenter implements QuestionsViewContract.UserActionsListener, AnsweredQuestionsDataResponse {


    private QuestionsViewContract.View view;
    private PostAnswers postAnswers;

    public QuestionsPresenter(QuestionsViewContract.View view) {
        this.view = view;
        postAnswers = new PostAnswers(this);
    }

    @Override
    public void postAnswers(int shelterId, Questionnaire questionnaire) {
        postAnswers.postAnswers(shelterId, questionnaire);
    }

    @Override
    public void onQuestionsAnsweredSuccess(Object object, int shelterId) {
        view.setAnswersSuccess(object);
    }

    @Override
    public void onQuestionsAnsweredFailure(Object object) {
        view.setAnswersFailure(object);
    }
}
