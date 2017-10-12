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

package com.tektonlabs.android.refugeapp.presentation.categories;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.tektonlabs.android.refugeapp.R;
import com.tektonlabs.android.refugeapp.data.network.models.Service;

import java.util.ArrayList;
import java.util.List;

public class CategoriesAdapter extends RecyclerView.Adapter<CategoryViewHolder> {

    private List<Service> serviceList = new ArrayList<>();
    private CategoryViewHolder.CategoryListener categoryListener;
    private Context context;

    public CategoriesAdapter(CategoryViewHolder.CategoryListener categoryListener) {
        this.categoryListener = categoryListener;
    }

    @Override
    public CategoryViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        int layout = R.layout.category_row;
        context = parent.getContext();
        View view = LayoutInflater.from(context).inflate(layout, parent, false);
        return new CategoryViewHolder(view, categoryListener);
    }

    @Override
    public void onBindViewHolder(CategoryViewHolder holder, int position) {
        Service service = serviceList.get(position);

        holder.tv_category.setText(service.getName());
        holder.category_container.setBackground(service.isSelected() ? ContextCompat.getDrawable(context, R.drawable.round_shape_selected) : ContextCompat.getDrawable(context, R.drawable.round_shape));

        Drawable drawable;

        switch (service.getId()){
            case 1:
                drawable = ContextCompat.getDrawable(context,R.drawable.cutlery);
                break;
            case 2:
                drawable = ContextCompat.getDrawable(context,R.drawable.hospital);
                break;
            case 3:
                drawable = ContextCompat.getDrawable(context,R.drawable.shower);
                break;
            case 4:
                drawable = ContextCompat.getDrawable(context,R.drawable.mop);
                break;
            case 5:
                drawable = ContextCompat.getDrawable(context,R.drawable.light_bulb);
                break;
            case 6:
                drawable = ContextCompat.getDrawable(context,R.drawable.water_drop);
                break;
            case 7:
                drawable = ContextCompat.getDrawable(context,R.drawable.trash);
                break;
            case 8:
                drawable = ContextCompat.getDrawable(context,R.drawable.policeman);
                break;
            default:
                drawable = ContextCompat.getDrawable(context,android.R.drawable.ic_delete);
                break;
        }

        holder.iv_category.setImageDrawable(drawable);

    }

    @Override
    public int getItemCount() {
        return serviceList.size();
    }

    public void setData(List<Service> services) {
        serviceList.clear();
        serviceList.addAll(services);
        notifyDataSetChanged();
    }

    public void setSelected(int position) {
        boolean currentSelection = serviceList.get(position).isSelected();
        serviceList.get(position).setSelected(!currentSelection);
        notifyDataSetChanged();
    }

    public void deselectAll(){
        for (Service service : serviceList){
            service.setSelected(false);
            notifyDataSetChanged();
        }
    }

    public boolean atLeastOneSelected() {
        for (Service service : serviceList) {
            if (service.isSelected()) {
                return true;
            }
        }
        return false;
    }

    public void selectAllServices() {
        for (Service service : serviceList) {
            service.setSelected(true);
        }
        notifyDataSetChanged();
    }

    public ArrayList<Service> getAllSelectedServices() {
        ArrayList<Service> services = new ArrayList<>();
        for (Service service : serviceList) {
            if (service.isSelected()) {
                services.add(service);
            }
        }
        return services;
    }
}
