package com.gw.erp.service.inOutItem;

import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.gw.erp.constants.BusinessConstants;
import com.gw.erp.constants.ExceptionConstants;
import com.gw.erp.datasource.entities.*;
import com.gw.erp.datasource.mappers.AccountItemMapperEx;
import com.gw.erp.datasource.mappers.InOutItemMapper;
import com.gw.erp.datasource.mappers.InOutItemMapperEx;
import com.gw.erp.exception.BusinessRunTimeException;
import com.gw.erp.exception.GwException;
import com.gw.erp.service.log.LogService;
import com.gw.erp.service.user.UserService;
import com.gw.erp.utils.StringUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
public class InOutItemService {
    private Logger logger = LoggerFactory.getLogger(InOutItemService.class);

    @Resource
    private InOutItemMapper inOutItemMapper;

    @Resource
    private InOutItemMapperEx inOutItemMapperEx;
    @Resource
    private UserService userService;
    @Resource
    private LogService logService;
    @Resource
    private AccountItemMapperEx accountItemMapperEx;

    public InOutItem getInOutItem(long id)throws Exception {
        InOutItem result=null;
        try{
            result=inOutItemMapper.selectByPrimaryKey(id);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return result;
    }

    public List<InOutItem> getInOutItemListByIds(String ids)throws Exception {
        List<Long> idList = StringUtil.strToLongList(ids);
        List<InOutItem> list = new ArrayList<>();
        try{
            InOutItemExample example = new InOutItemExample();
            example.createCriteria().andIdIn(idList);
            list = inOutItemMapper.selectByExample(example);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list;
    }

    public List<InOutItem> getInOutItem()throws Exception {
        InOutItemExample example = new InOutItemExample();
        example.createCriteria().andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
        List<InOutItem> list=null;
        try{
            list=inOutItemMapper.selectByExample(example);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list;
    }

    public List<InOutItem> select(String name, String type, String remark, int offset, int rows)throws Exception {
        List<InOutItem> list=null;
        try{
            list=inOutItemMapperEx.selectByConditionInOutItem(name, type, remark, offset, rows);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list;
    }

    public Long countInOutItem(String name, String type, String remark)throws Exception {
        Long result=null;
        try{
            result=inOutItemMapperEx.countsByInOutItem(name, type, remark);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return result;
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int insertInOutItem(String beanJson, HttpServletRequest request)throws Exception {
        InOutItem inOutItem = JSONObject.parseObject(beanJson, InOutItem.class);
        int result=0;
        try{
            result=inOutItemMapper.insertSelective(inOutItem);
            logService.insertLog("????????????",
                    new StringBuffer(BusinessConstants.LOG_OPERATION_TYPE_ADD).append(inOutItem.getName()).toString(), request);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int updateInOutItem(String beanJson, Long id, HttpServletRequest request)throws Exception {
        InOutItem inOutItem = JSONObject.parseObject(beanJson, InOutItem.class);
        inOutItem.setId(id);
        int result=0;
        try{
            result=inOutItemMapper.updateByPrimaryKeySelective(inOutItem);
            logService.insertLog("????????????",
                    new StringBuffer(BusinessConstants.LOG_OPERATION_TYPE_EDIT).append(inOutItem.getName()).toString(), request);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int deleteInOutItem(Long id, HttpServletRequest request)throws Exception {
        int result=0;
        try{
            result=inOutItemMapper.deleteByPrimaryKey(id);
            logService.insertLog("????????????",
                    new StringBuffer(BusinessConstants.LOG_OPERATION_TYPE_DELETE).append(id).toString(), request);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int batchDeleteInOutItem(String ids, HttpServletRequest request)throws Exception {
        List<Long> idList = StringUtil.strToLongList(ids);
        InOutItemExample example = new InOutItemExample();
        example.createCriteria().andIdIn(idList);
        int result=0;
        try{
            result=inOutItemMapper.deleteByExample(example);
            logService.insertLog("????????????", "????????????,id???:" + ids, request);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }

    public int checkIsNameExist(Long id, String name)throws Exception {
        InOutItemExample example = new InOutItemExample();
        example.createCriteria().andIdNotEqualTo(id).andNameEqualTo(name).andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
        List<InOutItem> list = null;
        try{
            list=inOutItemMapper.selectByExample(example);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }

        return list==null?0:list.size();
    }

    public List<InOutItem> findBySelect(String type)throws Exception {
        InOutItemExample example = new InOutItemExample();
        if (type.equals("in")) {
            example.createCriteria().andTypeEqualTo("??????").andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
        } else if (type.equals("out")) {
            example.createCriteria().andTypeEqualTo("??????").andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
        }
        example.setOrderByClause("id desc");
        List<InOutItem> list = null;
        try{
            list=inOutItemMapper.selectByExample(example);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list;
    }
    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int batchDeleteInOutItemByIds(String ids)throws Exception {
        StringBuffer sb = new StringBuffer();
        sb.append(BusinessConstants.LOG_OPERATION_TYPE_DELETE);
        List<InOutItem> list = getInOutItemListByIds(ids);
        for(InOutItem inOutItem: list){
            sb.append("[").append(inOutItem.getName()).append("]");
        }
        logService.insertLog("????????????", sb.toString(),
                ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest());
        User userInfo=userService.getCurrentUser();
        String [] idArray=ids.split(",");
        int result = 0;
        try{
            result=inOutItemMapperEx.batchDeleteInOutItemByIds(new Date(),userInfo==null?null:userInfo.getId(),idArray);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return result;
    }
    /**
     *  ???????????????????????????????????????????????????????????????
     * @Param: ids
     * @return int
     */
    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int batchDeleteInOutItemByIdsNormal(String ids) throws Exception {
        /**
         * ??????
         * 1???????????????	gw_accountitem
         * ?????????????????????
         * */
        int deleteTotal=0;
        if(StringUtils.isEmpty(ids)){
            return deleteTotal;
        }
        String [] idArray=ids.split(",");
        /**
         * ??????????????????	gw_accountitem
         * */
        List<AccountItem> accountItemList=null;
        try{
            accountItemList=accountItemMapperEx.getAccountItemListByInOutItemIds(idArray);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        if(accountItemList!=null&&accountItemList.size()>0){
            logger.error("?????????[{}],????????????[{}],??????,InOutItemIds[{}]",
                    ExceptionConstants.DELETE_FORCE_CONFIRM_CODE,ExceptionConstants.DELETE_FORCE_CONFIRM_MSG,ids);
            throw new BusinessRunTimeException(ExceptionConstants.DELETE_FORCE_CONFIRM_CODE,
                    ExceptionConstants.DELETE_FORCE_CONFIRM_MSG);
        }
        /**
         * ??????????????????????????????
         * */
        deleteTotal= batchDeleteInOutItemByIds(ids);
        return deleteTotal;

    }
}
