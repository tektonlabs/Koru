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

import android.app.Activity;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Canvas;
import android.support.v7.app.AlertDialog;
import android.support.v7.widget.AppCompatEditText;
import android.util.AttributeSet;
import android.view.View;

import com.tektonlabs.android.refugeapp.R;

import java.util.List;

public class ClickToSelectEditText extends AppCompatEditText {

    String[] mListableItems;
    CharSequence mHint;

    OnItemSelectedListener onItemSelectedListener;

    public ClickToSelectEditText(Context context) {
        super(context);

        mHint = getHint();
    }

    public ClickToSelectEditText(Context context, AttributeSet attrs) {
        super(context, attrs);

        mHint = getHint();
    }

    public ClickToSelectEditText(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);

        mHint = getHint();
    }


    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        setFocusable(false);
        setClickable(true);
    }

    public void setItems(String[] items){
        this.mListableItems = items;
        configureOnClickListener();
    }

    public void setItems(List<String> items) {
        this.mListableItems = items.toArray(new String[items.size()]);

        configureOnClickListener();
    }

    private void configureOnClickListener() {
        this.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                if (getContext() instanceof Activity) UIHelper.hideKeyboardActivity((Activity) getContext());
                AlertDialog.Builder builder = new AlertDialog.Builder(view.getContext());
                builder.setTitle(mHint);
                builder.setItems(mListableItems, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int selectedIndex) {
                        setText(mListableItems[selectedIndex]);

                        if (onItemSelectedListener != null) {
                            onItemSelectedListener.onItemSelectedListener(mListableItems[selectedIndex], selectedIndex);
                        }
                    }
                });
                builder.setPositiveButton(R.string.dialog_close_button, null);
                builder.create().show();
            }
        });
    }

    public void setOnItemSelectedListener(OnItemSelectedListener onItemSelectedListener) {
        this.onItemSelectedListener = onItemSelectedListener;
    }

    public interface OnItemSelectedListener {
        void onItemSelectedListener(String item, int selectedIndex);
    }
}
