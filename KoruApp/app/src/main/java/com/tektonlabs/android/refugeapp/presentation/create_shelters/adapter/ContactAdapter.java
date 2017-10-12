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

import android.support.v7.widget.CardView;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.tektonlabs.android.refugeapp.R;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.Contact;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

public class ContactAdapter extends RecyclerView.Adapter<ContactAdapter.MyHolder> {

    private List<Contact> data = new ArrayList<>();
    private OnCardClickListener listener;
    private OnRemoveCardListener removeListener;

    public ContactAdapter(OnCardClickListener listener, OnRemoveCardListener removeListener) {
        this.listener = listener;
        this.removeListener = removeListener;
    }

    public void addContact(Contact contact) {
        data.add(contact);
        notifyDataSetChanged();
    }

    public void updateContact(Contact contact, int position){
        data.set(position,contact);
        notifyDataSetChanged();
    }

    public List<Contact> getData() {
        return data;
    }

    @Override
    public MyHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.contact_row, parent, false);
        return new ContactAdapter.MyHolder(view,listener,removeListener);
    }

    @Override
    public void onBindViewHolder(final MyHolder holder, int position) {
        holder.tv_primary_name.setText(data.get(position).getName());
        holder.tv_primary_phone.setText(data.get(position).getPhone());
        holder.tv_primary_mail.setText(data.get(position).getEmail());
    }

    @Override
    public int getItemCount() {
        return data.size();
    }

    public class MyHolder extends RecyclerView.ViewHolder {

        @BindView(R.id.tv_primary_name)
        TextView tv_primary_name;
        @BindView(R.id.tv_primary_phone)
        TextView tv_primary_phone;
        @BindView(R.id.tv_primary_mail)
        TextView tv_primary_mail;
        @BindView(R.id.iv_remove)
        ImageView iv_remove;
        @BindView(R.id.cv_container)
        CardView cv_container;

        public MyHolder(View itemView, final OnCardClickListener listener, final OnRemoveCardListener removeListener) {
            super(itemView);
            ButterKnife.bind(this,itemView);
            cv_container.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    listener.EditSecondaryContactClick(getLayoutPosition());
                }
            });

            iv_remove.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    removeListener.removeSecondaryClick(getLayoutPosition());
                    data.remove(getLayoutPosition());
                    notifyItemRemoved(getLayoutPosition());
                }
            });
        }
    }

    public interface OnRemoveCardListener{
        void removeSecondaryClick(int position);
    }

    public interface OnCardClickListener{
        void EditSecondaryContactClick(int position);
    }
}
