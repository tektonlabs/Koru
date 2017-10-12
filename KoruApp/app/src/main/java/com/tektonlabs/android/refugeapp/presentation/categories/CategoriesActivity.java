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

package com.tektonlabs.android.refugeapp.presentation.categories;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.tektonlabs.android.refugeapp.R;
import com.tektonlabs.android.refugeapp.data.network.models.Question;
import com.tektonlabs.android.refugeapp.data.network.models.Service;
import com.tektonlabs.android.refugeapp.presentation.categories.callbacks.CategoriesViewContract;
import com.tektonlabs.android.refugeapp.presentation.questions.QuestionsActivity;
import com.tektonlabs.android.refugeapp.utils.Constants;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

import static com.tektonlabs.android.refugeapp.presentation.shelters.SheltersActivity.SHELTERS_ACTIVITY_CODE;

public class CategoriesActivity extends AppCompatActivity implements CategoriesViewContract.View, CategoryViewHolder.CategoryListener {

    @BindView(R.id.bt_continue)
    Button bt_continue;

    @BindView(R.id.rv_categories)
    RecyclerView rv_categories;

    @BindView(R.id.v_progress)
    ProgressBar v_progress;

    @BindView(R.id.bt_select_all)
    Button bt_select_all;

    @BindView(R.id.ll_empty_state_categories)
    LinearLayout ll_empty_state_categories;

    @BindView(R.id.tv_message)
    TextView tv_message;

    @BindView(R.id.ll_categories)
    LinearLayout ll_categories;

    private CategoriesPresenter categoriesPresenter;
    private int shelterId;
    private CategoriesAdapter categoriesAdapter;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_categories);
        ButterKnife.bind(this);
        v_progress.setVisibility(View.VISIBLE);
        ll_categories.setVisibility(View.GONE);
        shelterId = getIntent().getIntExtra(Constants.SHELTER_ID, 0);
        categoriesPresenter = new CategoriesPresenter(this);
        categoriesPresenter.requestServices(shelterId);
        setRecyclerView();
        setActionBar();
    }

    private void setActionBar() {
        if (getSupportActionBar() != null) {
            getSupportActionBar().setTitle(R.string.categories);
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        }
    }


    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            finish();
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK && data.getIntExtra(Constants.QUESTIONARY_FINISHED, 0) == Constants.QUESTIONARY_FINISHED_CODE) {
            setResult(RESULT_OK, createIntentForActivityResult());
            finish();
        } else if (resultCode == RESULT_CANCELED && data != null &&
                data.getIntExtra(Constants.QUESTIONARY_FINISHED, 0) == Constants.QUESTIONARY_FINISHED_CODE) {
            setResult(RESULT_CANCELED, createIntentForActivityResult());
            finish();
        } else  if (resultCode == RESULT_CANCELED && data == null){
            if (categoriesAdapter != null){
                categoriesAdapter.deselectAll();
                bt_continue.setVisibility(View.GONE);
                toggleSelectAllButton();
            }
        }
    }

    private Intent createIntentForActivityResult() {
        Intent intent = getIntent();
        intent.putExtra(Constants.QUESTIONARY_FINISHED, Constants.QUESTIONARY_FINISHED_CODE);
        return intent;
    }

    private void setRecyclerView() {
        categoriesAdapter = new CategoriesAdapter(this);
        rv_categories.setNestedScrollingEnabled(false);
        rv_categories.setAdapter(categoriesAdapter);
        GridLayoutManager gridLayoutManager = new GridLayoutManager(getApplicationContext(), 3);
        rv_categories.setLayoutManager(gridLayoutManager);
    }

    @Override
    public void onServicesDataSuccess(List<Service> services) {
        toggleEmptyState(false);
        v_progress.setVisibility(View.GONE);
        ll_categories.setVisibility(View.VISIBLE);
        categoriesAdapter.setData(services);
    }

    @Override
    public void onServicesDataFailure(Object object) {
        v_progress.setVisibility(View.GONE);
        toggleEmptyState(true);
    }

    @Override
    public void OnCategoryClicked(int position) {
        categoriesAdapter.setSelected(position);
        toggleSelectAllButton();
        toggleContinueButton();
    }

    private void toggleContinueButton() {
        if (categoriesAdapter.atLeastOneSelected()) {
            bt_continue.setVisibility(View.VISIBLE);
        } else {
            bt_continue.setVisibility(View.GONE);
        }
    }


    @OnClick(R.id.bt_select_all)
    public void bt_select_all() {
        selectDeselectServices(bt_select_all.getText().toString());
        toggleSelectAllButton();
        toggleContinueButton();
    }

    private void selectDeselectServices(String buttonText){
        if (buttonText.equals(getString(R.string.select_all))){
            categoriesAdapter.selectAllServices();
        }else {
            categoriesAdapter.deselectAll();
        }
    }

    private void toggleSelectAllButton(){
        if (categoriesAdapter.atLeastOneSelected()){
            changeTextSelectAllButton(false);
        }else {
            changeTextSelectAllButton(true);
        }
    }

    private void changeTextSelectAllButton(boolean selectAll){
        bt_select_all.setText(selectAll ? getString(R.string.select_all) : getString(R.string.deselect_all));
    }

    private void toggleEmptyState(boolean show) {
        ll_categories.setVisibility(show ? View.GONE : View.VISIBLE);
        ll_empty_state_categories.setVisibility(show ? View.VISIBLE : View.GONE);
    }

    @OnClick(R.id.bt_continue)
    public void bt_continue() {
        Intent intent = new Intent(CategoriesActivity.this, QuestionsActivity.class);
        intent.putExtra(Constants.SHELTER_ID, shelterId);
        ArrayList<Question> questions = getSelectedQuestion(categoriesAdapter.getAllSelectedServices());
        intent.putExtra(Constants.QUESTIONS, questions);
        startActivityForResult(intent, SHELTERS_ACTIVITY_CODE);
    }

    private ArrayList<Question> getSelectedQuestion(List<Service> services) {
        ArrayList<Question> questions = new ArrayList<>();
        for (Service service : services) {
            questions.addAll(service.getQuestions());
        }
        return questions;
    }
}
