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

import java.io.Serializable;
import java.util.List;

public class Question implements Serializable{

    @SerializedName("id")
    @Expose
    private Integer id;

    @SerializedName("text")
    @Expose
    private String text;

    @SerializedName("answers")
    @Expose
    private List<Answer> answers = null;

    @SerializedName("question_type")
    @Expose
    private String questionType;

    @SerializedName("min_value")
    @Expose
    private String min_value;

    @SerializedName("max_value")
    @Expose
    private String max_value;

    @SerializedName("sub_questions")
    @Expose
    private List<Question> subQuestions = null;

    @SerializedName("service")
    @Expose
    private String serviceName = null;
    private String answerValue = null;

    private boolean empty = true;

    public boolean isEmpty() {
        return empty;
    }

    public void setEmpty(boolean empty) {
        this.empty = empty;
    }

    public void setSelectedAnswer(Answer selectedAnswer) {
        for (int i = 0; i < answers.size(); i++) {
            Answer answer = answers.get(i);
            if (answers.get(i).getId() == selectedAnswer.getId()) {
                answer.setSelected(true);
                answers.set(i, answer);
            } else {
                answer.setSelected(false);
                answers.set(i, answer);
            }
        }
    }

    public void addSelectedAnswer(Answer selectedAnswer) {
        for (int i = 0; i < answers.size(); i++) {
            if (answers.get(i).getId() == selectedAnswer.getId()) {
                Answer answer = answers.get(i);
                answer.setSelected(true);
                answers.set(i, answer);
            }
        }
    }

    public void removeFromSelectedAnswers(Answer answerRemoved) {
        for (int i = 0; i < answers.size(); i++) {
            if (answers.get(i).getId() == answerRemoved.getId()) {
                Answer answer = answers.get(i);
                answer.setSelected(false);
                answers.set(i, answer);
            }
        }
    }

    public String getAnswerValue() {
        return answerValue;
    }

    public void setAnswerValue(String answerValue) {
        this.answerValue = answerValue;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public List<Answer> getAnswers() {
        return answers;
    }

    public void setAnswers(List<Answer> answers) {
        this.answers = answers;
    }

    public String getQuestionType() {
        return questionType;
    }

    public void setQuestionType(String questionType) {
        this.questionType = questionType;
    }

    public List<Question> getSubQuestions() {
        return subQuestions;
    }

    public void setSubQuestions(List<Question> subQuestions) {
        this.subQuestions = subQuestions;
    }

    public String getMax_value() {
        return max_value;
    }

    public void setMax_value(String max_value) {
        this.max_value = max_value;
    }

    public String getMin_value() {
        return min_value;
    }

    public void setMin_value(String min_value) {
        this.min_value = min_value;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }
}
