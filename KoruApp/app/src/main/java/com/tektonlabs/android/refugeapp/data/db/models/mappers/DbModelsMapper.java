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
import java.util.HashMap;
import java.util.List;

public class DbModelsMapper {

    public static List<Shelter> sheltersDbToSheltersList(ArrayList<ShelterDb> shelterDbs) {
        List<Shelter> shelters = new ArrayList<>();
        for (ShelterDb shelterDb : shelterDbs) {
            shelters.add(shelterDbToShelter(shelterDb));
        }
        return shelters;
    }


    private static Shelter shelterDbToShelter(ShelterDb shelterDb) {
        Shelter shelter = new Shelter();
        shelter.setId(shelterDb.getId());
        shelter.setAddress(shelterDb.getAddress());
        shelter.setCity(shelterDb.getCity());
        shelter.setCountry(countryDbToCountry(shelterDb.getCountry()));
        shelter.setLatitude(shelterDb.getLatitude());
        shelter.setLongitude(shelterDb.getLongitude());
        shelter.setName(shelterDb.getName());
        shelter.setStatus(shelterDb.getStatus());
        return shelter;
    }

    private static Country countryDbToCountry(CountryDb countryDb){
        Country country = new Country();
        country.setName(countryDb.getName());
        country.setId(country.getId());
        country.setIso(countryDb.getIso());
        return country;
    }

    public static List<Service> serviceDbToServiceList(List<ServiceDb> serviceDbs) {
        List<Service> services = new ArrayList<>();
        for (ServiceDb serviceDb : serviceDbs) {
            services.add(serviceDbToService(serviceDb));
        }
        return services;
    }


    private static Service serviceDbToService(ServiceDb serviceDb) {
        Service service = new Service();
        service.setId(serviceDb.getId());
        service.setLevel(serviceDb.getLevel());
        service.setName(serviceDb.getName());
        service.setQuestions(questionDbToQuestionList(serviceDb.getQuestionDbs()));
        return service;
    }

    private static List<Question> questionDbToQuestionList(List<QuestionDb> questionDbs) {
        List<Question> questions = new ArrayList<>();
        for (QuestionDb questionDb : questionDbs) {
            questions.add(questionDbToQuestion(questionDb));
        }
        return questions;
    }

    private static List<Question> questionResolvedDbToQuestionList(List<QuestionResolvedDb> questionDbs) {
        List<Question> questions = new ArrayList<>();
        for (QuestionResolvedDb questionDb : questionDbs) {
            questions.add(questionDbToQuestion(questionDb));
        }
        return questions;
    }

    private static Question questionDbToQuestion(QuestionDb questionDb) {
        Question question = new Question();
        question.setId(questionDb.getServerId());
        question.setAnswers(answerDbToAnswerList(questionDb.getAnswerDbs()));
        question.setAnswerValue(questionDb.getAnswerValue());
        question.setMax_value(questionDb.getMax_value());
        question.setMin_value(questionDb.getMin_value());
        question.setQuestionType(questionDb.getQuestionType());
        question.setText(questionDb.getText());
        question.setSubQuestions(questionDbToQuestionList(questionDb.getSubQuestionDbs()));
        return question;
    }


    private static Question questionDbToQuestion(QuestionResolvedDb questionDb) {
        Question question = new Question();
        question.setId(questionDb.getServerId());
        question.setAnswers(answerResolvedDbToAnswerList(questionDb.getAnswerDbs()));
        question.setAnswerValue(questionDb.getAnswerValue());
        question.setMax_value(questionDb.getMax_value());
        question.setMin_value(questionDb.getMin_value());
        question.setQuestionType(questionDb.getQuestionType());
        question.setText(questionDb.getText());
        question.setSubQuestions(questionResolvedDbToQuestionList(questionDb.getSubQuestionDbs()));
        return question;
    }

    private static List<Answer> answerDbToAnswerList(List<AnswerDb> answerDbs) {
        List<Answer> answers = new ArrayList<>();
        for (AnswerDb answerDb : answerDbs) {
            answers.add(answerDbToAnswer(answerDb));
        }
        return answers;
    }

    private static List<Answer> answerResolvedDbToAnswerList(List<AnswerResolvedDb> answerDbs) {
        List<Answer> answers = new ArrayList<>();
        for (AnswerResolvedDb answerDb : answerDbs) {
            answers.add(answerDbToAnswer(answerDb));
        }
        return answers;
    }


    private static Answer answerDbToAnswer(AnswerDb answerDb) {
        Answer answer = new Answer();
        answer.setId(answerDb.getId());
        answer.setAnswerValue(answerDb.getAnswerValue());
        answer.setName(answerDb.getName());
        answer.setWithValue(answerDb.getWithValue());
        answer.setSelected(answerDb.isSelected());
        return answer;
    }

    private static Answer answerDbToAnswer(AnswerResolvedDb answerDb) {
        Answer answer = new Answer();
        answer.setId(answerDb.getId());
        answer.setAnswerValue(answerDb.getAnswerValue());
        answer.setName(answerDb.getName());
        answer.setWithValue(answerDb.getWithValue());
        answer.setSelected(answerDb.isSelected());
        return answer;
    }

    public static HashMap<Questionnaire, Integer> sendAnswerBodiesDbToSendAnswerBodies(List<QuestionnaireResolvedDb> questionaryDbs) {
        HashMap<Questionnaire, Integer> hashmapAnswerBodies = new HashMap<>();
        for (QuestionnaireResolvedDb questionnaireResolvedDb : questionaryDbs) {
            hashmapAnswerBodies.put(questionnaireDbToQuestionnaire(questionnaireResolvedDb), questionnaireResolvedDb.getShelterId());
        }
        return hashmapAnswerBodies;
    }

    private static Questionnaire questionnaireDbToQuestionnaire(QuestionnaireResolvedDb questionnaireDb) {
        Questionnaire questionnaire = new Questionnaire();
        questionnaire.setQuestions(questionResolvedDbToQuestionList(questionnaireDb.getQuestions()));
        questionnaire.setTime(questionnaireDb.getQuestionnaireTime());
        questionnaire.setDni(questionnaireDb.getDni());
        return questionnaire;
    }
}
