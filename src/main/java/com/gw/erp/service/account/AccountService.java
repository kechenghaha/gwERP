package com.gw.erp.service.account;

import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.gw.erp.constants.BusinessConstants;
import com.gw.erp.constants.ExceptionConstants;
import com.gw.erp.datasource.entities.*;
import com.gw.erp.datasource.mappers.*;
import com.gw.erp.datasource.vo.AccountVo4InOutList;
import com.gw.erp.datasource.vo.AccountVo4List;
import com.gw.erp.exception.BusinessRunTimeException;
import com.gw.erp.exception.GwException;
import com.gw.erp.service.log.LogService;
import com.gw.erp.service.user.UserService;
import com.gw.erp.utils.StringUtil;
import com.gw.erp.utils.Tools;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.*;

@Service
public class AccountService {
    private Logger logger = LoggerFactory.getLogger(AccountService.class);

    @Resource
    private AccountMapper accountMapper;

    @Resource
    private AccountMapperEx accountMapperEx;

    @Resource
    private DepotHeadMapper depotHeadMapper;
    @Resource
    private DepotHeadMapperEx depotHeadMapperEx;

    @Resource
    private AccountHeadMapper accountHeadMapper;
    @Resource
    private AccountHeadMapperEx accountHeadMapperEx;

    @Resource
    private AccountItemMapper accountItemMapper;
    @Resource
    private AccountItemMapperEx accountItemMapperEx;
    @Resource
    private LogService logService;
    @Resource
    private UserService userService;

    public Account getAccount(long id) throws Exception{
        return accountMapper.selectByPrimaryKey(id);
    }

    public List<Account> getAccountListByIds(String ids)throws Exception {
        List<Long> idList = StringUtil.strToLongList(ids);
        List<Account> list = new ArrayList<>();
        try{
            AccountExample example = new AccountExample();
            example.createCriteria().andIdIn(idList);
            list = accountMapper.selectByExample(example);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list;
    }

    public List<Account> getAccount() throws Exception{
        AccountExample example = new AccountExample();
        example.createCriteria().andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
        List<Account> list=null;
        try{
            list=accountMapper.selectByExample(example);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list;

    }

    public List<AccountVo4List> select(String name, String serialNo, String remark, int offset, int rows) throws Exception{
        List<AccountVo4List> resList = new ArrayList<AccountVo4List>();
        List<AccountVo4List> list=null;
        try{
            list = accountMapperEx.selectByConditionAccount(name, serialNo, remark, offset, rows);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        String timeStr = Tools.getCurrentMonth();
        if (null != list && null !=timeStr) {
            for (AccountVo4List al : list) {
                DecimalFormat df = new DecimalFormat(".##");
                BigDecimal thisMonthAmount = getAccountSum(al.getId(), timeStr, "month").add(getAccountSumByHead(al.getId(), timeStr, "month")).add(getAccountSumByDetail(al.getId(), timeStr, "month")).add(getManyAccountSum(al.getId(), timeStr, "month"));
                String thisMonthAmountFmt = "0";
                if ((thisMonthAmount.compareTo(BigDecimal.ZERO))!=0) {
                    thisMonthAmountFmt = df.format(thisMonthAmount);
                }
                al.setThisMonthAmount(thisMonthAmountFmt);  //???????????????
                BigDecimal currentAmount = getAccountSum(al.getId(), "", "month").add(getAccountSumByHead(al.getId(), "", "month")).add(getAccountSumByDetail(al.getId(), "", "month")).add(getManyAccountSum(al.getId(), "", "month")) .add(al.getInitialAmount()) ;
                al.setCurrentAmount(currentAmount);
                resList.add(al);
            }
        }
        return resList;
    }

    public Long countAccount(String name, String serialNo, String remark)throws Exception {
        Long result=null;
        try{
            result=accountMapperEx.countsByAccount(name, serialNo, remark);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return result;
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int insertAccount(String beanJson, HttpServletRequest request)throws Exception {
        Account account = JSONObject.parseObject(beanJson, Account.class);
        if(account.getInitialAmount() == null) {
            account.setInitialAmount(BigDecimal.ZERO);
        }
        account.setIsDefault(false);
        int result=0;
        try{
            result = accountMapper.insertSelective(account);
            logService.insertLog("??????",
                    new StringBuffer(BusinessConstants.LOG_OPERATION_TYPE_ADD).append(account.getName()).toString(), request);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int updateAccount(String beanJson, Long id, HttpServletRequest request)throws Exception {
        Account account = JSONObject.parseObject(beanJson, Account.class);
        account.setId(id);
        int result=0;
        try{
            result = accountMapper.updateByPrimaryKeySelective(account);
            logService.insertLog("??????",
                    new StringBuffer(BusinessConstants.LOG_OPERATION_TYPE_EDIT).append(account.getName()).toString(), request);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int deleteAccount(Long id, HttpServletRequest request) throws Exception{
        int result=0;
        try{
            result = accountMapper.deleteByPrimaryKey(id);
            logService.insertLog("??????",
                    new StringBuffer(BusinessConstants.LOG_OPERATION_TYPE_DELETE).append(id).toString(), request);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int batchDeleteAccount(String ids, HttpServletRequest request)throws Exception {
        List<Long> idList = StringUtil.strToLongList(ids);
        AccountExample example = new AccountExample();
        example.createCriteria().andIdIn(idList);
        int result=0;
        try{
            result = accountMapper.deleteByExample(example);
            logService.insertLog("??????", "????????????,id???:" + ids, request);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }

    public int checkIsNameExist(Long id, String name)throws Exception {
        AccountExample example = new AccountExample();
        example.createCriteria().andIdNotEqualTo(id).andNameEqualTo(name).andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
        List<Account> list=null;
        try{
            list = accountMapper.selectByExample(example);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list==null?0:list.size();
    }

    public List<Account> findBySelect()throws Exception {
        AccountExample example = new AccountExample();
        example.createCriteria().andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
        example.setOrderByClause("id desc");
        List<Account> list=null;
        try{
            list = accountMapper.selectByExample(example);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list;
    }

    /**
     * ???????????????????????????-???????????????
     *
     * @param id
     * @return
     */
    public BigDecimal getAccountSum(Long id, String timeStr, String type) throws Exception{
        BigDecimal accountSum = BigDecimal.ZERO;
        try {
            DepotHeadExample example = new DepotHeadExample();
            if (!timeStr.equals("")) {
                Date bTime = StringUtil.getDateByString(timeStr + "-01 00:00:00", null);
                Date eTime = StringUtil.getDateByString(timeStr + "-31 00:00:00", null);
                Date mTime = StringUtil.getDateByString(timeStr + "-01 00:00:00", null);
                if (type.equals("month")) {
                    example.createCriteria().andAccountIdEqualTo(id).andPayTypeNotEqualTo("?????????")
                    .andOperTimeGreaterThanOrEqualTo(bTime).andOperTimeLessThanOrEqualTo(eTime)
                            .andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
                } else if (type.equals("date")) {
                    example.createCriteria().andAccountIdEqualTo(id).andPayTypeNotEqualTo("?????????")
                    .andOperTimeLessThanOrEqualTo(mTime).andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
                }
            } else {
                example.createCriteria().andAccountIdEqualTo(id).andPayTypeNotEqualTo("?????????")
                        .andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
            }
            List<DepotHead> dataList=null;
            try{
                dataList = depotHeadMapper.selectByExample(example);
            }catch(Exception e){
                GwException.readFail(logger, e);
            }
            if (dataList != null) {
                for (DepotHead depotHead : dataList) {
                    if(depotHead.getChangeAmount()!=null) {
                        accountSum = accountSum .add(depotHead.getChangeAmount()) ;
                    }
                }
            }
        } catch (DataAccessException e) {
            logger.error(">>>>>>>>>???????????????????????????", e);
        }
        return accountSum;
    }

    /**
     * ???????????????????????????-????????????????????????????????????????????????
     *
     * @param id
     * @return
     */
    public BigDecimal getAccountSumByHead(Long id, String timeStr, String type) throws Exception{
        BigDecimal accountSum = BigDecimal.ZERO;
        try {
            AccountHeadExample example = new AccountHeadExample();
            if (!timeStr.equals("")) {
                Date bTime = StringUtil.getDateByString(timeStr + "-01 00:00:00", null);
                Date eTime = StringUtil.getDateByString(timeStr + "-31 00:00:00", null);
                Date mTime = StringUtil.getDateByString(timeStr + "-01 00:00:00", null);
                if (type.equals("month")) {
                    example.createCriteria().andAccountIdEqualTo(id)
                            .andBillTimeGreaterThanOrEqualTo(bTime).andBillTimeLessThanOrEqualTo(eTime)
                            .andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
                } else if (type.equals("date")) {
                    example.createCriteria().andAccountIdEqualTo(id)
                            .andBillTimeLessThanOrEqualTo(mTime)
                            .andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
                }
            } else {
                example.createCriteria().andAccountIdEqualTo(id)
                        .andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
            }
            List<AccountHead> dataList=null;
            try{
                dataList = accountHeadMapper.selectByExample(example);
            }catch(Exception e){
                GwException.readFail(logger, e);
            }
            if (dataList != null) {
                for (AccountHead accountHead : dataList) {
                    if(accountHead.getChangeAmount()!=null) {
                        accountSum = accountSum.add(accountHead.getChangeAmount());
                    }
                }
            }
        } catch (DataAccessException e) {
            logger.error(">>>>>>>>>???????????????????????????", e);
        }
        return accountSum;
    }

    /**
     * ???????????????????????????-???????????????????????????????????????????????????????????????
     *
     * @param id
     * @return
     */
    public BigDecimal getAccountSumByDetail(Long id, String timeStr, String type)throws Exception {
        BigDecimal accountSum =BigDecimal.ZERO ;
        try {
            AccountHeadExample example = new AccountHeadExample();
            if (!timeStr.equals("")) {
                Date bTime = StringUtil.getDateByString(timeStr + "-01 00:00:00", null);
                Date eTime = StringUtil.getDateByString(timeStr + "-31 00:00:00", null);
                Date mTime = StringUtil.getDateByString(timeStr + "-01 00:00:00", null);
                if (type.equals("month")) {
                    example.createCriteria().andBillTimeGreaterThanOrEqualTo(bTime).andBillTimeLessThanOrEqualTo(eTime)
                            .andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
                } else if (type.equals("date")) {
                    example.createCriteria().andBillTimeLessThanOrEqualTo(mTime)
                            .andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
                }
            }
            List<AccountHead> dataList=null;
            try{
                dataList = accountHeadMapper.selectByExample(example);
            }catch(Exception e){
                GwException.readFail(logger, e);
            }
            if (dataList != null) {
                String ids = "";
                for (AccountHead accountHead : dataList) {
                    ids = ids + accountHead.getId() + ",";
                }
                if (!ids.equals("")) {
                    ids = ids.substring(0, ids.length() - 1);
                }
                AccountItemExample exampleAi = new AccountItemExample();
                if (!ids.equals("")) {
                    List<Long> idList = StringUtil.strToLongList(ids);
                    exampleAi.createCriteria().andAccountIdEqualTo(id).andHeaderIdIn(idList)
                            .andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
                    List<AccountItem> dataListOne = accountItemMapper.selectByExample(exampleAi);
                    if (dataListOne != null) {
                        for (AccountItem accountItem : dataListOne) {
                            if(accountItem.getEachAmount()!=null) {
                                accountSum = accountSum.add(accountItem.getEachAmount());
                            }
                        }
                    }
                }
            }
        } catch (DataAccessException e) {
            logger.error(">>>>>>>>>???????????????????????????", e);
        } catch (Exception e) {
            logger.error(">>>>>>>>>???????????????", e);
        }
        return accountSum;
    }

    /**
     * ???????????????????????????-????????????????????????
     *
     * @param id
     * @return
     */
    public BigDecimal getManyAccountSum(Long id, String timeStr, String type)throws Exception {
        BigDecimal accountSum = BigDecimal.ZERO;
        try {
            DepotHeadExample example = new DepotHeadExample();
            if (!timeStr.equals("")) {
                Date bTime = StringUtil.getDateByString(timeStr + "-01 00:00:00", null);
                Date eTime = StringUtil.getDateByString(timeStr + "-31 00:00:00", null);
                Date mTime = StringUtil.getDateByString(timeStr + "-01 00:00:00", null);
                if (type.equals("month")) {
                    example.createCriteria().andAccountIdListLike("%" +id.toString() + "%")
                            .andOperTimeGreaterThanOrEqualTo(bTime).andOperTimeLessThanOrEqualTo(eTime)
                            .andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
                } else if (type.equals("date")) {
                    example.createCriteria().andAccountIdListLike("%" +id.toString() + "%")
                            .andOperTimeLessThanOrEqualTo(mTime)
                            .andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
                }
            } else {
                example.createCriteria().andAccountIdListLike("%" +id.toString() + "%")
                        .andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
            }
            List<DepotHead> dataList=null;
            try{
                dataList = depotHeadMapper.selectByExample(example);
            }catch(Exception e){
                GwException.readFail(logger, e);
            }
            if (dataList != null) {
                for (DepotHead depotHead : dataList) {
                    String accountIdList = depotHead.getAccountIdList();
                    String accountMoneyList = depotHead.getAccountMoneyList();
                    if(StringUtil.isNotEmpty(accountIdList) && StringUtil.isNotEmpty(accountMoneyList)) {
                        accountIdList = accountIdList.replace("[", "").replace("]", "").replace("\"", "");
                        accountMoneyList = accountMoneyList.replace("[", "").replace("]", "").replace("\"", "");
                        String[] aList = accountIdList.split(",");
                        String[] amList = accountMoneyList.split(",");
                        for (int i = 0; i < aList.length; i++) {
                            if (aList[i].toString().equals(id.toString())) {
                                if(amList!=null && amList.length>0) {
                                    accountSum = accountSum.add(new BigDecimal(amList[i]));
                                }
                            }
                        }
                    }
                }
            }
        } catch (DataAccessException e) {
            logger.error(">>>>>>>>>??????????????????", e);
        }
        return accountSum;
    }

    public List<AccountVo4InOutList> findAccountInOutList(Long accountId, Integer offset, Integer rows) throws Exception{
        List<AccountVo4InOutList> list=null;
        try{
            list = accountMapperEx.findAccountInOutList(accountId, offset, rows);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list;
    }

    public int findAccountInOutListCount(Long accountId) throws Exception{
        int result=0;
        try{
            result = accountMapperEx.findAccountInOutListCount(accountId);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return result;
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int updateAmountIsDefault(Boolean isDefault, Long accountId) throws Exception{
        logService.insertLog("??????",BusinessConstants.LOG_OPERATION_TYPE_EDIT+accountId,
                ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest());
        Account account = new Account();
        account.setIsDefault(isDefault);
        AccountExample example = new AccountExample();
        example.createCriteria().andIdEqualTo(accountId);
        int result=0;
        try{
            result = accountMapper.updateByExampleSelective(account, example);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }
    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int batchDeleteAccountByIds(String ids) throws Exception{
        StringBuffer sb = new StringBuffer();
        sb.append(BusinessConstants.LOG_OPERATION_TYPE_DELETE);
        List<Account> list = getAccountListByIds(ids);
        for(Account account: list){
            sb.append("[").append(account.getName()).append("]");
        }
        logService.insertLog("??????", sb.toString(),
                ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest());
        User userInfo=userService.getCurrentUser();
        String [] idArray=ids.split(",");
        int result=0;
        try{
            result = accountMapperEx.batchDeleteAccountByIds(new Date(),userInfo==null?null:userInfo.getId(),idArray);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }
    /**
     *  ???????????????????????????????????????????????????????????????
     * @Param: ids
     * @return int
     */
    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int batchDeleteAccountByIdsNormal(String ids) throws Exception{
        /**
         * ?????????
         * 1???????????????	gw_accounthead
         * 2???????????????	gw_accountitem
         * 3???????????????	gw_depot_head
         * ?????????????????????
         * */
        int deleteTotal=0;
        if(StringUtils.isEmpty(ids)){
            return deleteTotal;
        }
        String [] idArray=ids.split(",");
        /**
         * ??????????????????	gw_accounthead
         * */
        List<AccountHead> accountHeadList=null;
        try{
            accountHeadList = accountHeadMapperEx.getAccountHeadListByAccountIds(idArray);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        if(accountHeadList!=null&&accountHeadList.size()>0){
            logger.error("?????????[{}],????????????[{}],??????,AccountIds[{}]",
                    ExceptionConstants.DELETE_FORCE_CONFIRM_CODE,ExceptionConstants.DELETE_FORCE_CONFIRM_MSG,ids);
            throw new BusinessRunTimeException(ExceptionConstants.DELETE_FORCE_CONFIRM_CODE,
                    ExceptionConstants.DELETE_FORCE_CONFIRM_MSG);
        }
        /**
         * ??????????????????	gw_accountitem
         * */
        List<AccountItem> accountItemList=null;
        try{
            accountItemList = accountItemMapperEx.getAccountItemListByAccountIds(idArray);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        if(accountItemList!=null&&accountItemList.size()>0){
            logger.error("?????????[{}],????????????[{}],??????,AccountIds[{}]",
                    ExceptionConstants.DELETE_FORCE_CONFIRM_CODE,ExceptionConstants.DELETE_FORCE_CONFIRM_MSG,ids);
            throw new BusinessRunTimeException(ExceptionConstants.DELETE_FORCE_CONFIRM_CODE,
                    ExceptionConstants.DELETE_FORCE_CONFIRM_MSG);
        }
        /**
         * ??????????????????	gw_depot_head
         * */
        List<DepotHead> depotHeadList =null;
        try{
            depotHeadList = depotHeadMapperEx.getDepotHeadListByAccountIds(idArray);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        if(depotHeadList!=null&&depotHeadList.size()>0){
            logger.error("?????????[{}],????????????[{}],??????,AccountIds[{}]",
                    ExceptionConstants.DELETE_FORCE_CONFIRM_CODE,ExceptionConstants.DELETE_FORCE_CONFIRM_MSG,ids);
            throw new BusinessRunTimeException(ExceptionConstants.DELETE_FORCE_CONFIRM_CODE,
                    ExceptionConstants.DELETE_FORCE_CONFIRM_MSG);
        }
        /**
         * ??????????????????????????????
         * */
        deleteTotal= batchDeleteAccountByIds(ids);
        return deleteTotal;

    }

    public Map<String, Object> getStatistics() {
        Map<String, Object> map = new HashMap<>();
        try {
            List<Account> list = getAccount();
            String timeStr = Tools.getCurrentMonth();
            BigDecimal allMonthAmount = BigDecimal.ZERO;
            BigDecimal allCurrentAmount = BigDecimal.ZERO;
            if (null != list && null !=timeStr) {
                for (Account a : list) {
                    BigDecimal monthAmount = getAccountSum(a.getId(), timeStr, "month").add(getAccountSumByHead(a.getId(), timeStr, "month"))
                            .add(getAccountSumByDetail(a.getId(), timeStr, "month")).add(getManyAccountSum(a.getId(), timeStr, "month"));
                    BigDecimal currentAmount = getAccountSum(a.getId(), "", "month").add(getAccountSumByHead(a.getId(), "", "month"))
                            .add(getAccountSumByDetail(a.getId(), "", "month")).add(getManyAccountSum(a.getId(), "", "month")).add(a.getInitialAmount());
                    allMonthAmount = allMonthAmount.add(monthAmount);
                    allCurrentAmount = allCurrentAmount.add(currentAmount);
                }
            }
            map.put("allCurrentAmount", priceFormat(allCurrentAmount));  //???????????????
            map.put("allMonthAmount", priceFormat(allMonthAmount));  //???????????????
        } catch (Exception e) {
            GwException.readFail(logger, e);
        }
        return map;
    }

    /**
     * ???????????????
     * @param price
     * @return
     */
    private String priceFormat(BigDecimal price) {
        String priceFmt = "0";
        DecimalFormat df = new DecimalFormat(".##");
        if ((price.compareTo(BigDecimal.ZERO))!=0) {
            priceFmt = df.format(price);
        }
        return priceFmt;
    }
}
