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

package com.tektonlabs.android.refugeapp.presentation.create_shelters.fragments;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.design.widget.TextInputLayout;
import android.support.v4.app.Fragment;
import android.support.v4.content.ContextCompat;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.TextView;
import com.tektonlabs.android.refugeapp.R;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.CreateShelterActivity;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.PlaceAutocompleteActivity;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.LocalAddress;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.interfaces.CreateShelterViewContract;
import com.tektonlabs.android.refugeapp.utils.ClickToSelectEditText;
import com.tektonlabs.android.refugeapp.utils.Constants;
import com.tektonlabs.android.refugeapp.utils.SharedPreferencesHelper;
import com.tektonlabs.android.refugeapp.utils.UIHelper;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class CreateShelterStep1Fragment extends Fragment implements CreateShelterViewContract.FirstStepView, CreateShelterStepListener.UserActionListener {

    @BindView(R.id.til_name)
    TextInputLayout til_name;
    @BindView(R.id.et_shelter_name)
    EditText et_shelter_name;
    @BindView(R.id.et_address)
    EditText et_address;
    @BindView(R.id.til_address)
    TextInputLayout til_address;

    @BindView(R.id.til_shelter_type)
    TextInputLayout til_shelter_type;
    @BindView(R.id.s_shelter_type)
    ClickToSelectEditText cs_shelter_type;
    @BindView(R.id.til_emergency)
    TextInputLayout til_emergency;
    @BindView(R.id.sp_emergency)
    ClickToSelectEditText sp_emergency;
    @BindView(R.id.til_institution)
    TextInputLayout til_institution;
    @BindView(R.id.sp_institution)
    ClickToSelectEditText sp_institution;
    //to clear focus from shelter name input
    @BindView(R.id.txt_general_data)
    TextView txt_general_data;


    private String[] emergencies;
    private String[] types;
    private String[] institutions;

    LocalAddress address;

    private CreateShelterStepListener.FirstStepView fragmentListener;

    private SharedPreferencesHelper manager;

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        if (context instanceof CreateShelterStepListener.FirstStepView) {
            fragmentListener = (CreateShelterStepListener.FirstStepView) context;

        } else {
            throw new RuntimeException(context.toString()
                    + " must implement OnFragmentInteractionListener");
        }
    }


    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_new_shelter_step_1, container, false);
        ButterKnife.bind(this, v);
        fragmentListener.onFragmentReady(this);

        manager = SharedPreferencesHelper.getInstance(getActivity());

        UIHelper.hideKeyboardActivity(getActivity());

        types = getResources().getStringArray(R.array.sp_shelter_type);
        institutions = getResources().getStringArray(R.array.sp_institution);
        emergencies = getResources().getStringArray(R.array.sp_emergency);

        setupViews();

        return v;
    }

    private void setupViews() {
        et_shelter_name.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (!s.toString().isEmpty()) {
                    til_name.setErrorEnabled(false);
                }
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });

        cs_shelter_type.setItems(types);
        cs_shelter_type.setOnItemSelectedListener(new ClickToSelectEditText.OnItemSelectedListener() {
            @Override
            public void onItemSelectedListener(String item, int selectedIndex) {
                et_shelter_name.setCursorVisible(false);
                til_shelter_type.setErrorEnabled(false);
                txt_general_data.requestFocus();
                UIHelper.hideKeyboardActivity(getActivity());
            }
        });
        sp_emergency.setItems(emergencies);
        sp_emergency.setOnItemSelectedListener(new ClickToSelectEditText.OnItemSelectedListener() {
            @Override
            public void onItemSelectedListener(String item, int selectedIndex) {
                et_shelter_name.setCursorVisible(false);
                til_emergency.setErrorEnabled(false);
                txt_general_data.requestFocus();
                UIHelper.hideKeyboardActivity(getActivity());
            }
        });
        sp_institution.setItems(institutions);
        sp_institution.setOnItemSelectedListener(new ClickToSelectEditText.OnItemSelectedListener() {
            @Override
            public void onItemSelectedListener(String item, int selectedIndex) {
                et_shelter_name.setCursorVisible(false);
                til_institution.setErrorEnabled(false);
                txt_general_data.requestFocus();
                UIHelper.hideKeyboardActivity(getActivity());
            }
        });
    }

    public boolean validationsFirstStep() {
        cleanErrors();
        return !((CreateShelterActivity) getActivity()).getCreateShelterPresenter().validateFirstStep(
                et_shelter_name.getText().toString(),
                cs_shelter_type.getText().toString(),
                sp_institution.getText().toString(),
                sp_emergency.getText().toString(),
                address, manager.getRegisterDni(), manager.getPhone(), manager.getInstitution()
        );

    }

    private void cleanErrors() {
        til_name.setErrorEnabled(false);
        til_emergency.setErrorEnabled(false);
        til_institution.setErrorEnabled(false);
        til_shelter_type.setErrorEnabled(false);
        til_address.setErrorEnabled(false);
    }

    @OnClick(R.id.et_address)
    public void et_direction_on_click() {
        Intent i = new Intent(getActivity(), PlaceAutocompleteActivity.class);
        if (address != null) {
            i.putExtra(Constants.EXTRA_ADDRESS, address);
        }
        txt_general_data.requestFocus();
        startActivityForResult(i, Constants.MAP_REQUEST_CODE);
    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == Constants.MAP_REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                address = (LocalAddress) data.getSerializableExtra(Constants.EXTRA_ADDRESS);
                et_address.setText(address.getAddress());
                et_address.setTextColor(ContextCompat.getColor(getContext(), android.R.color.black));
                til_address.setErrorEnabled(false);
                et_shelter_name.setCursorVisible(false);
                UIHelper.hideKeyboardActivity(getActivity());
            }
        }
    }

    @Override
    public void nameTextEmpty() {
        til_name.setErrorEnabled(true);
        til_name.setError(getString(R.string.error_txt));
    }

    @Override
    public void shelterTypeEmpty() {
        til_shelter_type.setErrorEnabled(true);
        til_shelter_type.setError(getString(R.string.error_txt));
    }

    @Override
    public void organizationEmpty() {
        til_institution.setErrorEnabled(true);
        til_institution.setError(getString(R.string.error_txt));
    }

    @Override
    public void emergencyTypeEmpty() {
        til_emergency.setErrorEnabled(true);
        til_emergency.setError(getString(R.string.error_txt));
    }

    @Override
    public void addressEmpty() {
        til_address.setErrorEnabled(true);
        til_address.setError(getString(R.string.error_txt));
    }

    @Override
    public void onDetach() {
        super.onDetach();
        fragmentListener = null;
    }

    @Override
    public boolean validateFields() {
        return validationsFirstStep();
    }
}
