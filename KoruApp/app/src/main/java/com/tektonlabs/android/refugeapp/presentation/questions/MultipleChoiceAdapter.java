
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
import android.support.v4.content.ContextCompat;
import android.support.v4.view.ViewCompat;
import android.support.v7.widget.AppCompatEditText;
import android.support.v7.widget.RecyclerView;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.TextView;
import com.tektonlabs.android.refugeapp.R;
import com.tektonlabs.android.refugeapp.data.network.models.Answer;
import com.tektonlabs.android.refugeapp.data.network.models.Question;
import java.util.List;
import butterknife.BindView;
import butterknife.ButterKnife;

public class MultipleChoiceAdapter extends RecyclerView.Adapter<MultipleChoiceAdapter.MultipleChoiceViewHolder> {

    private List<Answer> answerList;
    private Question question;
    private Context context;
    private QuestionAdapter questionAdapter;
    private ColorStateList colorStateList;

    public MultipleChoiceAdapter(Question question, Context context, QuestionAdapter questionAdapter) {
        this.question = question;
        answerList = question.getAnswers();
        this.context = context;
        this.questionAdapter = questionAdapter;
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

    @Override
    public MultipleChoiceViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(context).inflate(R.layout.check_box_row, parent, false);
        return new MultipleChoiceViewHolder(view);
    }

    @Override
    public void onBindViewHolder(final MultipleChoiceViewHolder holder, int pos) {
        int position = holder.getLayoutPosition();
        final Answer answer = answerList.get(position);

        setupEditText(holder,answer);
        setupChechBox(holder,answer,position);

    }

    private void setupEditText(final MultipleChoiceViewHolder holder, final Answer answer){
        holder.et_answer_value.setText(answer.getAnswerValue());
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
                answer.setAnswerValue(editable.toString());
                questionAdapter.addSelectedAnswer(question.getId(), answer);
            }
        });


        if (answer.getWithValue()) {
            holder.et_answer_value.setVisibility(View.VISIBLE);
            if (answer.isSelected()) {
                holder.et_answer_value.setEnabled(true);
            } else {
                holder.et_answer_value.setEnabled(false);
            }

        } else {
            holder.et_answer_value.setVisibility(View.GONE);
        }
    }

    private void setupChechBox(final MultipleChoiceViewHolder holder, final Answer answer, int position){
        holder.cb_option.setChecked(answer.isSelected());
        holder.cb_option.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton compoundButton, boolean checked) {
                if (!checked) {
                    holder.et_answer_value.setEnabled(false);
                    answer.setAnswerValue(null);
                    holder.et_answer_value.setText("");
                    questionAdapter.removeAnswerFromSelectedAnswers(question.getId(), answer);
                } else {
                    holder.et_answer_value.setEnabled(true);
                    questionAdapter.addSelectedAnswer(question.getId(), answer);
                }
            }
        });

        holder.tv_option.setText(answerList.get(position).getName());
    }

    @Override
    public int getItemCount() {
        return answerList.size();
    }

    static class MultipleChoiceViewHolder extends RecyclerView.ViewHolder {
        @BindView(R.id.tv_option)
        TextView tv_option;

        @BindView(R.id.cb_option)
        CheckBox cb_option;

        @BindView(R.id.et_answer_value)
        AppCompatEditText et_answer_value;


        public MultipleChoiceViewHolder(View itemView) {
            super(itemView);
            ButterKnife.bind(this, itemView);
        }
    }
}
