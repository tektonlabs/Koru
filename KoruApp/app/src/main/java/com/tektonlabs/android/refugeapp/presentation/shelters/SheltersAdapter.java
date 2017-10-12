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

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import com.tektonlabs.android.refugeapp.R;
import com.tektonlabs.android.refugeapp.data.network.models.Country;
import com.tektonlabs.android.refugeapp.data.network.models.Shelter;
import com.tektonlabs.android.refugeapp.utils.Constants;
import java.util.ArrayList;
import java.util.List;
import butterknife.BindView;
import butterknife.ButterKnife;

public class SheltersAdapter extends RecyclerView.Adapter<SheltersAdapter.SheltersViewHolder> {

    private Context context;
    private List<Shelter> shelterList = new ArrayList<>();
    private SheltersListener sheltersListener;

    SheltersAdapter(Context context, SheltersListener sheltersListener) {
        this.context = context;
        this.sheltersListener = sheltersListener;
    }

    public void setShelterList(List<Shelter> items) {
        if (shelterList.isEmpty()) {
            shelterList.addAll(items);
        } else {
            shelterList.addAll(shelterList.size(), items);
        }
        notifyDataSetChanged();

    }


    void clearAdapterData() {
        shelterList.clear();
    }

    public List<Shelter> getShelterList() {
        return shelterList;
    }

    @Override
    public SheltersViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(context).inflate(R.layout.shelters_row, parent, false);
        return new SheltersViewHolder(view, sheltersListener);
    }

    @Override
    public void onBindViewHolder(SheltersViewHolder holder, int pos) {

        int position = holder.getLayoutPosition();

        Shelter currentShelter = shelterList.get(position);

        holder.tv_shelter_name.setText(currentShelter.getName());

        String address = currentShelter.getAddress();
        if (address != null && !address.isEmpty()) {
            if (currentShelter.getCity() != null && !currentShelter.getCity().isEmpty()) {
                address = address + ", " + currentShelter.getCity();
            }
        } else {
            address = currentShelter.getCity();
        }

        Country country = currentShelter.getCountry();
        if (country != null) {
            if (country.getName() != null && !country.getName().isEmpty()) {
                address = address + ", " + country.getName();
            }
        }
        setImageStatus(currentShelter, holder);
        setPendingForms(currentShelter, holder);
        holder.tv_shelter_address.setText(address);

    }

    private void setPendingForms(Shelter shelter, SheltersViewHolder holder) {
        holder.tv_pending_forms.setVisibility(shelter.getPendingForms() > 0 ? View.VISIBLE : View.GONE);
        String pendingMessage = shelter.getPendingForms() + " " + context.getString(R.string.form_pending);
        holder.tv_pending_forms.setText(pendingMessage);
    }

    private void setImageStatus(Shelter currentShelter, SheltersViewHolder holder) {
        if (currentShelter.getStatus() != null) {
            switch (currentShelter.getStatus()) {
                case Constants.SHELTER_STATUS_GOOD:
                    holder.iv_shelter_status.setImageResource(R.drawable.shelter_status_green);
                    break;
                case Constants.SHELTER_STATUS_BAD:
                    holder.iv_shelter_status.setImageResource(R.drawable.shelter_status_red);
                    break;
                default:
                    holder.iv_shelter_status.setImageResource(R.drawable.shelter_status_yellow);
                    break;
            }
        }
    }

    void reducePendingCount(int shelterId) {
        for (Shelter shelter : shelterList) {
            if (shelter.getId() == shelterId) {
                shelter.setPendingForms(shelter.getPendingForms() - 1);
                notifyItemChanged(shelterList.indexOf(shelter));
            }
        }
    }


    @Override
    public int getItemCount() {
        return shelterList.size();
    }

    static class SheltersViewHolder extends RecyclerView.ViewHolder {
        @BindView(R.id.tv_shelter_name)
        TextView tv_shelter_name;

        @BindView(R.id.tv_shelter_address)
        TextView tv_shelter_address;

        @BindView(R.id.iv_shelter_status)
        ImageView iv_shelter_status;

        @BindView(R.id.cv_shelter)
        LinearLayout cv_shelter;

        @BindView(R.id.tv_pending_forms)
        TextView tv_pending_forms;


        SheltersViewHolder(View itemView, final SheltersListener sheltersListener) {
            super(itemView);
            ButterKnife.bind(this, itemView);
            cv_shelter.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    sheltersListener.onShelterClicked(getLayoutPosition());
                }
            });
        }
    }

    interface SheltersListener {
        void onShelterClicked(int position);
    }
}

