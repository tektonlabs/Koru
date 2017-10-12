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

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.design.widget.Snackbar;
import android.support.v4.app.Fragment;
import android.support.v7.widget.CardView;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import com.tektonlabs.android.refugeapp.R;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.Contact;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.CreateShelterActivity;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.interfaces.CreateShelterViewContract;
import com.tektonlabs.android.refugeapp.presentation.create_shelters.adapter.ContactAdapter;
import com.tektonlabs.android.refugeapp.presentation.create_contact.CreateContactActivity;
import com.tektonlabs.android.refugeapp.utils.Constants;
import com.tektonlabs.android.refugeapp.utils.UIHelper;
import java.util.ArrayList;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;


public class CreateShelterStep3Fragment extends Fragment implements CreateShelterViewContract.ThirdStepView, CreateShelterStepListener.UserActionListener, ContactAdapter.OnCardClickListener,
        ContactAdapter.OnRemoveCardListener {
    @BindView(R.id.bt_primary_contact)
    Button bt_primary_contact;
    @BindView(R.id.rv_secondary)
    RecyclerView rv_secondary;
    @BindView(R.id.cv_primary)
    CardView cv_primary;
    @BindView(R.id.tv_primary_name)
    TextView tv_primary_name;
    @BindView(R.id.tv_primary_phone)
    TextView tv_primary_phone;
    @BindView(R.id.tv_primary_mail)
    TextView tv_primary_mail;
    @BindView(R.id.ll_container)
    LinearLayout ll_container;

    ContactAdapter adapter;

    Contact primary;
    int positionSecondaryContactClicked = -1;
    ArrayList<Contact> secondary_contacts = new ArrayList<>();

    private CreateShelterStepListener.ThirdStepView fragmentListener;

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        if (context instanceof CreateShelterStepListener.ThirdStepView) {
            fragmentListener = (CreateShelterStepListener.ThirdStepView) context;

        } else {
            throw new RuntimeException(context.toString()
                    + " must implement OnFragmentInteractionListener");
        }
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_new_shelter_step_3, container, false);
        ButterKnife.bind(this, v);
        fragmentListener.onFragmentReady(this);

        UIHelper.hideKeyboardActivity(getActivity());

        rv_secondary.setNestedScrollingEnabled(false);
        initializeRv();

        return v;
    }

    @OnClick(R.id.bt_primary_contact)
    public void bt_primary_contact_on_click() {
        Intent i = new Intent(getActivity(), CreateContactActivity.class);
        i.putExtra(Constants.PRIMARY_CONTACT, true);
        startActivityForResult(i, Constants.PRIMARY_CONTACT_REQUEST_CODE);
    }

    @OnClick(R.id.bt_secondary_contact)
    public void bt_secondary_contact_on_click() {
        Intent i = new Intent(getActivity(), CreateContactActivity.class);
        i.putExtra(Constants.PRIMARY_CONTACT, false);
        startActivityForResult(i, Constants.SECONDARY_CONTACT_REQUEST_CODE);
    }

    @OnClick(R.id.cv_primary)
    public void cv_primary_on_click() {
        Intent i = new Intent(getActivity(), CreateContactActivity.class);
        i.putExtra(Constants.PRIMARY_CONTACT, true);
        if (primary != null) {
            i.putExtra(Constants.EXTRA_CONTACT, primary);
        }
        startActivityForResult(i, Constants.PRIMARY_CONTACT_REQUEST_CODE);
    }

    @OnClick(R.id.iv_remove)
    public void iv_remove_on_click() {
        primary = null;
        cv_primary.setVisibility(View.GONE);
        bt_primary_contact.setVisibility(View.VISIBLE);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == Constants.PRIMARY_CONTACT_REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                primary = (Contact) data.getSerializableExtra(Constants.EXTRA_CONTACT);
                setPrimaryContactData(primary);
            }
        }
        if (requestCode == Constants.SECONDARY_CONTACT_REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                if (data.getBooleanExtra(Constants.EDIT_CONTACT, false)) {
                    secondary_contacts.set(positionSecondaryContactClicked, (Contact) data.getSerializableExtra(Constants.EXTRA_CONTACT));
                    updateContactInRv((Contact) data.getSerializableExtra(Constants.EXTRA_CONTACT), positionSecondaryContactClicked);
                } else {
                    secondary_contacts.add((Contact) data.getSerializableExtra(Constants.EXTRA_CONTACT));
                    setDataToRv((Contact) data.getSerializableExtra(Constants.EXTRA_CONTACT));
                }
            }
        }
    }

    private void initializeRv() {
        adapter = new ContactAdapter(this, this);
        rv_secondary.setLayoutManager(new LinearLayoutManager(getActivity()));
        rv_secondary.setAdapter(adapter);
    }

    private void setDataToRv(Contact contact) {
        rv_secondary.setVisibility(View.VISIBLE);
        adapter.addContact(contact);
    }

    private void updateContactInRv(Contact contact, int position) {
        adapter.updateContact(contact, position);
    }

    private void setPrimaryContactData(Contact primary) {
        cv_primary.setVisibility(View.VISIBLE);
        bt_primary_contact.setVisibility(View.GONE);

        tv_primary_name.setText(primary.getName());
        tv_primary_phone.setText(primary.getPhone());
        tv_primary_mail.setText(primary.getEmail());
    }

    public boolean validationsThirdStep() {
        return !((CreateShelterActivity) getActivity()).getCreateShelterPresenter().validateThirdStep(primary, secondary_contacts);
    }

    @Override
    public boolean validateFields() {
        return validationsThirdStep();
    }

    @Override
    public void primaryContactEmpty() {
        showSnackbarMessage(R.string.snakcbar_no_primary_contact);
    }

    private void showSnackbarMessage(int message) {
        Snackbar.make(ll_container,
                message, Snackbar.LENGTH_LONG)
                .show();
    }

    @Override
    public void EditSecondaryContactClick(int position) {
        positionSecondaryContactClicked = position;
        Intent i = new Intent(getActivity(), CreateContactActivity.class);
        i.putExtra(Constants.PRIMARY_CONTACT, false);
        i.putExtra(Constants.EXTRA_CONTACT, adapter.getData().get(position));
        startActivityForResult(i, Constants.SECONDARY_CONTACT_REQUEST_CODE);
    }

    @Override
    public void removeSecondaryClick(int position) {
        secondary_contacts.remove(position);
    }
}
