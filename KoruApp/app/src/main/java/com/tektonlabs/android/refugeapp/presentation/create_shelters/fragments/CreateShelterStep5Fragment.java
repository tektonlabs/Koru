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
import android.widget.EditText;
import com.tektonlabs.android.refugeapp.R;
import com.tektonlabs.android.refugeapp.data.network.models.create_shelter.shelter_data.MultipleChoice;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.CreateShelterActivity;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.interfaces.CreateShelterViewContract;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.adapter.CreateShelterMultipleChoiceAdapter;
import com.tektonlabs.android.refugeapp.utils.ClickToSelectEditText;
import com.tektonlabs.android.refugeapp.utils.UIHelper;
import java.util.ArrayList;
import java.util.List;
import butterknife.BindView;
import butterknife.ButterKnife;

public class CreateShelterStep5Fragment extends Fragment implements CreateShelterViewContract.FifthStepView, CreateShelterStepListener.UserActionListener {

    @BindView(R.id.et_tents)
    EditText et_tents;
    @BindView(R.id.et_toilet)
    EditText et_toilet;
    @BindView(R.id.et_lavatory)
    EditText et_lavatory;
    @BindView(R.id.et_showers)
    EditText et_showers;
    @BindView(R.id.et_water_tank)
    EditText et_water_tank;
    @BindView(R.id.et_dumpsters)
    EditText et_dumpsters;
    @BindView(R.id.et_trash)
    EditText et_trash;
    @BindView(R.id.rv_presence_of)
    RecyclerView rv_presence_of;
    @BindView(R.id.sp_floor_type)
    ClickToSelectEditText sp_floor_type;
    @BindView(R.id.sp_roof)
    ClickToSelectEditText sp_roof;
    @BindView(R.id.til_roof)
    TextInputLayout til_roof;
    @BindView(R.id.til_floor_type)
    TextInputLayout til_floor_type;

    String[] floor;
    String[] roof;

    private CreateShelterStepListener.FifthStepView fragmentListener;

    CreateShelterMultipleChoiceAdapter adapter;

    List<MultipleChoice> presence;

    public static CreateShelterStep5Fragment newInstance(ArrayList<MultipleChoice> areas){
        CreateShelterStep5Fragment fragment = new CreateShelterStep5Fragment();
        Bundle args = new Bundle();
        args.putSerializable("DATA", areas);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            presence = (ArrayList<MultipleChoice>)getArguments().getSerializable("DATA");
        }
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        if (context instanceof CreateShelterStepListener.FifthStepView) {
            fragmentListener = (CreateShelterStepListener.FifthStepView) context;

        } else {
            throw new RuntimeException(context.toString()
                    + " must implement OnFragmentInteractionListener");
        }
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_new_shelter_step_5, container, false);
        ButterKnife.bind(this, v);
        fragmentListener.onFragmentReady(this);

        UIHelper.hideKeyboardActivity(getActivity());

        floor = getResources().getStringArray(R.array.sp_floor);
        roof = getResources().getStringArray(R.array.sp_roof);

        setDataToPresenceRv();

        sp_floor_type.setItems(floor);
        sp_floor_type.setOnItemSelectedListener(new ClickToSelectEditText.OnItemSelectedListener() {
            @Override
            public void onItemSelectedListener(String item, int selectedIndex) {
                til_floor_type.setErrorEnabled(false);
                UIHelper.hideKeyboardActivity(getActivity());
            }
        });
        sp_roof.setItems(roof);
        sp_roof.setOnItemSelectedListener(new ClickToSelectEditText.OnItemSelectedListener() {
            @Override
            public void onItemSelectedListener(String item, int selectedIndex) {
                til_roof.setErrorEnabled(false);
                UIHelper.hideKeyboardActivity(getActivity());
            }
        });

        return v;
    }

    private void setDataToPresenceRv() {
        adapter = new CreateShelterMultipleChoiceAdapter(presence);
        rv_presence_of.setNestedScrollingEnabled(false);
        rv_presence_of.setLayoutManager(new LinearLayoutManager(getActivity()));
        rv_presence_of.setAdapter(adapter);
    }

    private boolean validationsFifthStep() {
        cleanErrors();
        return ((CreateShelterActivity)getActivity()).getCreateShelterPresenter().validateFifthStep(
                sp_floor_type.getText().toString(),
                sp_roof.getText().toString());
    }

    private void cleanErrors() {
        til_floor_type.setErrorEnabled(false);
        til_roof.setErrorEnabled(false);
    }

    @Override
    public void floorEmpty() {
        til_floor_type.setErrorEnabled(true);
        til_floor_type.setError(getString(R.string.error_txt));
    }

    @Override
    public void roofEmpty() {
        til_roof.setErrorEnabled(true);
        til_roof.setError(getString(R.string.error_txt));
    }

    @Override
    public boolean validateFields() {
        if(!validationsFifthStep()){
            ((CreateShelterActivity)getActivity()).getCreateShelterPresenter().optionalFieldsFifthStep(et_toilet.getText().toString(),et_tents.getText().toString(),et_lavatory.getText().toString(),et_showers.getText().toString(),
                                                            et_water_tank.getText().toString(),et_trash.getText().toString(),et_dumpsters.getText().toString(),adapter.getSelectedData());
            return  true;
        }
        return false;
    }
}
