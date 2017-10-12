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

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.widget.Toast;
import com.tektonlabs.android.refugeapp.data.network.models.Answer;
import com.tektonlabs.android.refugeapp.data.network.models.Question;
import java.util.List;

public class Utils {

    private static Toast mainToast;

    public static void showToast(Context context, String message) {
        if (mainToast != null) {
            mainToast.cancel();
        }
        mainToast = Toast.makeText(context, message, Toast.LENGTH_LONG);
        mainToast.show();
    }

    /***
     * Checks if at least one question has been answered
     * @param questions list of questions
     * @return boolean
     */
    public static boolean hasAtLeastOneQuestionAnswered(List<Question> questions) {
        boolean answered = false;

        outerloop:
        for (Question question : questions) {
            if(question.getSubQuestions() != null && !question.getSubQuestions().isEmpty()){
                 boolean r_answered = hasAtLeastOneQuestionAnswered(question.getSubQuestions());
                if (!answered) answered = r_answered;
            }

            if (question.getAnswerValue() != null && !question.getAnswerValue().isEmpty()) {
                answered = true;
                break;
            }
            for (Answer answer : question.getAnswers()) {
                if (answer.isSelected() || answer.getAnswerValue() != null && !answer.getAnswerValue().isEmpty()) {
                    answered = true;
                    break outerloop;
                }
            }
        }
        return  answered;
    }

    public static String shelterTypeToSend(String shelterType){
        switch (shelterType){
            case "Carpas en campo abierto":
                return  "open_tents";
            case "Colegio":
                return "school";
            case "Iglesia":
                return "church";
            case "Otro":
                return "other";
            default: return "";
        }
    }

    public static String organizationToSend(String organization){
        switch (organization){
            case "Gobierno Central":
                return "central_government";
            case "Gobierno Regional":
                return "regional_government";
            case "Iglesia":
                return "church_institution";
            case "Municipalidad":
                return "municipality";
            case "Organización Comunal":
                return "community_organization";
            case "Organización no Gubernamental":
                return "non_governmental_organization";
            case "Otro":
                return "other_institution";
            default: return "";
        }
    }

    public static String emergencyToSend(String emergencyType){
        switch (emergencyType){
            case "Terremoto":
                return "earthquake";
            case "Friaje/helada":
                return "cold_frosty";
            case "Huayco/desborde de río":
                return "landslide_overflow_river";
            case "Emergencia sanitaria":
                return "health_emergency";
            case "Incendio":
                return "fire";
            default: return "";
        }
    }

    public static String propertyToSend(String property_type){
        switch (property_type){
            case "Propiedad Privada":
                return "private_property";
            case "Propiedad Pública":
                return "public_property";
            case "Vía Pública":
                return "highways";
            default: return "";
        }
    }

    public static String accessibilityToSend(String accessibility){
        switch (accessibility){
            case "A pie":
                return "on_foot";
            case "Solo 4x4":
                return "only_4x4";
            case "Vehicular":
                return "vehicular";
            default: return "";
        }
    }

    public static String victimcsToSend(String victims){
        switch (victims){
            case "De una misma comunidad":
                return "same_community";
            case "De diferentes comunidades":
                return "different_communities";
            default: return "";
        }
    }

    public static String floorToSend(String floor){
        switch (floor){
            case "Asfaltado":
                return "asphalted";
            case "No asfaltado":
                return "unpaved";
            default: return "";
        }
    }

    public static String roofToSend(String roof){
        switch (roof){
            case "Al aire libre":
                return "outdoors";
            case "Techado":
                return "roofing";
            default: return "";
        }
    }

    public static boolean hasInternetConnection(Context context){
        ConnectivityManager cm = (ConnectivityManager) context
                .getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo netInfo = cm.getActiveNetworkInfo();

        if (netInfo != null && netInfo.isConnectedOrConnecting()) {
            return true;
        }

        return false;
    }
}
