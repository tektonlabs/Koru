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

package com.tektonlabs.android.refugeapp.presentation.create_shelters;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.support.v4.app.Fragment;
import android.support.v4.content.ContextCompat;
import android.support.v4.view.ViewPager;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import com.badoualy.stepperindicator.StepperIndicator;
import com.tektonlabs.android.refugeapp.R;
import com.tektonlabs.android.refugeapp.data.network.models.create_shelter.shelter_data.DataForShelterCreation;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.adapter.CreateSheltersPagerAdapter;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.adapter.TagAdapter;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.fragments.CreateShelterStep1Fragment;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.fragments.CreateShelterStep2Fragment;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.fragments.CreateShelterStep3Fragment;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.fragments.CreateShelterStep4Fragment;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.fragments.CreateShelterStep5Fragment;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.fragments.CreateShelterStep6Fragment;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.fragments.CreateShelterStepListener;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.interfaces.BaseStepView;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.interfaces.CreateShelterViewContract;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.interfaces.CreateShelterViewContractActivity;
import com.tektonlabs.android.refugeapp.utils.NonSwipeableViewPager;
import com.tektonlabs.android.refugeapp.utils.Utils;
import java.util.List;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class CreateShelterActivity extends AppCompatActivity implements CreateShelterStepListener.FirstStepView, CreateShelterStepListener.SecondStepView, CreateShelterStepListener.ThirdStepView,
        CreateShelterStepListener.FourthStepView, CreateShelterStepListener.FifthStepView, CreateShelterStepListener.SixthStepView, BaseStepView, CreateShelterViewContract.View, CreateShelterViewContractActivity.View,
        TagAdapter.OnTextChangedListener{

    @BindView(R.id.viewPager)
    NonSwipeableViewPager viewPager;
    @BindView(R.id.indicator)
    StepperIndicator indicator;
    @BindView(R.id.bt_next)
    LinearLayout bt_next;
    @BindView(R.id.bt_back)
    LinearLayout bt_back;
    @BindView(R.id.v_progress)
    ProgressBar v_progress;
    @BindView(R.id.ll_empty_container)
    LinearLayout ll_empty_container;
    @BindView(R.id.rl_navigation)
    RelativeLayout rl_navigation;

    private CreateSheltersPagerAdapter adapter;
    private CreateShelterPresenter createShelterPresenter;
    private CreateShelterPresenterActivity createShelterPresenterActivity;

    private Fragment[] fragments = new Fragment[6];

    private AlertDialog backAlertDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_shelter);
        ButterKnife.bind(this);
        bt_back.setVisibility(View.GONE);
        createShelterPresenter = new CreateShelterPresenter(this, this);
        createShelterPresenterActivity = new CreateShelterPresenterActivity(this);
        viewPager.setVisibility(View.GONE);
        v_progress.setVisibility(View.VISIBLE);
        createShelterPresenterActivity.requestData();
        if (getSupportActionBar() != null) {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            getSupportActionBar().setTitle(getString(R.string.new_refuge_title));
        }
    }

    public CreateShelterPresenter getCreateShelterPresenter() {
        return createShelterPresenter;
    }

    private void setupViews(DataForShelterCreation getShelterDataForCreation) {
        adapter = new CreateSheltersPagerAdapter(getSupportFragmentManager(), getShelterDataForCreation);

        viewPager.setAdapter(adapter);
        viewPager.setOffscreenPageLimit(6);

        indicator.setViewPager(viewPager);

        viewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
                checkForLastAndFirstPage();
            }

            @Override
            public void onPageSelected(int position) {
            }

            @Override
            public void onPageScrollStateChanged(int state) {
            }
        });
    }

    private void checkForLastAndFirstPage() {
        bt_back.setVisibility(viewPager.getCurrentItem() == 0 ? View.GONE : View.VISIBLE);
        bt_next.setVisibility(viewPager.getCurrentItem() == 5 ? View.GONE : View.VISIBLE);
    }

    @OnClick(R.id.bt_back)
    public void bt_back_on_click() {
        if (viewPager.getCurrentItem() != 0) {
            viewPager.setCurrentItem(viewPager.getCurrentItem() - 1);
        }
    }

    @OnClick(R.id.bt_next)
    public void bt_next_on_click() {
        createShelterPresenter.setBaseStepView((BaseStepView) fragments[viewPager.getCurrentItem()]);
        if (((CreateShelterStepListener.UserActionListener) (fragments[viewPager.getCurrentItem()])).validateFields()) {
            viewPager.setCurrentItem(viewPager.getCurrentItem() + 1);
        }
    }

    @Override
    public void onFragmentReady(Fragment fragment) {
        addUserActionListener(fragment);
    }


    private void addUserActionListener(Fragment fragment) {
        if (fragment instanceof CreateShelterStep1Fragment) {
            fragments[0] = fragment;
        }
        if (fragment instanceof CreateShelterStep2Fragment) {
            fragments[1] = fragment;
        }
        if (fragment instanceof CreateShelterStep3Fragment) {
            fragments[2] = fragment;
        }
        if (fragment instanceof CreateShelterStep4Fragment) {
            fragments[3] = fragment;
        }
        if (fragment instanceof CreateShelterStep5Fragment) {
            fragments[4] = fragment;
        }
        if (fragment instanceof CreateShelterStep6Fragment) {
            fragments[5] = fragment;
        }
    }

    private void backDialog() {

        if (backAlertDialog != null && backAlertDialog.isShowing()) {
            backAlertDialog.dismiss();
        }

        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setMessage(R.string.create_shelter_dialog_title)
                .setTitle(R.string.exit_creation_form);
        builder.setPositiveButton(R.string.dialog_exit, new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
                setResult(RESULT_CANCELED);
                finish();
            }
        });
        builder.setNegativeButton(getString(R.string.dialog_cancel), new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
                backAlertDialog.dismiss();
            }
        });

        backAlertDialog = builder.create();
        backAlertDialog.show();
        backAlertDialog.getButton(AlertDialog.BUTTON_NEGATIVE).setTextColor(ContextCompat.getColor(this, R.color.colorAccent));
        backAlertDialog.getButton(AlertDialog.BUTTON_POSITIVE).setTextColor(ContextCompat.getColor(this, R.color.colorAccent));
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                backDialog();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    @Override
    public void onBackPressed() {
        if (viewPager.getCurrentItem() != 0) {
            viewPager.setCurrentItem(viewPager.getCurrentItem() - 1);
        } else {
            backDialog();
        }
    }

    @Override
    public void onShelterCreated(String message) {
        ((OnShelterCreated)fragments[5]).onShelterCreated();
        Intent i = new Intent();
        setResult(RESULT_OK,i);
        finish();
    }

    @Override
    public void onShelterFailure(String message) {
        if (Utils.hasInternetConnection(this)){
            Utils.showToast(this, message);
        }else{
            Utils.showToast(this, getString(R.string.shelter_no_internet));
        }
        ((OnShelterCreated)fragments[5]).onShelterFailure();
    }

    @Override
    public void onServicesAutocompleteSuccess(List<String> data) {
        ((CreateShelterStep2Fragment)fragments[1]).setDataToAdapter(data);
    }

    @Override
    public void onServicesAutocompleteFailure(Object object) {

    }

    @Override
    public void onDataSuccess(DataForShelterCreation object) {
        viewPager.setVisibility(View.VISIBLE);
        v_progress.setVisibility(View.GONE);
        setupViews(object);
        bt_next.setEnabled(true);
    }

    @Override
    public void onDataFailure(String message) {
        viewPager.setVisibility(View.VISIBLE);
        v_progress.setVisibility(View.GONE);
        ll_empty_container.setVisibility(View.VISIBLE);
        indicator.setVisibility(View.GONE);
        rl_navigation.setVisibility(View.GONE);
        bt_next.setEnabled(false);
    }

    @Override
    public void onTextChanged(String query) {
        createShelterPresenter.getServices(query);
    }

    public interface OnShelterCreated{
        void onShelterCreated();
        void onShelterFailure();
    }
}
