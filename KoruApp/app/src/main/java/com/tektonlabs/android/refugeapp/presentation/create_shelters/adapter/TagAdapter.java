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
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;

import com.tektonlabs.android.refugeapp.R;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.TagModel;

import java.util.ArrayList;
import java.util.List;

public class TagAdapter extends RecyclerView.Adapter<TagHolder> implements TagHolder.OnTagsListener {

    private List<TagModel> data;
    private Context context;
    private RecyclerView rv_tags;
    private OnTextChangedListener onTextChanged;
    private int current_position;

    public TagAdapter(List<TagModel> data, RecyclerView rv_tags,OnTextChangedListener onTextChanged) {
        this.data = data;
        this.rv_tags = rv_tags;
        this.onTextChanged = onTextChanged;
    }

    @Override
    public TagHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        this.context = parent.getContext();
        View view = LayoutInflater.from(context).inflate(R.layout.tag_row, parent, false);
        return new TagHolder(view,this,context);
    }

    @Override
    public void onBindViewHolder(final TagHolder holder, final int position) {
        if(holder.getAdapterPosition() == data.size() - 1){
            holder.et_service.requestFocus();
        }
        if(holder.getAdapterPosition() == 4){
            holder.iv_add_tag.setVisibility(View.GONE);
            holder.iv_delete_tag.setVisibility(View.VISIBLE);
        }else{
            holder.iv_add_tag.setVisibility(holder.getAdapterPosition() == data.size() - 1 ? View.VISIBLE : View.GONE);
            holder.iv_delete_tag.setVisibility(holder.getAdapterPosition() == data.size() - 1 ? View.GONE : View.VISIBLE);
        }
        holder.et_service.setText(data.get(holder.getAdapterPosition()).getTagTitle());
        holder.et_service.setThreshold(1);
        holder.et_service.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                data.get(holder.getAdapterPosition()).setTagTitle(charSequence.toString());
                current_position = position;
            }

            @Override
            public void afterTextChanged(Editable s) {
                if(s.length() != 0 && s.length() % 3== 0){
                    onTextChanged.onTextChanged(s.toString());
                }
            }
        });
    }

    public void setDataToHolderAdapter(List<String> data){
        ArrayAdapter<String> adapter = new ArrayAdapter<>(context,
            android.R.layout.simple_list_item_1,data );
        ((TagHolder) rv_tags.findViewHolderForAdapterPosition(current_position)).et_service.setAdapter(adapter);
    }

    @Override
    public int getItemCount() {
        return data.size();
    }

    public ArrayList<String> getData() {
        ArrayList<String> services = new ArrayList<>();
        for (TagModel t : data){
            services.add(t.getTagTitle());
        }
        return services;
    }

    @Override
    public void onDeleteTagClicked(int position) {
        if(position < data.size()){
            data.remove(position);
            notifyDataSetChanged();
        }
    }

    @Override
    public void onAddTagClicked(int position) {
        if(position < 4){
            data.add(new TagModel());
            notifyDataSetChanged();
            rv_tags.scrollToPosition(data.size()-1);
        }
    }

    public interface OnTextChangedListener{
        void onTextChanged(String query);
    }
}
