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
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import com.tektonlabs.android.refugeapp.R;
import com.tektonlabs.android.refugeapp.data.network.models.Question;
import java.util.ArrayList;
import java.util.List;
import butterknife.BindView;
import butterknife.ButterKnife;

public class QuestionsPagerAdapter extends RecyclerView.Adapter<QuestionsPagerAdapter.MyViewHolder> {

    private final LayoutInflater inflater;
    private final Context context;
    private List<Question> data = new ArrayList<>();
    private QuestionPagerListener questionPagerListener;
    private QuestionAdapter questionAdapter;

    QuestionsPagerAdapter(List<Question> data, Context context, QuestionPagerListener questionPagerListener) {
        this.context = context;
        this.data = data;
        this.questionPagerListener = questionPagerListener;
        this.inflater = LayoutInflater.from(context);
    }

    public List<Question> getData() {
        return data;
    }

    @Override
    public int getItemCount() {
        return data.size();
    }

    @Override
    public QuestionsPagerAdapter.MyViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        int layout = R.layout.question_page_row;
        View view = inflater.inflate(layout, parent, false);
        return new MyViewHolder(view, questionPagerListener);
    }

    @Override
    public void onBindViewHolder(QuestionsPagerAdapter.MyViewHolder holder, int p) {
        final int position = holder.getAdapterPosition();
        final Question question = data.get(position);
        questionAdapter = new QuestionAdapter(question, context,questionPagerListener);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(context);
        holder.rv_questions.setLayoutManager(linearLayoutManager);

        holder.rv_questions.setAdapter(questionAdapter);
        if (position == data.size() - 1) {
            holder.btn_send.setVisibility(View.VISIBLE);
        } else {
            holder.btn_send.setVisibility(View.GONE);
        }
    }

    class MyViewHolder extends RecyclerView.ViewHolder {

        // For multiple choice
        @BindView(R.id.rv_questions)
        RecyclerView rv_questions;

        @BindView(R.id.btn_send)
        Button btn_send;


        public MyViewHolder(View itemView, final QuestionPagerListener questionPagerListener) {
            super(itemView);
            ButterKnife.bind(this, itemView);
            btn_send.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    questionPagerListener.onSendAnswersClicked();
                }
            });
        }
    }

    interface QuestionPagerListener {
        void onSendAnswersClicked();
        void switchToNexPage();
    }
}