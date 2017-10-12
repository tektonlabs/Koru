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

package com.tektonlabs.android.refugeapp.presentation.shelters;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.CoordinatorLayout;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v4.view.MenuItemCompat;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.SearchView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import com.tektonlabs.android.refugeapp.R;
import com.tektonlabs.android.refugeapp.data.network.models.Shelter;
import com.tektonlabs.android.refugeapp.presentation.categories.CategoriesActivity;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.CreateShelterActivity;
import com.tektonlabs.android.refugeapp.presentation.shelters.callbacks.LoadMoreListener;
import com.tektonlabs.android.refugeapp.presentation.shelters.callbacks.SheltersViewContract;
import com.tektonlabs.android.refugeapp.utils.Constants;
import com.tektonlabs.android.refugeapp.utils.SharedPreferencesHelper;
import com.tektonlabs.android.refugeapp.utils.UIHelper;
import com.tektonlabs.android.refugeapp.utils.Utils;
import java.io.IOException;
import java.util.List;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class SheltersActivity extends PermissionLastLocationActivity implements SheltersAdapter.SheltersListener, SheltersViewContract.View {

    public static final int SHELTERS_ACTIVITY_CODE = 1;

    @BindView(R.id.rv_shelters)
    RecyclerView rv_shelters;

    @BindView(R.id.v_progress)
    View v_progress;

    @BindView(R.id.cl_main)
    CoordinatorLayout cl_main;

    @BindView(R.id.swiperefresh)
    SwipeRefreshLayout swiperefresh;

    @BindView(R.id.ll_empty_state_search)
    LinearLayout ll_empty_state_search;

    @BindView(R.id.ll_empty_state)
    LinearLayout ll_empty_state;

    @BindView(R.id.fab)
    FloatingActionButton fab;

    @BindView(R.id.pb_recyclerview)
    ProgressBar pb_recyclerview;

    private SheltersAdapter sheltersAdapter;
    private Menu menu;
    private Animation syncAnimation;
    private boolean pendingForms = false;
    private ImageView syncImageView;
    private SearchSheltersManager searchSheltersManager;
    private MenuItem searchItem;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_refugees);
        ButterKnife.bind(this);
        showFloatingActionButton();
        shelterPresenter = new ShelterPresenter(this);
        setUpRecyclerView();
        UIHelper.showProgress(this, v_progress, rv_shelters, true);
        shelterPresenter.postPendingAnswers();
        shelterPresenter.isThereAnyPendingForms();
        setupView();
    }

    private void showFloatingActionButton() {
        if (SharedPreferencesHelper.getInstance(getApplicationContext()).getRegister()) {
            fab.setVisibility(View.VISIBLE);
        } else {
            fab.setVisibility(View.GONE);
        }
    }

    private void setUpRecyclerView() {
        sheltersAdapter = new SheltersAdapter(getApplicationContext(), this);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getApplicationContext());
        rv_shelters.setLayoutManager(linearLayoutManager);
        rv_shelters.setAdapter(sheltersAdapter);

        LoadMoreListener loadMoreListener = new LoadMoreListener() {
            @Override
            public void loadMoreElements() {
                if (!searchItem.isActionViewExpanded()){
                    pb_recyclerview.setVisibility(View.VISIBLE);
                    if (location != null) {
                        shelterPresenter.requestSheltersData(String.valueOf(location.getLatitude()), String.valueOf(location.getLongitude()));
                    } else {
                        shelterPresenter.requestSheltersData("", "");
                    }
                }
             }
        };

        onScrollSheltersListener = new OnScrollSheltersListener(linearLayoutManager, loadMoreListener);
        rv_shelters.addOnScrollListener(onScrollSheltersListener);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK && data.getIntExtra(Constants.QUESTIONARY_FINISHED, 0) == Constants.QUESTIONARY_FINISHED_CODE) {
            showSnackbarMessage(R.string.form_sent_successfully);
        } else if (resultCode == RESULT_CANCELED && data != null &&
                data.getIntExtra(Constants.QUESTIONARY_FINISHED, 0) == Constants.QUESTIONARY_FINISHED_CODE) {
            showSnackbarMessage(R.string.form_not_sent_successfully);
            shelterPresenter.resetOffset();
            sheltersAdapter.clearAdapterData();
            requestSheltersData();
            arePendingFormsLeft(true);
        } else if (resultCode == RESULT_OK && requestCode == Constants.CREATE_SHELTER_CODE) {
            showSnackbarMessage(R.string.shelter_created_successfully);
            shelterPresenter.resetOffset();
            sheltersAdapter.clearAdapterData();
            requestSheltersData();
        } else if (resultCode == RESULT_CANCELED && requestCode == Constants.CREATE_SHELTER_CODE) {
            showSnackbarMessage(R.string.shelter_created_canceled);
        }
    }

    private void requestSheltersData() {
        if (searchItem.isActionViewExpanded()){
            shelterPresenter.searchShelters(searchSheltersManager.getLastSearch());
        }else{
            if (location != null) {
                shelterPresenter.requestSheltersData(String.valueOf(location.getLatitude()), String.valueOf(location.getLongitude()));
            } else {
                shelterPresenter.requestSheltersData("", "");
            }
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        this.menu = menu;
        inflater.inflate(R.menu.shelters_menu, menu);
        searchItem = menu.findItem(R.id.action_search);
        final SearchView searchView = (SearchView) MenuItemCompat.getActionView(searchItem);
        searchSheltersManager = new SearchSheltersManager(searchView, shelterPresenter);
        searchView.setOnQueryTextListener(searchSheltersManager);
        MenuItem syncItem = menu.findItem(R.id.action_sync);
        onCancelSearchListener(searchItem, syncItem);
        if (!pendingForms) {
            syncItem.setVisible(false);
        }

        return super.onCreateOptionsMenu(menu);
    }

    private void onCancelSearchListener(MenuItem searchItem, final MenuItem syncItem) {
        MenuItemCompat.setOnActionExpandListener(searchItem, new MenuItemCompat.OnActionExpandListener() {
            @Override
            public boolean onMenuItemActionExpand(MenuItem menuItem) {
                syncItem.setVisible(false);
                return true;
            }

            @Override
            public boolean onMenuItemActionCollapse(MenuItem menuItem) {
                shelterPresenter.resetOffset();
                sheltersAdapter.clearAdapterData();
                syncItem.setVisible(true);
                if (location != null) {
                    shelterPresenter.requestSheltersData(String.valueOf(location.getLatitude()), String.valueOf(location.getLongitude()));
                } else {
                    shelterPresenter.requestSheltersData("", "");
                }
                invalidateOptionsMenu();
                return true;
            }
        });
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.action_sync:
                setEnableSearchMenuItem(menu, false);
                setImageActionToSyncMenuItem();
                animateSyncIcon(syncImageView);
                shelterPresenter.postPendingAnswers();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    private void setEnableSearchMenuItem(Menu menu, boolean enable) {
        if (menu != null) {
            MenuItem searchItem = menu.findItem(R.id.action_search);
            searchItem.setEnabled(enable);
        }
    }

    private void setImageActionToSyncMenuItem() {
        MenuItem item = menu.findItem(R.id.action_sync);
        if (item.getActionView() == null) {
            LayoutInflater layoutInflater = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            syncImageView = (ImageView) layoutInflater.inflate(R.layout.action_sync, null);
            item.setActionView(syncImageView);
        }
    }

    private void setupView() {
        swiperefresh.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                shelterPresenter.resetOffset();
                sheltersAdapter.clearAdapterData();
                sheltersAdapter.notifyDataSetChanged();
                requestSheltersData();
            }
        });
    }

    @Override
    public void onShelterClicked(int position) {
        if (position < sheltersAdapter.getShelterList().size()) {
            int id = sheltersAdapter.getShelterList().get(position).getId();
            Intent intent = new Intent(this, CategoriesActivity.class);
            intent.putExtra(Constants.SHELTER_ID, id);
            startActivityForResult(intent, SHELTERS_ACTIVITY_CODE);
        }
    }

    @Override
    public void setSheltersData(List<Shelter> shelterList) {
        pb_recyclerview.setVisibility(View.GONE);
        sheltersAdapter.setShelterList(shelterList);
        UIHelper.showProgress(this, v_progress, rv_shelters, false);
        checkForEmptyList();
        checkForEmptyListSearch();
        swiperefresh.setRefreshing(false);
    }

    @Override
    public void setNoSheltersData(Object object) {
        if (object instanceof IOException) {
            Log.d("refugeapp", "error: " + object.toString());
            Utils.showToast(this, getString(R.string.connection_error));
        } else {
            //TODO Implemente other scenearios
            Utils.showToast(this, getString(R.string.internal_error));
        }
        pb_recyclerview.setVisibility(View.GONE);
        UIHelper.showProgress(this, v_progress, rv_shelters, false);
        checkForEmptyList();
        swiperefresh.setRefreshing(false);
    }

    @Override
    public void questionsAnsweredSuccess(Object object, int shelterId) {
        sheltersAdapter.reducePendingCount(shelterId);
        showSnackbarMessage(R.string.form_sent_successfully);
        shelterPresenter.isThereAnyPendingForms();
        stopSyncIcon();
        setEnableSearchMenuItem(menu, true);
        invalidateOptionsMenu();
    }

    @Override
    public void questionsAnsweredFailure(Object object) {
        showSnackbarMessage(R.string.form_not_sent_successfully);
        stopSyncIcon();
        setEnableSearchMenuItem(menu, true);
        invalidateOptionsMenu();
    }

    private void showSnackbarMessage(int message) {
        Snackbar.make(cl_main,
                message, Snackbar.LENGTH_LONG)
                .show();
    }

    public void setSheltersSearchResult(List<Shelter> shelterList) {
        sheltersAdapter.clearAdapterData();
        sheltersAdapter.setShelterList(shelterList);
        swiperefresh.setRefreshing(false);
        checkForEmptyListSearch();
    }

    @Override
    public void setNoSheltersSearchResult(Object object, String text) {
        swiperefresh.setRefreshing(false);
        checkForEmptyListSearch();
    }

    @Override
    public void arePendingFormsLeft(boolean pendingForms) {
        this.pendingForms = pendingForms;
        invalidateOptionsMenu();
    }


    private void animateSyncIcon(ImageView iv) {
        syncAnimation = AnimationUtils.loadAnimation(this, R.anim.spin);
        syncAnimation.setRepeatCount(Animation.INFINITE);
        iv.startAnimation(syncAnimation);
    }

    private void stopSyncIcon() {
        if (syncAnimation != null) {
            syncAnimation.cancel();
            syncAnimation.reset();
            syncImageView.clearAnimation();
            invalidateOptionsMenu();
        }
    }

    public void checkForEmptyListSearch() {
        if (sheltersAdapter.getItemCount() == 0) {
            setEmptyStateSearch(true);
        } else {
            setEmptyStateSearch(false);
        }
    }

    public void checkForEmptyList() {
        if (sheltersAdapter.getItemCount() == 0) {
            setEmptyState(true);
        } else {
            setEmptyState(false);
        }
    }

    public void setEmptyStateSearch(boolean showEmptyState) {
        ll_empty_state_search.setVisibility(showEmptyState ? View.VISIBLE : View.GONE);
        rv_shelters.setVisibility(showEmptyState ? View.GONE : View.VISIBLE);
    }

    public void setEmptyState(boolean showEmptyState) {
        ll_empty_state.setVisibility(showEmptyState ? View.VISIBLE : View.GONE);
        rv_shelters.setVisibility(showEmptyState ? View.GONE : View.VISIBLE);
    }

    @OnClick(R.id.fab)
    public void fabOnClick() {
        Intent i = new Intent(this, CreateShelterActivity.class);
        startActivityForResult(i, Constants.CREATE_SHELTER_CODE);
    }
}
