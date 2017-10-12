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

import android.content.Context;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.design.widget.TextInputLayout;
import android.support.v4.app.Fragment;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import com.tektonlabs.android.refugeapp.R;
import com.tektonlabs.android.refugeapp.data.network.models.create_shelter.shelter_data.MultipleChoice;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.CreateShelterActivity;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.TagModel;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.adapter.TagAdapter;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.interfaces.CreateShelterViewContract;
import com.tektonlabs.android.refugeapp.utils.ClickToSelectEditText;
import com.tektonlabs.android.refugeapp.utils.UIHelper;
import java.util.ArrayList;
import java.util.List;
import butterknife.BindView;
import butterknife.ButterKnife;

public class CreateShelterStep2Fragment extends Fragment implements CreateShelterViewContract.SecondStepView, CreateShelterStepListener.UserActionListener {

    @BindView(R.id.sp_property_type)
    ClickToSelectEditText sp_property_type;
    @BindView(R.id.sp_accessibility)
    ClickToSelectEditText sp_accessibility;
    @BindView(R.id.sp_victims)
    ClickToSelectEditText sp_victims;
    @BindView(R.id.rv_service_types)
    RecyclerView rv_service_types;
    @BindView(R.id.til_property_type)
    TextInputLayout til_property_type;
    @BindView(R.id.til_accessibility)
    TextInputLayout til_accessibility;
    @BindView(R.id.til_victims)
    TextInputLayout til_victims;

    private String[] properties;
    private String[] accessibilities;
    private String[] victims;

    private CreateShelterStepListener.SecondStepView fragmentListener;
    private TagAdapter adapter;


    private List<MultipleChoice> data = new ArrayList<>();

    public static CreateShelterStep2Fragment newInstance(ArrayList<MultipleChoice> multipleChoices) {
        CreateShelterStep2Fragment fragment = new CreateShelterStep2Fragment();
        Bundle args = new Bundle();
        args.putSerializable("DATA", multipleChoices);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            data = (ArrayList<MultipleChoice>) getArguments().getSerializable("DATA");
        }
    }


    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        if (context instanceof CreateShelterStepListener.SecondStepView) {
            fragmentListener = (CreateShelterStepListener.SecondStepView) context;

        } else {
            throw new RuntimeException(context.toString()
                    + " must implement OnFragmentInteractionListener");
        }
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_new_shelter_step_2, container, false);
        ButterKnife.bind(this, v);
        fragmentListener.onFragmentReady(this);

        UIHelper.hideKeyboardActivity(getActivity());

        properties = getResources().getStringArray(R.array.sp_property);
        accessibilities = getResources().getStringArray(R.array.sp_accessibility);
        victims = getResources().getStringArray(R.array.sp_victims);

        setDataIntoViews();

        return v;
    }

    private void setDataIntoViews() {
        sp_property_type.setItems(properties);
        sp_property_type.setOnItemSelectedListener(new ClickToSelectEditText.OnItemSelectedListener() {
            @Override
            public void onItemSelectedListener(String item, int selectedIndex) {
                til_property_type.setErrorEnabled(false);
                UIHelper.hideKeyboardActivity(getActivity());
            }
        });
        sp_accessibility.setItems(accessibilities);
        sp_accessibility.setOnItemSelectedListener(new ClickToSelectEditText.OnItemSelectedListener() {
            @Override
            public void onItemSelectedListener(String item, int selectedIndex) {
                til_accessibility.setErrorEnabled(false);
                UIHelper.hideKeyboardActivity(getActivity());
            }
        });
        sp_victims.setItems(victims);
        sp_victims.setOnItemSelectedListener(new ClickToSelectEditText.OnItemSelectedListener() {
            @Override
            public void onItemSelectedListener(String item, int selectedIndex) {
                til_victims.setErrorEnabled(false);
                UIHelper.hideKeyboardActivity(getActivity());
            }
        });
        setDataToRv();
    }

    private void setDataToRv() {
        List<TagModel> tags = new ArrayList<>();
        tags.add(new TagModel());
        adapter = new TagAdapter(tags, rv_service_types, (TagAdapter.OnTextChangedListener) getActivity());
        rv_service_types.setNestedScrollingEnabled(false);
        rv_service_types.setLayoutManager(new LinearLayoutManager(getContext()));
        rv_service_types.setAdapter(adapter);
    }

    private boolean validationSecondStep() {
        cleanErrors();
        return ((CreateShelterActivity) getActivity()).getCreateShelterPresenter().validateSecondStep(
                sp_property_type.getText().toString(),
                sp_accessibility.getText().toString(),
                sp_victims.getText().toString());
    }

    private void cleanErrors() {
        til_property_type.setErrorEnabled(false);
        til_accessibility.setErrorEnabled(false);
        til_victims.setErrorEnabled(false);
    }

    @Override
    public boolean validateFields() {
        if (!validationSecondStep()) {
            ((CreateShelterActivity) getActivity()).getCreateShelterPresenter().optionalFieldsSecondStep(adapter.getData());
            return true;
        }
        return false;
    }

    @Override
    public void propertyEmpty() {
        til_property_type.setErrorEnabled(true);
        til_property_type.setError(getString(R.string.error_txt));
    }

    @Override
    public void accessibilityEmpty() {
        til_accessibility.setErrorEnabled(true);
        til_accessibility.setError(getString(R.string.error_txt));
    }

    @Override
    public void victimsEmpty() {
        til_victims.setErrorEnabled(true);
        til_victims.setError(getString(R.string.error_txt));
    }

    public void setDataToAdapter(List<String> data) {
        adapter.setDataToHolderAdapter(data);
    }
}
