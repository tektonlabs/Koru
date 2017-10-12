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
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.TextView;

import com.tektonlabs.android.refugeapp.R;
import com.tektonlabs.android.refugeapp.data.network.models.create_shelter.shelter_data.MultipleChoice;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

public class CreateShelterMultipleChoiceAdapter extends RecyclerView.Adapter<CreateShelterMultipleChoiceAdapter.MyHolder> {

    private List<MultipleChoice> data;
    private Context context;

    public CreateShelterMultipleChoiceAdapter(List<MultipleChoice> data) {
        this.data = data;
    }

    public List<MultipleChoice> getData() {
        return data;
    }

    @Override
    public MyHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        this.context = parent.getContext();
        View view = LayoutInflater.from(context).inflate(R.layout.new_shelter_checkbox_row, parent, false);
        return new CreateShelterMultipleChoiceAdapter.MyHolder(view);
    }

    @Override
    public void onBindViewHolder(MyHolder holder, final int position) {
        holder.tv_option.setText(data.get(position).getName());
        holder.cb_option.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                data.get(position).setSelected(!data.get(position).isSelected());
            }
        });
    }

    @Override
    public int getItemCount() {
        return data.size();
    }


    public ArrayList<String> getSelectedData() {
        ArrayList<String> selectedData = new ArrayList<>();
        for (MultipleChoice multipleChoice : data) {
            if (multipleChoice.isSelected()) {
                selectedData.add(String.valueOf(multipleChoice.getId()));
            }
        }
        return selectedData;
    }

    public class MyHolder extends RecyclerView.ViewHolder {

        @BindView(R.id.tv_option)
        TextView tv_option;

        @BindView(R.id.cb_option)
        CheckBox cb_option;

        public MyHolder(View itemView) {
            super(itemView);
            ButterKnife.bind(this, itemView);
            tv_option.setTextColor(ContextCompat.getColor(context, android.R.color.black));
        }
    }

}
