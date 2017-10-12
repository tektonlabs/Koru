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

package com.tektonlabs.android.refugeapp.data.utils;

import com.tektonlabs.android.refugeapp.data.network.models.Questionnaire;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class PendingFormHelper {
    /***
     * Transforms the hashmap containing all the questionnaires from each shelter,
     * to a shelterId and number of pending questionnaires
     * @param sendAnswerBodies Hashmap containing Questionnaire and the shelter id
     * @return a Hashmap containing the shelterId, and the number of pending forms
     */
    public static HashMap<Integer, Integer> countPendingFormForEachShelter(HashMap<Questionnaire, Integer> sendAnswerBodies) {
        List<Integer> list = new ArrayList<>(sendAnswerBodies.values());
        HashMap<Integer, Integer> counterMap = new HashMap<>();
        for (int i = 0; i < list.size(); i++) {
            if (counterMap.containsKey(list.get(i))) {
                counterMap.put(list.get(i), counterMap.get(list.get(i)) + 1);
            } else {
                counterMap.put(list.get(i), 1);
            }
        }
        return counterMap;
    }
}
