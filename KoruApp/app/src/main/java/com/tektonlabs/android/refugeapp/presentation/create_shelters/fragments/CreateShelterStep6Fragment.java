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
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import com.tektonlabs.android.refugeapp.R;
import com.tektonlabs.android.refugeapp.data.network.models.create_shelter.shelter_data.MultipleChoice;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.CreateShelterActivity;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.interfaces.CreateShelterViewContract;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.adapter.CreateShelterMultipleChoiceAdapter;
import com.tektonlabs.android.refugeapp.utils.UIHelper;
import java.util.ArrayList;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class CreateShelterStep6Fragment extends Fragment implements CreateShelterViewContract.SixthStepView, CreateShelterStepListener.UserActionListener, CreateShelterActivity.OnShelterCreated{

    @BindView(R.id.rv_light)
    RecyclerView rv_light;
    @BindView(R.id.rv_water)
    RecyclerView rv_water;
    @BindView(R.id.rv_dreg)
    RecyclerView rv_dreg;
    @BindView(R.id.rv_trash)
    RecyclerView rv_trash;
    @BindView(R.id.rv_food)
    RecyclerView rv_food;
    @BindView(R.id.pb)
    ProgressBar pb;
    @BindView(R.id.ll_container)
    LinearLayout ll_container;

    ArrayList<MultipleChoice> light = new ArrayList<>();
    ArrayList<MultipleChoice> water = new ArrayList<>();
    ArrayList<MultipleChoice> dreg = new ArrayList<>();
    ArrayList<MultipleChoice> trash = new ArrayList<>();
    ArrayList<MultipleChoice> food = new ArrayList<>();

    private CreateShelterStepListener.SixthStepView fragmentListener;

    CreateShelterMultipleChoiceAdapter lightAdapter;
    CreateShelterMultipleChoiceAdapter waterAdapter;
    CreateShelterMultipleChoiceAdapter dregAdapter;
    CreateShelterMultipleChoiceAdapter trashAdapter;
    CreateShelterMultipleChoiceAdapter foodAdapter;

    public static CreateShelterStep6Fragment newInstance(ArrayList<MultipleChoice> light,ArrayList<MultipleChoice> water,ArrayList<MultipleChoice> dreg,
                                                         ArrayList<MultipleChoice> trash,ArrayList<MultipleChoice> food){
        CreateShelterStep6Fragment fragment = new CreateShelterStep6Fragment();
        Bundle args = new Bundle();
        args.putSerializable("DATA1", light);
        args.putSerializable("DATA2", water);
        args.putSerializable("DATA3", dreg);
        args.putSerializable("DATA4", trash);
        args.putSerializable("DATA5", food);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (getArguments() != null) {
            light = (ArrayList<MultipleChoice>)getArguments().getSerializable("DATA1");
            water = (ArrayList<MultipleChoice>)getArguments().getSerializable("DATA2");
            dreg  = (ArrayList<MultipleChoice>)getArguments().getSerializable("DATA3");
            trash = (ArrayList<MultipleChoice>)getArguments().getSerializable("DATA4");
            food  = (ArrayList<MultipleChoice>)getArguments().getSerializable("DATA5");
        }
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        if (context instanceof CreateShelterStepListener.SixthStepView) {
            fragmentListener = (CreateShelterStepListener.SixthStepView) context;

        } else {
            throw new RuntimeException(context.toString()
                    + " must implement OnFragmentInteractionListener");
        }
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_new_shelter_step_6,container,false);
        ButterKnife.bind(this,v);
        fragmentListener.onFragmentReady(this);

        UIHelper.hideKeyboardActivity(getActivity());

        lightAdapter = new CreateShelterMultipleChoiceAdapter(light);
        waterAdapter = new CreateShelterMultipleChoiceAdapter(water);
        dregAdapter = new CreateShelterMultipleChoiceAdapter(dreg);
        trashAdapter = new CreateShelterMultipleChoiceAdapter(trash);
        foodAdapter = new CreateShelterMultipleChoiceAdapter(food);

        setDataToRv(rv_food,foodAdapter);
        setDataToRv(rv_trash,trashAdapter);
        setDataToRv(rv_dreg,dregAdapter);
        setDataToRv(rv_water,waterAdapter);
        setDataToRv(rv_light,lightAdapter);

        return v;
    }

    private void setDataToRv(RecyclerView rv, CreateShelterMultipleChoiceAdapter adapter) {
        rv.setNestedScrollingEnabled(false);
        rv.setLayoutManager(new LinearLayoutManager(getActivity()));
        rv.setAdapter(adapter);
    }

    @Override
    public boolean validateFields() {
        ((CreateShelterActivity)getActivity()).getCreateShelterPresenter().optionalFieldsSixthStep(lightAdapter.getSelectedData(),waterAdapter.getSelectedData(),
                                                        dregAdapter.getSelectedData(),trashAdapter.getSelectedData(),foodAdapter.getSelectedData());
        return false;
    }

    @OnClick(R.id.btn_send)
    public void btn_send_on_click(){
        ll_container.setVisibility(View.GONE);
        pb.setVisibility(View.VISIBLE);
        validateFields();
        ((CreateShelterActivity)getActivity()).getCreateShelterPresenter().createShelter();
    }

    @Override
    public void onShelterCreated() {
        ll_container.setVisibility(View.VISIBLE);
        pb.setVisibility(View.GONE);
    }

    @Override
    public void onShelterFailure() {
        ll_container.setVisibility(View.VISIBLE);
        pb.setVisibility(View.GONE);
    }
}
