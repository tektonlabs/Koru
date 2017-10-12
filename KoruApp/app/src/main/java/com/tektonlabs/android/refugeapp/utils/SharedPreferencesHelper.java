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

import android.content.Context;
import android.content.SharedPreferences;

public class SharedPreferencesHelper {

    public static final String REGISTER_DNI = "dni";
    public static final String MONITOR_DNI = "monitor_dni";
    public static final String PHONE = "phone";
    public static final String INSTITUTION = "institution";
    public static final String IS_REGISTER = "is_register";
    private static final String NAME = "refugeapp";

    private static SharedPreferencesHelper self;
    private final SharedPreferences mPreferences;

    private SharedPreferencesHelper(Context context) {
        mPreferences = context.getSharedPreferences(NAME, Context.MODE_PRIVATE);
    }

    public static SharedPreferencesHelper getInstance(Context context) {
        if (self == null) {
            self = new SharedPreferencesHelper(context);
        }

        return self;
    }

    public void setIsRegister(boolean isRegister){
        SharedPreferences.Editor editor = mPreferences.edit();
        editor.putBoolean(IS_REGISTER, isRegister);
        editor.apply();
    }

    public boolean getRegister(){
        return mPreferences.getBoolean(IS_REGISTER, false);
    }

    public boolean saveRegisterDni(String registerDni) {
        SharedPreferences.Editor editor = mPreferences.edit();
        editor.putString(REGISTER_DNI, registerDni);
        return editor.commit();
    }

    public boolean savePhone(String phone) {
        SharedPreferences.Editor editor = mPreferences.edit();
        editor.putString(PHONE, phone);
        return editor.commit();
    }

    public boolean saveInstitution(String institution) {
        SharedPreferences.Editor editor = mPreferences.edit();
        editor.putString(INSTITUTION, institution);
        return editor.commit();
    }

    public boolean saveMonitorDni(String monitorDni){
        SharedPreferences.Editor editor = mPreferences.edit();
        editor.putString(MONITOR_DNI, monitorDni);
        return editor.commit();
    }

    public String getMonitorDni(){
        return mPreferences.getString(MONITOR_DNI, "");
    }

    public String getRegisterDni() {
        return mPreferences.getString(REGISTER_DNI, "");
    }

    public String getPhone() {
        return mPreferences.getString(PHONE, "");
    }

    public String getInstitution() {
        return mPreferences.getString(INSTITUTION, "");
    }

}
