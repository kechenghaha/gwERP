package com.gw.erp.service.person;

import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.gw.erp.constants.BusinessConstants;
import com.gw.erp.constants.ExceptionConstants;
import com.gw.erp.datasource.entities.*;
import com.gw.erp.datasource.mappers.AccountHeadMapperEx;
import com.gw.erp.datasource.mappers.DepotHeadMapperEx;
import com.gw.erp.datasource.mappers.PersonMapper;
import com.gw.erp.datasource.mappers.PersonMapperEx;
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
public class PersonService {
    private Logger logger = LoggerFactory.getLogger(PersonService.class);

    @Resource
    private PersonMapper personMapper;

    @Resource
    private PersonMapperEx personMapperEx;
    @Resource
    private UserService userService;
    @Resource
    private LogService logService;
    @Resource
    private AccountHeadMapperEx accountHeadMapperEx;
    @Resource
    private DepotHeadMapperEx depotHeadMapperEx;

    public Person getPerson(long id)throws Exception {
        Person result=null;
        try{
            result=personMapper.selectByPrimaryKey(id);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return result;
    }

    public List<Person> getPersonListByIds(String ids)throws Exception {
        List<Long> idList = StringUtil.strToLongList(ids);
        List<Person> list = new ArrayList<>();
        try{
            PersonExample example = new PersonExample();
            example.createCriteria().andIdIn(idList);
            list = personMapper.selectByExample(example);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list;
    }

    public List<Person> getPerson()throws Exception {
        PersonExample example = new PersonExample();
        example.createCriteria().andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
        List<Person> list=null;
        try{
            list=personMapper.selectByExample(example);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list;
    }

    public List<Person> select(String name, String type, int offset, int rows)throws Exception {
        List<Person> list=null;
        try{
            list=personMapperEx.selectByConditionPerson(name, type, offset, rows);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list;
    }

    public Long countPerson(String name, String type)throws Exception {
        Long result=null;
        try{
            result=personMapperEx.countsByPerson(name, type);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return result;
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int insertPerson(String beanJson, HttpServletRequest request)throws Exception {
        Person person = JSONObject.parseObject(beanJson, Person.class);
        int result=0;
        try{
            result=personMapper.insertSelective(person);
            logService.insertLog("?????????",
                    new StringBuffer(BusinessConstants.LOG_OPERATION_TYPE_ADD).append(person.getName()).toString(), request);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int updatePerson(String beanJson, Long id, HttpServletRequest request)throws Exception {
        Person person = JSONObject.parseObject(beanJson, Person.class);
        person.setId(id);
        int result=0;
        try{
            result=personMapper.updateByPrimaryKeySelective(person);
            logService.insertLog("?????????",
                    new StringBuffer(BusinessConstants.LOG_OPERATION_TYPE_EDIT).append(person.getName()).toString(), request);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int deletePerson(Long id, HttpServletRequest request)throws Exception {
        int result=0;
        try{
            result=personMapper.deleteByPrimaryKey(id);
            logService.insertLog("?????????",
                    new StringBuffer(BusinessConstants.LOG_OPERATION_TYPE_DELETE).append(id).toString(), request);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int batchDeletePerson(String ids, HttpServletRequest request) throws Exception{
        List<Long> idList = StringUtil.strToLongList(ids);
        PersonExample example = new PersonExample();
        example.createCriteria().andIdIn(idList);
        int result=0;
        try{
            result=personMapper.deleteByExample(example);
            logService.insertLog("?????????", "????????????,id???:" + ids, request);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }

    public int checkIsNameExist(Long id, String name) throws Exception{
        PersonExample example = new PersonExample();
        example.createCriteria().andIdNotEqualTo(id).andNameEqualTo(name).andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
        List<Person> list =null;
        try{
            list=personMapper.selectByExample(example);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list==null?0:list.size();
    }

    public String getPersonByIds(String personIDs)throws Exception {
        List<Long> ids = StringUtil.strToLongList(personIDs);
        PersonExample example = new PersonExample();
        example.createCriteria().andIdIn(ids).andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
        example.setOrderByClause("id asc");
        List<Person> list =null;
        try{
            list=personMapper.selectByExample(example);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        StringBuffer sb = new StringBuffer();
        if (null != list) {
            for (Person person : list) {
                sb.append(person.getName() + " ");
            }
        }
        return  sb.toString();
    }

    public List<Person> getPersonByType(String type)throws Exception {
        PersonExample example = new PersonExample();
        example.createCriteria().andTypeEqualTo(type).andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
        example.setOrderByClause("id asc");
        List<Person> list =null;
        try{
            list=personMapper.selectByExample(example);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list;
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int batchDeletePersonByIds(String ids)throws Exception {
        StringBuffer sb = new StringBuffer();
        sb.append(BusinessConstants.LOG_OPERATION_TYPE_DELETE);
        List<Person> list = getPersonListByIds(ids);
        for(Person person: list){
            sb.append("[").append(person.getName()).append("]");
        }
        logService.insertLog("?????????", sb.toString(),
                ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest());
        User userInfo=userService.getCurrentUser();
        String [] idArray=ids.split(",");
        int result =0;
        try{
            result=personMapperEx.batchDeletePersonByIds(new Date(),userInfo==null?null:userInfo.getId(),idArray);
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
    public int batchDeletePersonByIdsNormal(String ids) throws Exception {
        /**
         * ??????
         * 1???????????????	gwaccounthead
         * 2???????????????	gw_depot_head
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
        List<AccountHead> accountHeadList =null;
        try{
            accountHeadList=accountHeadMapperEx.getAccountHeadListByHandsPersonIds(idArray);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        if(accountHeadList!=null&&accountHeadList.size()>0){
            logger.error("?????????[{}],????????????[{}],??????,HandsPersonIds[{}]",
                    ExceptionConstants.DELETE_FORCE_CONFIRM_CODE,ExceptionConstants.DELETE_FORCE_CONFIRM_MSG,ids);
            throw new BusinessRunTimeException(ExceptionConstants.DELETE_FORCE_CONFIRM_CODE,
                    ExceptionConstants.DELETE_FORCE_CONFIRM_MSG);
        }
        /**
         * ??????????????????	gw_depot_head
         * */
        List<DepotHead> depotHeadList =null;
        try{
            depotHeadList=depotHeadMapperEx.getDepotHeadListByCreator(idArray);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        if(depotHeadList!=null&&depotHeadList.size()>0){
            logger.error("?????????[{}],????????????[{}],??????,HandsPersonIds[{}]",
                    ExceptionConstants.DELETE_FORCE_CONFIRM_CODE,ExceptionConstants.DELETE_FORCE_CONFIRM_MSG,ids);
            throw new BusinessRunTimeException(ExceptionConstants.DELETE_FORCE_CONFIRM_CODE,
                    ExceptionConstants.DELETE_FORCE_CONFIRM_MSG);
        }
        /**
         * ??????????????????????????????
         * */
        deleteTotal= batchDeletePersonByIds(ids);
        return deleteTotal;
    }
}
