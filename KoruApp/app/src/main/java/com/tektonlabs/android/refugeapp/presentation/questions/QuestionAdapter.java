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


import android.content.Context;
import android.content.res.ColorStateList;
import android.graphics.Color;
import android.os.Build;
import android.support.v4.content.ContextCompat;
import android.support.v4.view.ViewCompat;
import android.support.v4.widget.CompoundButtonCompat;
import android.support.v7.widget.AppCompatEditText;
import android.support.v7.widget.AppCompatRadioButton;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;
import com.tektonlabs.android.refugeapp.R;
import com.tektonlabs.android.refugeapp.data.network.models.Answer;
import com.tektonlabs.android.refugeapp.data.network.models.Question;
import com.tektonlabs.android.refugeapp.utils.Constants;
import java.util.ArrayList;
import java.util.List;
import butterknife.BindView;
import butterknife.ButterKnife;

public class QuestionAdapter extends RecyclerView.Adapter<QuestionAdapter.MyViewHolder> {

    private final LayoutInflater inflater;
    private final Context context;
    private List<Question> questions = new ArrayList<>();
    private Question mainQuestion;
    private QuestionsPagerAdapter.QuestionPagerListener questionPagerListener;
    private ColorStateList colorStateList;

    public QuestionAdapter(Question mainQuestion, Context context, QuestionsPagerAdapter.QuestionPagerListener questionPagerListener) {
        this.context = context;
        this.mainQuestion = mainQuestion;
        setQuestionForAdapter(mainQuestion);
        this.inflater = LayoutInflater.from(context);
        this.questionPagerListener = questionPagerListener;
        createColorStateList();
    }

    private void createColorStateList(){
        colorStateList = new ColorStateList(
                new int[][]{
                        new int[]{android.R.attr.state_enabled} //enabled
                },
                new int[]{ContextCompat.getColor(context, android.R.color.white)}
        );
    }

    public void setQuestionForAdapter(Question mainQuestion) {
        questions.add(mainQuestion);
        if (mainQuestion.getSubQuestions() != null && !mainQuestion.getSubQuestions().isEmpty()) {
            for (Question subQuestion : mainQuestion.getSubQuestions()) {
                questions.add(subQuestion);
            }
        }
    }

    public List<Question> getQuestions() {
        return questions;
    }

    @Override
    public int getItemCount() {
        return questions.size();
    }

    @Override
    public QuestionAdapter.MyViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        int layout = R.layout.question_row;
        View view = inflater.inflate(layout, parent, false);
        return new MyViewHolder(view);
    }

    @Override
    public void onBindViewHolder(QuestionAdapter.MyViewHolder holder, int p) {
        final int position = holder.getAdapterPosition();
        final Question question = questions.get(position);

        holder.setUpGone();

        if (position == 0) {
            holder.tv_question.setGravity(Gravity.CENTER);
        }

        if (question.getAnswers() != null && !question.getAnswers().isEmpty()) {
            holder.tv_question.setText(question.getText());
            if (question.getQuestionType().equals(Constants.SINGLE_CHOICE)) {
                if ((question.getMax_value() != null && !question.getMax_value().isEmpty()) || (question.getMin_value() != null && !question.getMin_value().isEmpty())) {
                    setupMinAndMaxValues(holder,question);
                } else {
                    setupRadioGroup(holder,question);
                }
            } else if (question.getQuestionType().equals(Constants.MULTIPLE_CHOICE)) {
                holder.rv_multiple_choice.setVisibility(View.VISIBLE);
                createCheckBoxesOptions(question, holder.rv_multiple_choice);
            }

        } else {
            holder.tv_question.setText(question.getText());
            if (question.getQuestionType().equals(Constants.FILL_CHOICE)) {
                setupEditText(holder,question,position);
            }
        }
    }

    private void setupMinAndMaxValues(MyViewHolder holder, final Question question) {
        holder.ll_horizontal_single_choice.setVisibility(View.VISIBLE);
        holder.tv_min_value.setText(question.getMin_value());
        holder.tv_max_value.setText(question.getMax_value());
        createRadioGroupOptions(question.getAnswers(), holder.rg_options_horizontal);
        holder.rg_options_horizontal.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup radioGroup, int i) {
                Answer selectedAnswer = getSelectedAnswer(radioGroup.getCheckedRadioButtonId(), question.getAnswers());
                question.setSelectedAnswer(selectedAnswer);
                setSelectedAnswer(question.getId(), selectedAnswer);
                if (canSwitchToNextPage()) {
                    questionPagerListener.switchToNexPage();
                }
            }
        });
    }

    private void setupEditText(MyViewHolder holder, final Question question, final int position) {
        holder.et_answer_value.setVisibility(View.VISIBLE);
        holder.et_answer_value.setText(question.getAnswerValue());
        ViewCompat.setBackgroundTintList(holder.et_answer_value, colorStateList);

        holder.et_answer_value.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void afterTextChanged(Editable editable) {
                question.setAnswerValue(editable.toString());
                questions.set(position, question);
            }
        });
    }

    private void setupRadioGroup(MyViewHolder holder, final Question question) {
        holder.rg_options_vertical.setVisibility(View.VISIBLE);
        createRadioGroupOptions(question.getAnswers(), holder.rg_options_vertical);
        holder.rg_options_vertical.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup radioGroup, int i) {
                Answer selectedAnswer = getSelectedAnswer(radioGroup.getCheckedRadioButtonId(), question.getAnswers());
                question.setSelectedAnswer(selectedAnswer);
                setSelectedAnswer(question.getId(), selectedAnswer);
                if (canSwitchToNextPage()) {
                    questionPagerListener.switchToNexPage();
                }
            }
        });
    }

    private Answer getSelectedAnswer(int selectedAnswerId, List<Answer> answers) {
        for (Answer answer : answers) {
            if (answer.getId() == selectedAnswerId) {
                return answer;
            }
        }
        return null;
    }

    public void setSelectedAnswer(int questionId, Answer selectedAnswer) {
        if (mainQuestion.getId() == questionId) {
            mainQuestion.setSelectedAnswer(selectedAnswer);
        } else if (mainQuestion.getSubQuestions() != null && !mainQuestion.getSubQuestions().isEmpty()) {
            for (Question subquestion : mainQuestion.getSubQuestions()) {
                if (subquestion.getId() == questionId) {
                    subquestion.setSelectedAnswer(selectedAnswer);
                    break;
                }
            }
        }
    }


    public void addSelectedAnswer(int questionId, Answer selectedAnswer) {
        if (mainQuestion.getId() == questionId) {
            mainQuestion.addSelectedAnswer(selectedAnswer);
        } else if (mainQuestion.getSubQuestions() != null && !mainQuestion.getSubQuestions().isEmpty()) {
            for (Question subquestion : mainQuestion.getSubQuestions()) {
                if (subquestion.getId() == questionId) {
                    subquestion.addSelectedAnswer(selectedAnswer);
                    break;
                }
            }
        }
    }

    public void removeAnswerFromSelectedAnswers(int questionId, Answer answerRemoved) {
        if (mainQuestion.getId() == questionId) {
            mainQuestion.removeFromSelectedAnswers(answerRemoved);
        } else if (mainQuestion.getSubQuestions() != null && !mainQuestion.getSubQuestions().isEmpty()) {
            for (Question subquestion : mainQuestion.getSubQuestions()) {
                if (subquestion.getId() == questionId) {
                    subquestion.removeFromSelectedAnswers(answerRemoved);
                    break;
                }
            }
        }
    }


    private boolean canSwitchToNextPage() {

        for (Question question : questions) {
            if (!question.getQuestionType().equals(Constants.SINGLE_CHOICE)) {
                return false;
            }
        }

        int countAnsweredQuestion = 0;
        int countQuestion = 0;
        for (Question question : questions) {

            if (question.getSubQuestions() == null || question.getSubQuestions().isEmpty()) {
                countQuestion++;
            }

            for (Answer answer : question.getAnswers()) {
                if (answer.isSelected()) {
                    countAnsweredQuestion++;
                }
            }
        }


        if (countAnsweredQuestion == countQuestion) {
            return true;
        } else {
            return false;
        }


    }

    private void createCheckBoxesOptions(Question question, RecyclerView rv_multiple_choice) {
        MultipleChoiceAdapter multipleChoiceAdapter = new MultipleChoiceAdapter(question, context, this);
        rv_multiple_choice.setLayoutManager(new LinearLayoutManager(context));
        rv_multiple_choice.setAdapter(multipleChoiceAdapter);
    }

    private void createRadioGroupOptions(List<Answer> answers, RadioGroup radioGroup) {
        radioGroup.removeAllViews();
        for (Answer answer : answers) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                RadioButton radioButton = new RadioButton(context);
                radioButton.setId(answer.getId());
                radioButton.setText(answer.getName());
                radioButton.setTextColor(Color.WHITE);
                radioButton.setTextSize(18);
                radioButton.setHighlightColor(Color.WHITE);
                radioButton.setButtonTintList(colorStateList);
                radioGroup.addView(radioButton);
                radioButton.setChecked(answer.isSelected());
            }else{
                AppCompatRadioButton radioButton = new AppCompatRadioButton(context);
                radioButton.setId(answer.getId());
                radioButton.setText(answer.getName());
                radioButton.setTextColor(Color.WHITE);
                radioButton.setTextSize(18);
                radioButton.setHighlightColor(Color.WHITE);
                CompoundButtonCompat.setButtonTintList(radioButton, colorStateList);
                radioGroup.addView(radioButton);
                radioButton.setChecked(answer.isSelected());
            }
        }
    }


    class MyViewHolder extends RecyclerView.ViewHolder {
        @BindView(R.id.tv_question)
        TextView tv_question;

        // For single choice with min and max
        @BindView(R.id.ll_horizontal_single_choice)
        LinearLayout ll_horizontal_single_choice;

        @BindView(R.id.tv_min_value)
        TextView tv_min_value;

        @BindView(R.id.tv_max_value)
        TextView tv_max_value;

        @BindView(R.id.rg_options_horizontal)
        RadioGroup rg_options_horizontal;


        // For single choice without min and max
        @BindView(R.id.rg_options_vertical)
        RadioGroup rg_options_vertical;

        // For multiple choice
        @BindView(R.id.rv_multiple_choice)
        RecyclerView rv_multiple_choice;

        // text input
        @BindView(R.id.et_answer_value)
        AppCompatEditText et_answer_value;

        public MyViewHolder(View itemView) {
            super(itemView);
            ButterKnife.bind(this, itemView);
        }

        private void setUpGone() {
            ll_horizontal_single_choice.setVisibility(View.GONE);
            rg_options_vertical.setVisibility(View.GONE);
            rv_multiple_choice.setVisibility(View.GONE);
            et_answer_value.setVisibility(View.GONE);
        }

    }

}