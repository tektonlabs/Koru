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

import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import com.tektonlabs.android.refugeapp.presentation.shelters.callbacks.LoadMoreListener;

public class OnScrollSheltersListener extends RecyclerView.OnScrollListener {

    private LinearLayoutManager linearLayoutManager;
    private boolean load;
    private LoadMoreListener loadMoreListener;


    public OnScrollSheltersListener(LinearLayoutManager linearLayoutManager, LoadMoreListener loadMoreListener) {
        this.linearLayoutManager = linearLayoutManager;
        this.loadMoreListener = loadMoreListener;
    }

    @Override
    public void onScrollStateChanged(RecyclerView recyclerView, int newState) {
        super.onScrollStateChanged(recyclerView, newState);
        load = true;
    }

    @Override
    public void onScrolled(RecyclerView recyclerView, int dx, int dy) {

        if (dy > 0) //check for scroll down
        {
            int visibleItemCount = linearLayoutManager.getChildCount();
            int totalItemCount = linearLayoutManager.getItemCount();
            int pastVisiblesItems = linearLayoutManager.findFirstVisibleItemPosition();

            if (load) {
                if ((visibleItemCount + pastVisiblesItems) >= totalItemCount) {
                    load = false;
                    loadMoreListener.loadMoreElements();
                }
            }
        }
    }
}
