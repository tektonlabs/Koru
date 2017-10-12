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
import android.support.v4.content.ContextCompat;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Spinner;
import android.widget.TextView;
import com.tektonlabs.android.refugeapp.R;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class SpinnerHelper {
    private static ArrayAdapter<String> createAdapter(final Context context, List<String> string_ls) {
        return new ArrayAdapter<String>(context, R.layout.spinner_row, string_ls) {
            @Override
            public View getDropDownView(int position, View convertView,
                                        ViewGroup parent) {
                View view = super.getDropDownView(position, convertView, parent);
                TextView tv = (TextView) view;
                if (position == 0) {
                    tv.setTextColor(ContextCompat.getColor(context, R.color.gray_text));
                } else {
                    tv.setTextColor(ContextCompat.getColor(context, android.R.color.black));
                }
                return view;
            }
        };
    }

    private static void setListenerToSpinner(final Context context, Spinner spinner) {
        spinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                if (i != 0) {
                    if (view instanceof TextView) {
                        ((TextView) view).setTextColor(ContextCompat.getColor(context, android.R.color.black));
                    }
                } else {
                    if (view instanceof TextView) {
                        ((TextView) view).setTextColor(ContextCompat.getColor(context, R.color.hint_color));
                    }
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {

            }
        });
    }

    public static void setDataToSpinner(Context context, String[] array, Spinner spinner) {
        List<String> ls = new ArrayList<>(Arrays.asList(array));
        ArrayAdapter<String> adapter = SpinnerHelper.createAdapter(context, ls);
        spinner.setAdapter(adapter);
        SpinnerHelper.setListenerToSpinner(context, spinner);
    }
}
