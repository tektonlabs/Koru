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

package com.tektonlabs.android.refugeapp.presentation;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.widget.Button;
import com.tektonlabs.android.refugeapp.R;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class MainScreenActivity extends AppCompatActivity {

    @BindView(R.id.bt_register)
    Button bt_register;

    @BindView(R.id.bt_monitor)
    Button bt_monitor;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_screen);
        ButterKnife.bind(this);
    }

    @OnClick(R.id.bt_register)
    public void bt_register() {
        Intent intent = new Intent(this, RegisterActivity.class);
        startActivity(intent);
    }

    @OnClick(R.id.bt_monitor)
    public void bt_monitor() {
        Intent intent = new Intent(this, MonitorActivity.class);
        startActivity(intent);
    }

}
