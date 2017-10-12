package com.tektonlabs.android.refugeapp.presentation;

import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.TextInputLayout;
import android.support.v7.app.AppCompatActivity;
import android.text.Editable;
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

public class MonitorActivity extends AppCompatActivity {

    @BindView(R.id.til_dni)
    TextInputLayout til_dni;

    @BindView(R.id.et_dni)
    EditText et_dni;

    @BindView(R.id.bt_continue)
    Button bt_continue;

    private SharedPreferencesHelper manager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_monitor);
        ButterKnife.bind(this);
        setUpActionBar();
        manager = SharedPreferencesHelper.getInstance(this);
        setDataIntoViews();

        et_dni.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (!s.toString().isEmpty()){
                    til_dni.setErrorEnabled(false);
                }
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            finish();
        }
        return super.onOptionsItemSelected(item);
    }

    private void setDataIntoViews() {
        if(!manager.getMonitorDni().isEmpty()){
            et_dni.setText(manager.getMonitorDni());
        }
    }

    private void setUpActionBar() {
        getSupportActionBar().setTitle(R.string.login);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
    }

    @OnClick(R.id.bt_continue)
    public void bt_continue() {
        validateDni();
    }

    private void validateDni() {
        til_dni.setError("");
        String validation = "\\d{8}";
        String input = et_dni.getText().toString();
        if (input.length() < 1) {
            til_dni.setError(getString(R.string.required_field));
            return;
        }

        if (et_dni.getText().toString().matches(validation)) {
            manager.saveMonitorDni(input);
            manager.setIsRegister(false);
            createIntent();
        } else {
            til_dni.setError(getString(R.string.valid_digits_dni));
        }
    }

    private void createIntent(){
        Intent intent = new Intent(this, SheltersActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
    }
}
