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

package com.tektonlabs.android.refugeapp.presentation.questions;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.Snackbar;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.MenuItem;
import android.view.View;
import android.view.WindowManager;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import com.lsjwzh.widget.recyclerviewpager.RecyclerViewPager;
import com.tektonlabs.android.refugeapp.R;
import com.tektonlabs.android.refugeapp.data.network.models.Question;
import com.tektonlabs.android.refugeapp.data.network.models.Questionnaire;
import com.tektonlabs.android.refugeapp.presentation.questions.callbacks.QuestionsViewContract;
import com.tektonlabs.android.refugeapp.utils.Constants;
import com.tektonlabs.android.refugeapp.utils.SharedPreferencesHelper;
import com.tektonlabs.android.refugeapp.utils.UIHelper;
import com.tektonlabs.android.refugeapp.utils.Utils;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class QuestionsActivity extends AppCompatActivity implements QuestionsPagerAdapter.QuestionPagerListener, QuestionsViewContract.View {

    @BindView(R.id.rv_question_page)
    RecyclerViewPager rv_question_page;

    @BindView(R.id.v_progress)
    View v_progress;

    @BindView(R.id.pb_quetions_progress)
    ProgressBar pb_questions_progress;

    @BindView(R.id.ll_container)
    LinearLayout ll_container;

    @BindView(R.id.bt_back)
    LinearLayout bt_back;

    @BindView(R.id.bt_skip)
    LinearLayout bt_skip;

    @BindView(R.id.rl_navigation)
    RelativeLayout rl_navigation;

    @BindView(R.id.root_view)
    RelativeLayout root_view;

    Questionnaire questionnaire = new Questionnaire();
    private QuestionsPagerAdapter questionsPagerAdapter;
    private int shelterId;
    private QuestionsPresenter questionsPresenter;
    private AlertDialog backAlertDialog;
    private int currentQuestionPage = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_questions);
        ButterKnife.bind(this);
        ArrayList<Question> questions = (ArrayList<Question>) getIntent().getSerializableExtra(Constants.QUESTIONS);
        questionnaire.setQuestions(questions);
        settingActionBar();
        questionsPresenter = new QuestionsPresenter(this);
        shelterId = getIntent().getIntExtra(Constants.SHELTER_ID, 0);
        setupRecyclerView(questions);
        setFirstTitle();
        hideKeyboard();
    }

    private void hideKeyboard(){
        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN);
    }

    private void setupRecyclerView(List<Question> questions) {
        questionsPagerAdapter = new QuestionsPagerAdapter(questions, this, this);
        final LinearLayoutManager layoutManager = new LinearLayoutManager(this, LinearLayoutManager.HORIZONTAL, false);
        rv_question_page.setLayoutManager(layoutManager);
        rv_question_page.setAdapter(questionsPagerAdapter);

        pb_questions_progress.setMax(questions.size() - 1);
        rv_question_page.addOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
                super.onScrolled(recyclerView, dx, dy);
                currentQuestionPage = layoutManager.findFirstVisibleItemPosition();
                checkForLastAndFirstPage();
                String title = questionnaire.getQuestions().get(currentQuestionPage).getServiceName();
                getSupportActionBar().setTitle(title);
                setupCircleIndicator(currentQuestionPage);
            }
        });
        rv_question_page.addOnPageChangedListener(new RecyclerViewPager.OnPageChangedListener() {
            @Override
            public void OnPageChanged(int i, int i1) {
                UIHelper.hideKeyboard(QuestionsActivity.this);
            }
        });
    }


    private void checkForLastAndFirstPage() {
        bt_back.setVisibility(currentQuestionPage == 0 ? View.GONE : View.VISIBLE);
        bt_skip.setVisibility(currentQuestionPage == questionsPagerAdapter.getItemCount() - 1 ? View.GONE : View.VISIBLE);
    }

    @Override
    public void onSendAnswersClicked() {
        if (Utils.hasAtLeastOneQuestionAnswered(questionnaire.getQuestions())) {
            UIHelper.showProgress(this, v_progress, ll_container, true);
            rl_navigation.setVisibility(View.GONE);
            setDniToQuestionnaire();
            questionsPresenter.postAnswers(shelterId, questionnaire);
        } else {
            showSnackbarMessage(R.string.answer_at_least_one_question);
        }
    }


    private void setDniToQuestionnaire(){
        if(SharedPreferencesHelper.getInstance(getApplicationContext()).getRegister()){
            questionnaire.setDni(SharedPreferencesHelper.getInstance(getApplicationContext()).getRegisterDni());
        }else{
            questionnaire.setDni(SharedPreferencesHelper.getInstance(getApplicationContext()).getMonitorDni());
        }
    }

    private void showSnackbarMessage(int message) {
        Snackbar.make(rv_question_page,
                message, Snackbar.LENGTH_LONG)
                .show();
    }


    @Override
    public void switchToNexPage() {
        changeToNextPage();
    }

    private void setFirstTitle() {
        String title = questionnaire.getQuestions().get(0).getServiceName();
        getSupportActionBar().setTitle(title);
    }

    private Intent createIntentForActivityResult() {
        Intent intent = getIntent();
        intent.putExtra(Constants.QUESTIONARY_FINISHED, Constants.QUESTIONARY_FINISHED_CODE);
        return intent;
    }

    @Override
    public void setAnswersSuccess(Object object) {
        UIHelper.showProgress(this, v_progress, ll_container, false);
        setResult(RESULT_OK, createIntentForActivityResult());
        finish();
    }

    @Override
    public void setAnswersFailure(Object object) {
        if (object instanceof IOException) {
            //TODO handle 422 error (sending empty questionnaire)
        }
        UIHelper.showProgress(this, v_progress, ll_container, false);
        setResult(RESULT_CANCELED, createIntentForActivityResult());
        finish();
    }


    private void setupCircleIndicator(int position) {
        pb_questions_progress.setProgress(position);
    }

    private void backDialog() {

        if (backAlertDialog != null && backAlertDialog.isShowing()) {
            backAlertDialog.dismiss();
        }

        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setMessage(R.string.alert_back_dialog_message)
                .setTitle(null);
        builder.setPositiveButton(R.string.alert_back_dialog_yes_button, new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
                setResult(RESULT_CANCELED);
                finish();
            }
        });
        builder.setNegativeButton(R.string.alert_back_dialog_no_button, new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
                // User cancelled the dialog
                backAlertDialog.dismiss();
            }
        });

        backAlertDialog = builder.create();
        backAlertDialog.show();
        backAlertDialog.getButton(AlertDialog.BUTTON_NEGATIVE).setTextColor(ContextCompat.getColor(this, R.color.colorAccent));
        backAlertDialog.getButton(AlertDialog.BUTTON_POSITIVE).setTextColor(ContextCompat.getColor(this, R.color.colorAccent));
    }

    private void settingActionBar() {
        ActionBar actionBar = getSupportActionBar();
        if (actionBar != null) {
            actionBar.setDisplayHomeAsUpEnabled(true);
            actionBar.setDisplayShowHomeEnabled(true);
        }
    }

    public boolean onOptionsItemSelected(MenuItem menuItem) {
        switch (menuItem.getItemId()) {
            case android.R.id.home:
                onBackPressed();
                return true;
            default:
                return super.onOptionsItemSelected(menuItem);
        }
    }

    @OnClick(R.id.bt_skip)
    public void bt_skip() {
        changeToNextPage();
    }

    @OnClick(R.id.bt_back)
    public void bt_back() {
        changeToPreviousPage();
    }

    @Override
    public void onBackPressed() {
        backDialog();
    }

    public void changeToPage(int position) {
        rv_question_page.smoothScrollToPosition(position);
    }

    public void changeToNextPage() {
        if (currentQuestionPage < questionnaire.getQuestions().size() - 1) {
            currentQuestionPage++;
            changeToPage(currentQuestionPage);
        }
    }

    public void changeToPreviousPage() {
        if (currentQuestionPage >= 1) {
            currentQuestionPage--;
            changeToPage(currentQuestionPage);
        }
    }
}