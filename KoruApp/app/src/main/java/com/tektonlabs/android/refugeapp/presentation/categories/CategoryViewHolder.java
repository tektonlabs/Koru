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

import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TextView;

import com.tektonlabs.android.refugeapp.R;

import butterknife.BindView;
import butterknife.ButterKnife;

public class CategoryViewHolder extends RecyclerView.ViewHolder {
    @BindView(R.id.tv_category)
    TextView tv_category;
    @BindView(R.id.iv_category)
    ImageView iv_category;

    @BindView(R.id.category_container)
    FrameLayout category_container;

    public CategoryViewHolder(View itemView, final CategoryListener categoryListener) {
        super(itemView);
        ButterKnife.bind(this, itemView);
        category_container.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                categoryListener.OnCategoryClicked(getLayoutPosition());
            }
        });
    }

    public interface CategoryListener {
        void OnCategoryClicked(int position);
    }
}
