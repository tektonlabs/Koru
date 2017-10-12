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

package com.tektonlabs.android.refugeapp.presentation.create_shelters.adapter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.ImageView;

import com.tektonlabs.android.refugeapp.R;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

public class TagHolder extends RecyclerView.ViewHolder {

    AutoCompleteTextView et_service;
    ImageView iv_add_tag;
    ImageView iv_delete_tag;
    Context context;

    public TagHolder(View itemView, final OnTagsListener onTagsListener, Context context) {
        super(itemView);
        this.context = context;
        et_service = (AutoCompleteTextView) itemView.findViewById(R.id.et_service);
        iv_add_tag = (ImageView) itemView.findViewById(R.id.iv_add_tag);
        iv_delete_tag = (ImageView) itemView.findViewById(R.id.iv_delete_tag);

        iv_delete_tag.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                onTagsListener.onDeleteTagClicked(getLayoutPosition());
            }
        });

        iv_add_tag.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                onTagsListener.onAddTagClicked(getLayoutPosition());
            }
        });
    }

    interface OnTagsListener {
        void onDeleteTagClicked(int position);

        void onAddTagClicked(int position);
    }
}

