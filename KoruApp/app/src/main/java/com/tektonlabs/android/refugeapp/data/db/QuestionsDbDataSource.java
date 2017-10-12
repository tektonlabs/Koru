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

package com.tektonlabs.android.refugeapp.data.db;

import android.util.Log;
import com.tektonlabs.android.refugeapp.data.callbacks.QuestionsDataSource;
import com.tektonlabs.android.refugeapp.data.db.models.AnswerDb;
import com.tektonlabs.android.refugeapp.data.db.models.QuestionDb;
import com.tektonlabs.android.refugeapp.data.db.models.QuestionnaireDb;
import com.tektonlabs.android.refugeapp.data.db.models.ServiceDb;
import com.tektonlabs.android.refugeapp.data.db.models.mappers.DbModelsMapper;
import com.tektonlabs.android.refugeapp.data.db.models.mappers.NetworkModelsMapper;
import com.tektonlabs.android.refugeapp.data.db.models.resolved.AnswerResolvedDb;
import com.tektonlabs.android.refugeapp.data.db.models.resolved.QuestionResolvedDb;
import com.tektonlabs.android.refugeapp.data.db.models.resolved.QuestionnaireResolvedDb;
import com.tektonlabs.android.refugeapp.data.network.models.Questionnaire;
import com.tektonlabs.android.refugeapp.data.network.models.Service;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import io.realm.Realm;
import io.realm.RealmList;
import io.realm.RealmResults;
import io.realm.Sort;

public class QuestionsDbDataSource implements QuestionsDataSource {


    public QuestionsDbDataSource() {
    }

    @Override
    public void loadServices(GetQuestionsCallback callback, int shelterId) {
        final Realm realm = Realm.getDefaultInstance();
        RealmResults<QuestionnaireDb> result = realm.where(QuestionnaireDb.class).equalTo("id", shelterId).findAll();
        if (result.size() > 0) {
            List<Service> services = DbModelsMapper.serviceDbToServiceList(new ArrayList<>(result.get(0).getServiceDbList()));
            callback.onQuestionsLoaded(services);
        } else {
            callback.onQuestionsNotAvailable("Data not available");
        }
        realm.close();
    }

    @Override
    public void postAnswers(GetAnswersCallback callback, int shelterId, Questionnaire questionnaire) {
        /*
         * Only for REST
         */
    }

    @Override
    public void saveServices(final List<Service> services, final int shelterId) {
        final RealmList<ServiceDb> serviceDbs = NetworkModelsMapper.serviceDbToServiceList(services, shelterId);
        final Realm realm = Realm.getDefaultInstance();

        final QuestionnaireDb questionnaireDb = new QuestionnaireDb();
        questionnaireDb.setId(shelterId);
        questionnaireDb.setServiceDbList(serviceDbs);
        realm.executeTransaction(new Realm.Transaction() {
            @Override
            public void execute(Realm realm) {
                deleteServiceDbContainer(realm, shelterId);
                realm.copyToRealmOrUpdate(questionnaireDb);
            }
        });
    }

    private void deleteServiceDbContainer(Realm realm, int shelterId) throws IllegalStateException {
        RealmResults<QuestionnaireDb> result = realm.where(QuestionnaireDb.class).equalTo("id", shelterId).findAll();
        result.deleteAllFromRealm();

        RealmResults<AnswerDb> answerDbRealmResults = realm.where(AnswerDb.class).equalTo("shelterId", shelterId).findAll();
        answerDbRealmResults.deleteAllFromRealm();

        RealmResults<QuestionDb> questionDbRealmResults = realm.where(QuestionDb.class).equalTo("shelterId", shelterId).findAll();
        questionDbRealmResults.deleteAllFromRealm();

        RealmResults<ServiceDb> serviceDbRealmResults = realm.where(ServiceDb.class).equalTo("shelterId", shelterId).findAll();
        serviceDbRealmResults.deleteAllFromRealm();
    }

    @Override
    public void saveAnswers(final int shelterId, final Questionnaire questionnaire) {
        final Realm realm = Realm.getDefaultInstance();
        final QuestionnaireResolvedDb questionnaireDb = NetworkModelsMapper.sendBodyAnswerToSendBodyAnswerDb(questionnaire);
        questionnaireDb.setShelterId(shelterId);
        realm.executeTransactionAsync(new Realm.Transaction() {
            @Override
            public void execute(Realm realm) {
                realm.copyToRealm(questionnaireDb);
            }
        }, new Realm.Transaction.OnSuccess() {
            @Override
            public void onSuccess() {
                realm.close();
            }
        }, new Realm.Transaction.OnError() {
            @Override
            public void onError(Throwable error) {
                Log.d("Debug", "onError " + error.toString());
                realm.close();
            }
        });
    }


    public void deleteQuestionnaireResolvedDb(final long questionnaireTime) {
        final Realm realm = Realm.getDefaultInstance();
        realm.executeTransaction(new Realm.Transaction() {
            @Override
            public void execute(Realm realm) {
                deleteSavedAndResolvedQuestionnaire(realm, questionnaireTime);
            }
        });
    }

    private void deleteSavedAndResolvedQuestionnaire(Realm realm, long questionnaireTime) {
        RealmResults<QuestionnaireResolvedDb> result = realm.where(QuestionnaireResolvedDb.class).equalTo("questionnaireTime", questionnaireTime).findAll();
        result.deleteAllFromRealm();

        RealmResults<AnswerResolvedDb> answerDbRealmResults = realm.where(AnswerResolvedDb.class).equalTo("questionnaireTime", questionnaireTime).findAll();
        answerDbRealmResults.deleteAllFromRealm();

        RealmResults<QuestionResolvedDb> questionDbRealmResults = realm.where(QuestionResolvedDb.class).equalTo("questionnaireTime", questionnaireTime).findAll();
        questionDbRealmResults.deleteAllFromRealm();

    }

    public HashMap<Questionnaire, Integer> retrieveSavedAnswers() {
        final Realm realm = Realm.getDefaultInstance();
        HashMap<Questionnaire, Integer> sendAnswerBodies;
        RealmResults<QuestionnaireResolvedDb> results =
                realm.where(QuestionnaireResolvedDb.class)
                        .findAllSorted("questionnaireTime" +
                                "", Sort.DESCENDING);
        List<QuestionnaireResolvedDb> questionnaireDbs = realm.copyFromRealm(results);
        sendAnswerBodies = DbModelsMapper.sendAnswerBodiesDbToSendAnswerBodies(questionnaireDbs);
        realm.close();
        return sendAnswerBodies;
    }

    public boolean areThereAnySavedAnswersLeft() {
        final Realm realm = Realm.getDefaultInstance();
        RealmResults<QuestionnaireResolvedDb> results =
                realm.where(QuestionnaireResolvedDb.class)
                        .findAll();
        if (results.size() > 0) {
            realm.close();
            return true;
        } else {
            realm.close();
            return false;
        }
    }
}
