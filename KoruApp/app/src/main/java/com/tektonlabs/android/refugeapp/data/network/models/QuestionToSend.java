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

package com.tektonlabs.android.refugeapp.data.network.models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

import io.realm.RealmObject;

public class QuestionToSend  {

    @SerializedName("id")
    @Expose
    private Integer id;

    @SerializedName("answers")
    @Expose
    private List<AnswerToSend> answers = null;

    @SerializedName("question_type")
    @Expose
    private String questionType;

    @SerializedName("sub_questions")
    @Expose
    private List<QuestionToSend> subQuestions = null;


    private void addAnswer(AnswerToSend answer){
        if(answers == null){
            answers = new ArrayList<>();
        }
        answers.add(answer);
    }

    private void addSubquestion(QuestionToSend subQuestion){
        if(subQuestions == null){
            subQuestions = new ArrayList<>();
        }
        subQuestions.add(subQuestion);
    }

    public List<AnswerToSend> getAnswers() {
        return answers;
    }

    public void setAnswers(List<AnswerToSend> answers) {
        this.answers = answers;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getQuestionType() {
        return questionType;
    }

    public void setQuestionType(String questionType) {
        this.questionType = questionType;
    }

    public List<QuestionToSend> getSubQuestions() {
        return subQuestions;
    }

    public void setSubQuestions(List<QuestionToSend> subQuestions) {
        this.subQuestions = subQuestions;
    }


    public QuestionToSend(Question question) {
        this.id = question.getId();
        this.questionType = question.getQuestionType();
    }
}
