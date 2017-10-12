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

package com.tektonlabs.android.refugeapp.utils;

import com.tektonlabs.android.refugeapp.data.network.models.Answer;
import com.tektonlabs.android.refugeapp.data.network.models.AnswerToSend;
import com.tektonlabs.android.refugeapp.data.network.models.Question;
import com.tektonlabs.android.refugeapp.data.network.models.QuestionToSend;
import java.util.ArrayList;
import java.util.List;

public class QuestionsToSendFactory {
    /***
     * Builds a data structure to be send to the end point
     *
     * @param questions the list of question shown to the user
     * @return The list of questions to be send to the endpoint
     */
    public static List<QuestionToSend> buildQuestionsToSend(List<Question> questions) {
        List<QuestionToSend> questionsToSend = new ArrayList<QuestionToSend>();
        for (Question question1 : questions) {
            QuestionToSend questionToSend = new QuestionToSend(question1);

            if (question1.getSubQuestions() != null && !question1.getSubQuestions().isEmpty()) {
                questionToSend.setSubQuestions(buildQuestionsToSend(question1.getSubQuestions()));
            } else {
                setAnswerToSend(question1,questionToSend);
            }

            questionsToSend.add(questionToSend);
        }
        return questionsToSend;
    }

    public static void setAnswerToSend(Question question, QuestionToSend questionToSend){
        List<AnswerToSend> answersToSend = new ArrayList<AnswerToSend>();
        if (question.getAnswers() != null && !question.getAnswers().isEmpty()) {
            for (Answer answer : question.getAnswers()) {
                if (answer.isSelected()) {
                    AnswerToSend answerToSend = new AnswerToSend(answer);
                    answersToSend.add(answerToSend);
                }
            }
            questionToSend.setAnswers(answersToSend);
        } else {
            AnswerToSend answerToSend = new AnswerToSend(question.getAnswerValue());
            answersToSend.add(answerToSend);
            questionToSend.setAnswers(answersToSend);
        }
    }
}