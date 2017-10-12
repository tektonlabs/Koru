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

package com.tektonlabs.android.refugeapp.data.db.models.resolved;

import java.util.List;
import io.realm.RealmList;
import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey;

public class QuestionnaireResolvedDb extends RealmObject{

    private RealmList<QuestionResolvedDb> questions = null;

    private int shelterId;

    private String dni;

    public String getDni() {
        return dni;
    }

    public void setDni(String dni) {
        this.dni = dni;
    }

    @PrimaryKey
    private Long questionnaireTime;

    public List<QuestionResolvedDb> getQuestions() {
        return questions;
    }

    public void setQuestions(RealmList<QuestionResolvedDb> questions) {
        this.questions = questions;
    }

    public Long getQuestionnaireTime() {
        return questionnaireTime;
    }

    public void setQuestionnaireTime(Long questionnaireTime) {
        this.questionnaireTime = questionnaireTime;
    }

    public int getShelterId() {
        return shelterId;
    }

    public void setShelterId(int shelterId) {
        this.shelterId = shelterId;
    }

}
