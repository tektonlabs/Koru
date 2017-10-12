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

package com.tektonlabs.android.refugeapp.data.db.models.mappers;

import com.tektonlabs.android.refugeapp.data.db.models.AnswerDb;
import com.tektonlabs.android.refugeapp.data.db.models.CountryDb;
import com.tektonlabs.android.refugeapp.data.db.models.QuestionDb;
import com.tektonlabs.android.refugeapp.data.db.models.resolved.AnswerResolvedDb;
import com.tektonlabs.android.refugeapp.data.db.models.resolved.QuestionResolvedDb;
import com.tektonlabs.android.refugeapp.data.db.models.resolved.QuestionnaireResolvedDb;
import com.tektonlabs.android.refugeapp.data.db.models.ServiceDb;
import com.tektonlabs.android.refugeapp.data.db.models.ShelterDb;
import com.tektonlabs.android.refugeapp.data.network.models.Answer;
import com.tektonlabs.android.refugeapp.data.network.models.Country;
import com.tektonlabs.android.refugeapp.data.network.models.Question;
import com.tektonlabs.android.refugeapp.data.network.models.Questionnaire;
import com.tektonlabs.android.refugeapp.data.network.models.Service;
import com.tektonlabs.android.refugeapp.data.network.models.Shelter;

import java.util.ArrayList;
import java.util.List;

import io.realm.RealmList;


public class NetworkModelsMapper {

    public static List<ShelterDb> sheltersListToSheltersDbList(List<Shelter> shelters) {
        List<ShelterDb> shelterDbs = new ArrayList<>();
        for (Shelter shelter : shelters) {
            shelterDbs.add(shelterToShelterDb(shelter));
        }
        return shelterDbs;
    }

    private static ShelterDb shelterToShelterDb(Shelter shelter) {
        ShelterDb shelterDb = new ShelterDb();
        shelterDb.setId(shelter.getId());
        shelterDb.setAddress(shelter.getAddress());
        shelterDb.setCity(shelter.getCity());
        shelterDb.setCountry(countryToCountryDb(shelter.getCountry()));
        shelterDb.setLatitude(shelter.getLatitude());
        shelterDb.setLongitude(shelter.getLongitude());
        shelterDb.setName(shelter.getName());
        shelterDb.setStatus(shelter.getStatus());
        return shelterDb;
    }


    private static CountryDb countryToCountryDb(Country country) {
        CountryDb countryDb = new CountryDb();
        if (country != null) {
            countryDb.setName(country.getName());
            countryDb.setId(country.getId());
            countryDb.setIso(country.getIso());
        }
        return countryDb;
    }


    public static RealmList<ServiceDb> serviceDbToServiceList(List<Service> services, int shelterId) {
        RealmList<ServiceDb> serviceDbs = new RealmList<>();
        for (Service service : services) {
            serviceDbs.add(serviceToServiceDb(service, shelterId));
        }
        return serviceDbs;
    }


    private static ServiceDb serviceToServiceDb(Service service, int shelterId) {
        ServiceDb serviceDb = new ServiceDb();
        serviceDb.setId(service.getId());
        serviceDb.setLevel(service.getLevel());
        serviceDb.setName(service.getName());
        serviceDb.setShelterId(shelterId);
        serviceDb.setQuestionDbs(questionToQuestionDbList(service.getQuestions(), shelterId));
        return serviceDb;
    }

    private static RealmList<QuestionDb> questionToQuestionDbList(List<Question> questions, int shelterId) {
        RealmList<QuestionDb> questionDbs = new RealmList<>();
        if (questions != null) {
            for (Question question : questions) {
                questionDbs.add(questionToQuestionDb(question, shelterId));
            }
        }
        return questionDbs;
    }

    private static RealmList<QuestionResolvedDb> questionResolveToQuestionResolvedDbList(List<Question> questions, long questionnaireTime) {
        RealmList<QuestionResolvedDb> questionDbs = new RealmList<>();
        if (questions != null) {
            for (Question question : questions) {
                questionDbs.add(questionToQuestionResolvedDb(question, questionnaireTime));
            }
        }
        return questionDbs;
    }


    private static QuestionDb questionToQuestionDb(Question question, int shelterId) {
        QuestionDb questionDb = new QuestionDb();
        questionDb.setServerId(question.getId());
        questionDb.setAnswerDbs(answerToAnswerDbList(question.getAnswers(), shelterId));
        questionDb.setAnswerValue(question.getAnswerValue());
        questionDb.setMax_value(question.getMax_value());
        questionDb.setMin_value(question.getMin_value());
        questionDb.setQuestionType(question.getQuestionType());
        questionDb.setText(question.getText());
        questionDb.setShelterId(shelterId);
        questionDb.setSubQuestionDbs(questionToQuestionDbList(question.getSubQuestions(), shelterId));
        return questionDb;
    }

    private static QuestionResolvedDb questionToQuestionResolvedDb(Question question, long questionnaireTime) {
        QuestionResolvedDb questionDb = new QuestionResolvedDb();
        questionDb.setServerId(question.getId());
        questionDb.setAnswerDbs(answerToAnswerResolvedDbList(question.getAnswers(), questionnaireTime));
        questionDb.setAnswerValue(question.getAnswerValue());
        questionDb.setMax_value(question.getMax_value());
        questionDb.setMin_value(question.getMin_value());
        questionDb.setQuestionType(question.getQuestionType());
        questionDb.setText(question.getText());
        questionDb.setQuestionnaireTime(questionnaireTime);
        questionDb.setSubQuestionDbs(questionResolveToQuestionResolvedDbList(question.getSubQuestions(), questionnaireTime));
        return questionDb;
    }

    private static RealmList<AnswerDb> answerToAnswerDbList(List<Answer> answers, int shelterId) {
        RealmList<AnswerDb> answerDbs = new RealmList<>();
        if (answers != null) {
            for (Answer answer : answers) {
                answerDbs.add(answerToAnswerDb(answer, shelterId));
            }
        }
        return answerDbs;
    }

    private static RealmList<AnswerResolvedDb> answerToAnswerResolvedDbList(List<Answer> answers, long questionnaireTime) {
        RealmList<AnswerResolvedDb> answerDbs = new RealmList<>();
        if (answers != null) {
            for (Answer answer : answers) {
                answerDbs.add(answerToAnswerResolvedDb(answer, questionnaireTime));
            }
        }
        return answerDbs;
    }

    private static AnswerDb answerToAnswerDb(Answer answer, int shelterId) {
        AnswerDb answerDb = new AnswerDb();
        answerDb.setId(answer.getId());
        answerDb.setAnswerValue(answer.getAnswerValue());
        answerDb.setName(answer.getName());
        answerDb.setWithValue(answer.getWithValue());
        answerDb.setSelected(answer.isSelected());
        answerDb.setShelterId(shelterId);
        return answerDb;
    }

    private static AnswerResolvedDb answerToAnswerResolvedDb(Answer answer, long questionnaireTime) {
        AnswerResolvedDb answerDb = new AnswerResolvedDb();
        answerDb.setId(answer.getId());
        answerDb.setAnswerValue(answer.getAnswerValue());
        answerDb.setName(answer.getName());
        answerDb.setWithValue(answer.getWithValue());
        answerDb.setSelected(answer.isSelected());
        answerDb.setQuestionnaireTime(questionnaireTime);
        return answerDb;
    }


    public static QuestionnaireResolvedDb sendBodyAnswerToSendBodyAnswerDb(Questionnaire questionnaire) {
        QuestionnaireResolvedDb questionnaireDb = new QuestionnaireResolvedDb();
        questionnaireDb.setQuestions(questionResolveToQuestionResolvedDbList(questionnaire.getQuestions(), questionnaire.getTime()));
        questionnaireDb.setQuestionnaireTime(questionnaire.getTime());
        questionnaireDb.setDni(questionnaire.getDni());
        return questionnaireDb;
    }

}
