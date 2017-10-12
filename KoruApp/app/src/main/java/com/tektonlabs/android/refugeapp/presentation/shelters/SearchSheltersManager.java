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

package com.tektonlabs.android.refugeapp.presentation.shelters;

import android.support.v7.widget.SearchView;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import com.tektonlabs.android.refugeapp.R;

import java.util.Timer;
import java.util.TimerTask;

public class SearchSheltersManager implements SearchView.OnQueryTextListener {

    private SearchView searchView;
    private ShelterPresenter shelterPresenter;
    private String lastSearch = "";
    private Timer timer = new Timer();
    private final long DELAY = 500; // milliseconds

    public SearchSheltersManager(final SearchView searchView, ShelterPresenter shelterPresenter) {
        this.searchView = searchView;
        this.shelterPresenter = shelterPresenter;
        // Get the search close button image view
        ImageView closeButton = (ImageView)searchView.findViewById(R.id.search_close_btn);
        closeButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                EditText et = (EditText) searchView.findViewById(R.id.search_src_text);
                et.setText("");
                lastSearch = "";
            }
        });

    }

    @Override
    public boolean onQueryTextSubmit(String s) {
        if (!s.isEmpty()) {
            searchView.clearFocus();
            shelterPresenter.searchShelters(s);
            lastSearch = s;
        }
        return true;
    }

    @Override
    public boolean onQueryTextChange(final String s) {
        if (!s.isEmpty()) {
            timer.cancel();
            timer = new Timer();
            timer.schedule(
                    new TimerTask() {
                        @Override
                        public void run() {
                            shelterPresenter.searchShelters(s);
                        }
                    },
                    DELAY
            );
        }
        return false;
    }



    public String getLastSearch() {
        return lastSearch;
    }
}
