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
import android.support.v4.app.Fragment;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import com.tektonlabs.android.refugeapp.R;
import com.tektonlabs.android.refugeapp.data.network.models.create_shelter.shelter_data.MultipleChoice;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.CreateShelterActivity;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.interfaces.CreateShelterViewContract;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.adapter.CreateShelterMultipleChoiceAdapter;
import com.tektonlabs.android.refugeapp.utils.UIHelper;
import java.util.ArrayList;
import java.util.List;
import butterknife.BindView;
import butterknife.ButterKnife;

public class CreateShelterStep4Fragment extends Fragment implements CreateShelterViewContract.FourthStepView, CreateShelterStepListener.UserActionListener {

    @BindView(R.id.et_family)
    EditText et_family;
    @BindView(R.id.et_pregnant)
    EditText et_pregnant;
    @BindView(R.id.et_handicapped)
    EditText et_handicapped;
    @BindView(R.id.et_pets)
    EditText et_pets;
    @BindView(R.id.et_farm_animals)
    EditText et_farm_animals;
    @BindView(R.id.rv_service_type)
    RecyclerView rv_service_type;
    @BindView(R.id.rv_status)
    RecyclerView rv_status;
    @BindView(R.id.et_male_children)
    EditText et_male_children;
    @BindView(R.id.et_female_children)
    EditText et_female_children;
    @BindView(R.id.et_under_18_male)
    EditText et_under_18_male;
    @BindView(R.id.et_under_18_female)
    EditText et_under_18_female;
    @BindView(R.id.et_above_18_male)
    EditText et_above_18_male;
    @BindView(R.id.et_above_18_female)
    EditText et_above_18_female;
    @BindView(R.id.et_elderly_male)
    EditText et_elderly_male;
    @BindView(R.id.et_elderly_female)
    EditText et_elderly_female;

    private CreateShelterStepListener.FourthStepView fragmentListener;
    private CreateShelterMultipleChoiceAdapter statusAdapter;
    private CreateShelterMultipleChoiceAdapter serviceAdapter;

    private List<MultipleChoice> services = new ArrayList<>();
    private List<MultipleChoice> status = new ArrayList<>();

    public static CreateShelterStep4Fragment newInstance(ArrayList<MultipleChoice> services,
                                                         ArrayList<MultipleChoice> status){
        CreateShelterStep4Fragment fragment = new CreateShelterStep4Fragment();
        Bundle args = new Bundle();
        args.putSerializable("DATA1", services);
        args.putSerializable("DATA2", status);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            services = (ArrayList<MultipleChoice>)getArguments().getSerializable("DATA1");
            status = (ArrayList<MultipleChoice>)getArguments().getSerializable("DATA2");
        }
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        if (context instanceof CreateShelterStepListener.FourthStepView) {
            fragmentListener = (CreateShelterStepListener.FourthStepView) context;

        } else {
            throw new RuntimeException(context.toString()
                    + " must implement OnFragmentInteractionListener");
        }
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_new_shelter_step_4, container, false);
        ButterKnife.bind(this, v);
        fragmentListener.onFragmentReady(this);

        UIHelper.hideKeyboardActivity(getActivity());

        setDataToServiceTypeRv();
        setDataToStatusRv();

        return v;
    }

    private void setDataToStatusRv() {
        statusAdapter = new CreateShelterMultipleChoiceAdapter(status);
        rv_status.setNestedScrollingEnabled(false);
        rv_status.setHasFixedSize(true);
        rv_status.setLayoutManager(new LinearLayoutManager(getActivity()));
        rv_status.setAdapter(statusAdapter);
    }

    private void setDataToServiceTypeRv() {
        serviceAdapter = new CreateShelterMultipleChoiceAdapter(services);
        rv_service_type.setNestedScrollingEnabled(false);
        rv_service_type.setHasFixedSize(true);
        rv_service_type.setLayoutManager(new LinearLayoutManager(getActivity()));
        rv_service_type.setAdapter(serviceAdapter);
    }

    @Override
    public boolean validateFields() {
        ((CreateShelterActivity)getActivity()).getCreateShelterPresenter().optionalFieldsFourthStep(et_family.getText().toString(),et_pregnant.getText().toString(),
                et_handicapped.getText().toString(),et_pets.getText().toString(),et_farm_animals.getText().toString(),
                serviceAdapter.getSelectedData(),statusAdapter.getSelectedData(),et_male_children.getText().toString(),
                et_female_children.getText().toString(),et_under_18_male.getText().toString(),et_under_18_female.getText().toString(),
                et_above_18_male.getText().toString(),et_above_18_female.getText().toString(),et_elderly_male.getText().toString(),
                et_elderly_female.getText().toString());
        return true;
    }
}