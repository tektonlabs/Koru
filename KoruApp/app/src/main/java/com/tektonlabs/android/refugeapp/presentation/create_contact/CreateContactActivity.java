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

package com.tektonlabs.android.refugeapp.presentation.create_contact;

import android.content.Intent;
import android.support.design.widget.TextInputLayout;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.MenuItem;
import android.widget.Button;
import android.widget.EditText;

import com.tektonlabs.android.refugeapp.R;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.Contact;
import com.tektonlabs.android.refugeapp.utils.Constants;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class CreateContactActivity extends AppCompatActivity {

    @BindView(R.id.til_name)
    TextInputLayout til_name;

    @BindView(R.id.et_name)
    EditText et_name;

    @BindView(R.id.til_phone_number)
    TextInputLayout til_phone_number;

    @BindView(R.id.et_phone_number)
    EditText et_phone_number;

    @BindView(R.id.til_email)
    TextInputLayout til_email;

    @BindView(R.id.et_email)
    EditText et_email;

    @BindView(R.id.bt_continue)
    Button bt_continue;

    boolean editContact = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_contact);
        ButterKnife.bind(this);

        if (getSupportActionBar() != null) {
            if (getIntent().hasExtra(Constants.PRIMARY_CONTACT)) {
                getSupportActionBar().setTitle(getIntent().getBooleanExtra(Constants.PRIMARY_CONTACT, false) ? getString(R.string.primary_contact_title) : getString(R.string.secondary_contact_title));
            }
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        }

        if (getIntent().hasExtra(Constants.EXTRA_CONTACT)) {
            editContact = true;
            setDataIntoViews();
        }

        bt_continue.setText(editContact ? getString(R.string.edit_contact_bt) : getString(R.string.add_contact_bt));
        et_email.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (!s.toString().isEmpty()){
                    til_email.setErrorEnabled(false);
                }
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });
        et_name.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (!s.toString().isEmpty()){
                    til_name.setErrorEnabled(false);
                }
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });

        et_phone_number.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (!s.toString().isEmpty()){
                    til_phone_number.setErrorEnabled(false);
                }
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });
    }
    
    private void setDataIntoViews() {
        Contact contact = (Contact) getIntent().getSerializableExtra(Constants.EXTRA_CONTACT);
        et_name.setText(contact.getName());
        et_phone_number.setText(contact.getPhone());
        et_email.setText(contact.getEmail());
    }

    @OnClick(R.id.bt_continue)
    public void bt_continue() {
        boolean cancel = false;
        til_name.setError(null);
        til_name.setErrorEnabled(false);
        til_phone_number.setError(null);
        til_phone_number.setErrorEnabled(false);
        til_email.setError(null);
        til_email.setErrorEnabled(false);

        if (et_name.getText().toString().isEmpty()) {
            cancel = true;
            til_name.setErrorEnabled(true);
            til_name.setError(getString(R.string.error_txt));
        }

        if (et_phone_number.getText().toString().length() < 9) {
            cancel = true;
            til_phone_number.setErrorEnabled(true);
            til_phone_number.setError(getString(R.string.error_phone));
        }

        if (et_phone_number.getText().toString().isEmpty()) {
            cancel = true;
            til_phone_number.setErrorEnabled(true);
            til_phone_number.setError(getString(R.string.error_txt));
        }

        if (!isEmailValid(et_email.getText().toString().trim())) {
            cancel = true;
            til_email.setErrorEnabled(true);
            til_email.setError(getString(R.string.error_email));
        }

        if (et_email.getText().toString().isEmpty()) {
            cancel = true;
            til_email.setErrorEnabled(true);
            til_email.setError(getString(R.string.error_txt));
        }

        if (!cancel) {
            Contact contact = new Contact(et_name.getText().toString(), et_phone_number.getText().toString(), et_email.getText().toString());
            Intent i = new Intent();
            i.putExtra(Constants.EDIT_CONTACT, editContact);
            i.putExtra(Constants.EXTRA_CONTACT, contact);
            setResult(RESULT_OK, i);
            finish();
        }
    }

    public static boolean isEmailValid(String email) {
        String expression = "^[\\w\\.+-]+@([\\w\\-]+\\.)+[A-Z]{2,4}$";

        Pattern pattern = Pattern.compile(expression, Pattern.CASE_INSENSITIVE);
        Matcher matcher = pattern.matcher(email);

        return matcher.matches();
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                finish();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }
}
