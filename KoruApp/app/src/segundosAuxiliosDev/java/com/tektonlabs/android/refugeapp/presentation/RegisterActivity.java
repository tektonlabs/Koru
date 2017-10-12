package com.tektonlabs.android.refugeapp.presentation;

import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.TextInputLayout;
import android.support.v7.app.AppCompatActivity;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.MenuItem;
import android.widget.Button;
import android.widget.EditText;

import com.tektonlabs.android.refugeapp.R;
import com.tektonlabs.android.refugeapp.presentation.shelters.SheltersActivity;
import com.tektonlabs.android.refugeapp.utils.SharedPreferencesHelper;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class RegisterActivity extends AppCompatActivity {


    @BindView(R.id.til_dni)
    TextInputLayout til_dni;

    @BindView(R.id.et_dni)
    EditText et_dni;

    @BindView(R.id.bt_continue)
    Button bt_continue;

    @BindView(R.id.til_phone_number)
    TextInputLayout til_phone_number;

    @BindView(R.id.et_phone_number)
    EditText et_phone_number;

    @BindView(R.id.til_institution)
    TextInputLayout til_institution;

    @BindView(R.id.et_institution)
    EditText et_institution;

    private SharedPreferencesHelper manager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_register);
        ButterKnife.bind(this);
        manager = SharedPreferencesHelper.getInstance(this);
        setDataIntoViews();
        setUpActionBar();

        et_dni.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (!s.toString().isEmpty()) til_dni.setErrorEnabled(false);
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });

        et_institution.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (!s.toString().isEmpty())  til_institution.setErrorEnabled(false);
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
                if (!s.toString().isEmpty()) til_phone_number.setErrorEnabled(false);
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });
    }

    private void setDataIntoViews() {
        if(!manager.getRegisterDni().isEmpty()){
            et_dni.setText(manager.getRegisterDni());
        }
        if(!manager.getPhone().isEmpty()){
            et_phone_number.setText(manager.getPhone());
        }
        if(!manager.getInstitution().isEmpty()){
            et_institution.setText(manager.getInstitution());
        }
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            finish();
        }
        return super.onOptionsItemSelected(item);
    }

    private void setUpActionBar() {
        getSupportActionBar().setTitle(R.string.register_title);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
    }

    @OnClick(R.id.bt_continue)
    public void bt_continue() {
        boolean validation_dni = validateDni();
        boolean validation_phone = validatePhone();
        boolean validate_institution = !emptyInstitution();
        boolean validation = validation_dni && validation_phone && validate_institution;
        if (validation) {
            SharedPreferencesHelper.getInstance(getApplicationContext()).setIsRegister(true);
            saveDni(et_dni.getText().toString());
            savePhone(et_phone_number.getText().toString());
            saveInstitution(et_institution.getText().toString());
            createIntent();
        }
    }

    private boolean emptyInstitution() {
        til_institution.setError("");
        if (TextUtils.isEmpty(et_institution.getText().toString())) {
            til_institution.setError(getString(R.string.required_field));
            return true;
        }
        return false;
    }

    private boolean validateDni() {
        til_dni.setError("");
        String validation = "\\d{8}";
        String input = et_dni.getText().toString();
        if (input.length() < 1) {
            til_dni.setError(getString(R.string.required_field));
            return false;
        }
        if (et_dni.getText().toString().matches(validation)) {
            return true;
        } else {
            til_dni.setError(getString(R.string.valid_digits_dni));
        }
        return false;
    }


    private boolean validatePhone() {
        til_phone_number.setError("");
        String validation = "\\d{9}";
        String input = et_phone_number.getText().toString();
        if (input.length() < 1) {
            til_phone_number.setError(getString(R.string.required_field));
            return false;
        }
        if (et_phone_number.getText().toString().matches(validation)) {
            return true;
        } else {
            til_phone_number.setError(getString(R.string.valid_digits_phone));
        }
        return false;
    }


    private void createIntent() {
        Intent intent = new Intent(this, SheltersActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
    }

    private void saveDni(String dni) {
        SharedPreferencesHelper.getInstance(getApplicationContext()).saveRegisterDni(dni);
    }

    private void savePhone(String phone) {
        SharedPreferencesHelper.getInstance(getApplicationContext()).savePhone(phone);

    }

    private void saveInstitution(String institution) {
        SharedPreferencesHelper.getInstance(getApplicationContext()).saveInstitution(institution);
    }

}
