package com.gw.erp.datasource.vo;

import com.gw.erp.datasource.entities.Account;

public class AccountVo4List extends Account{

    private String thisMonthAmount;

    public String getThisMonthAmount() {
        return thisMonthAmount;
    }

    public void setThisMonthAmount(String thisMonthAmount) {
        this.thisMonthAmount = thisMonthAmount;
    }
}