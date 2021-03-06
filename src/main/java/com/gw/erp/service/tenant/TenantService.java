package com.gw.erp.service.tenant;

import com.alibaba.fastjson.JSONObject;
import com.gw.erp.datasource.entities.*;
import com.gw.erp.datasource.mappers.TenantMapper;
import com.gw.erp.datasource.mappers.TenantMapperEx;
import com.gw.erp.exception.GwException;
import com.gw.erp.utils.StringUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.*;

@Service
public class TenantService {
    private Logger logger = LoggerFactory.getLogger(TenantService.class);

    @Resource
    private TenantMapper tenantMapper;

    @Resource
    private TenantMapperEx tenantMapperEx;

    @Value("${tenant.userNumLimit}")
    private Integer userNumLimit;

    @Value("${tenant.billsNumLimit}")
    private Integer billsNumLimit;


    public Tenant getTenant(long id)throws Exception {
        Tenant result=null;
        try{
            result=tenantMapper.selectByPrimaryKey(id);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return result;
    }

    public List<Tenant> getTenant()throws Exception {
        TenantExample example = new TenantExample();
        List<Tenant> list=null;
        try{
            list=tenantMapper.selectByExample(example);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list;
    }

    public List<Tenant> select(String loginName, int offset, int rows)throws Exception {
        List<Tenant> list=null;
        try{
            list=tenantMapperEx.selectByConditionTenant(loginName, offset, rows);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list;
    }

    public Long countTenant(String loginName)throws Exception {
        Long result=null;
        try{
            result=tenantMapperEx.countsByTenant(loginName);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return result;
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int insertTenant(String beanJson, HttpServletRequest request)throws Exception {
        Tenant tenant = JSONObject.parseObject(beanJson, Tenant.class);
        int result=0;
        try{
            tenant.setUserNumLimit(userNumLimit); //????????????????????????
            tenant.setBillsNumLimit(billsNumLimit); //????????????????????????
            tenant.setCreateTime(new Date());
            result=tenantMapper.insertSelective(tenant);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int updateTenant(String beanJson, Long id, HttpServletRequest request)throws Exception {
        Tenant tenant = JSONObject.parseObject(beanJson, Tenant.class);
        int result=0;
        try{
            tenant.setId(id);
            result=tenantMapper.updateByPrimaryKeySelective(tenant);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int deleteTenant(Long id, HttpServletRequest request)throws Exception {
        int result=0;
        try{
            result= tenantMapper.deleteByPrimaryKey(id);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int batchDeleteTenant(String ids, HttpServletRequest request)throws Exception {
        List<Long> idList = StringUtil.strToLongList(ids);
        TenantExample example = new TenantExample();
        example.createCriteria().andIdIn(idList);
        int result=0;
        try{
            result= tenantMapper.deleteByExample(example);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }

    public int checkIsNameExist(Long id, String name)throws Exception {
        TenantExample example = new TenantExample();
        example.createCriteria().andIdEqualTo(id);
        List<Tenant> list=null;
        try{
            list= tenantMapper.selectByExample(example);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list==null?0:list.size();
    }

    public Tenant getTenantByTenantId(long tenantId) {
        Tenant tenant = new Tenant();
        TenantExample example = new TenantExample();
        example.createCriteria().andTenantIdEqualTo(tenantId);
        List<Tenant> list = tenantMapper.selectByExample(example);
        if(list.size()>0) {
            tenant = list.get(0);
        }
        return tenant;
    }
}
