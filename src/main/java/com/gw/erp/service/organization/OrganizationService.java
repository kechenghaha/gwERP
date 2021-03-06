package com.gw.erp.service.organization;

import com.alibaba.fastjson.JSONObject;
import com.gw.erp.constants.BusinessConstants;
import com.gw.erp.constants.ExceptionConstants;
import com.gw.erp.datasource.entities.Organization;
import com.gw.erp.datasource.entities.OrganizationExample;
import com.gw.erp.datasource.entities.User;
import com.gw.erp.datasource.mappers.OrganizationMapper;
import com.gw.erp.datasource.mappers.OrganizationMapperEx;
import com.gw.erp.datasource.vo.TreeNode;
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
public class OrganizationService {
    private Logger logger = LoggerFactory.getLogger(OrganizationService.class);

    @Resource
    private OrganizationMapper organizationMapper;
    @Resource
    private OrganizationMapperEx organizationMapperEx;
    @Resource
    private UserService userService;
    @Resource
    private LogService logService;

    public Organization getOrganization(long id) throws Exception {
        return organizationMapper.selectByPrimaryKey(id);
    }

    public List<Organization> getOrganizationListByIds(String ids)throws Exception {
        List<Long> idList = StringUtil.strToLongList(ids);
        List<Organization> list = new ArrayList<>();
        try{
            OrganizationExample example = new OrganizationExample();
            example.createCriteria().andIdIn(idList);
            list = organizationMapper.selectByExample(example);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list;
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int insertOrganization(String beanJson, HttpServletRequest request)throws Exception {
        Organization organization = JSONObject.parseObject(beanJson, Organization.class);
        int result=0;
        try{
            result=organizationMapper.insertSelective(organization);
            logService.insertLog("??????",
                    new StringBuffer(BusinessConstants.LOG_OPERATION_TYPE_ADD).append(organization.getOrgFullName()).toString(),request);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }
    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int updateOrganization(String beanJson, Long id, HttpServletRequest request)throws Exception {
        Organization organization = JSONObject.parseObject(beanJson, Organization.class);
        organization.setId(id);
        int result=0;
        try{
            result=organizationMapper.updateByPrimaryKeySelective(organization);
            logService.insertLog("??????",
                    new StringBuffer(BusinessConstants.LOG_OPERATION_TYPE_EDIT).append(organization.getOrgFullName()).toString(), request);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }
    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int deleteOrganization(Long id, HttpServletRequest request)throws Exception {
        int result=0;
        try{
            result=organizationMapper.deleteByPrimaryKey(id);
            logService.insertLog("??????",
                    new StringBuffer(BusinessConstants.LOG_OPERATION_TYPE_DELETE).append(id).toString(), request);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }
    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int batchDeleteOrganization(String ids, HttpServletRequest request)throws Exception {
        List<Long> idList = StringUtil.strToLongList(ids);
        OrganizationExample example = new OrganizationExample();
        example.createCriteria().andIdIn(idList);
        int result=0;
        try{
            result=organizationMapper.deleteByExample(example);
            logService.insertLog("??????", "????????????,id???:" + ids, request);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }
    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int addOrganization(Organization org) throws Exception{
        logService.insertLog("??????",
                new StringBuffer(BusinessConstants.LOG_OPERATION_TYPE_ADD).append(org.getOrgFullName()).toString(),
                ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest());
        //????????????
        Date date=new Date();
        User userInfo=userService.getCurrentUser();
        org.setCreateTime(date);
        //?????????
        org.setCreator(userInfo==null?null:userInfo.getId());
        //????????????
        org.setUpdateTime(date);
        //?????????
        org.setUpdater(userInfo==null?null:userInfo.getId());
        /**
         *????????????????????????????????????????????????
         * */
        if(StringUtil.isNotEmpty(org.getOrgNo())){
            checkOrgNoIsExists(org.getOrgNo(),null);
        }
        /**
         * ????????????????????????????????????????????????
         * */
        if(StringUtil.isEmpty(org.getOrgParentNo())){
            org.setOrgParentNo(BusinessConstants.ORGANIZATION_ROOT_PARENT_NO);
        }
        int result=0;
        try{
            result=organizationMapperEx.addOrganization(org);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }
    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int editOrganization(Organization org)throws Exception {
        logService.insertLog("??????",
               new StringBuffer(BusinessConstants.LOG_OPERATION_TYPE_EDIT).append(org.getOrgFullName()).toString(),
                ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest());
        //????????????
        org.setUpdateTime(new Date());
        User userInfo=userService.getCurrentUser();
        //?????????
        org.setUpdater(userInfo==null?null:userInfo.getId());
        /**
         * ????????????????????????????????????????????????
         * */
        if(StringUtil.isNotEmpty(org.getOrgNo())){
            checkOrgNoIsExists(org.getOrgNo(),org.getId());
        }
        /**
         * ????????????????????????????????????????????????
         * */
        if(StringUtil.isEmpty(org.getOrgParentNo())){
            org.setOrgParentNo(BusinessConstants.ORGANIZATION_ROOT_PARENT_NO);
        }
        int result=0;
        try{
            result=organizationMapperEx.editOrganization(org);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }

    public List<TreeNode> getOrganizationTree(Long id)throws Exception {
        List<TreeNode> list=null;
        try{
            list=organizationMapperEx.getNodeTree(id);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list;
    }

    public List<Organization> findById(Long id) throws Exception{
        OrganizationExample example = new OrganizationExample();
        example.createCriteria().andIdEqualTo(id);
        List<Organization> list=null;
        try{
            list=organizationMapper.selectByExample(example);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list;
    }

    public List<Organization> findByOrgNo(String orgNo)throws Exception {
        OrganizationExample example = new OrganizationExample();
        example.createCriteria().andOrgNoEqualTo(orgNo).andOrgStcdNotEqualTo(BusinessConstants.ORGANIZATION_STCD_REMOVED);
        List<Organization> list=null;
        try{
            list=organizationMapper.selectByExample(example);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list;
    }
    /**
     * description:
     *  ????????????????????????????????????
     * @Param: orgNo
     * @return void
     */
    public void checkOrgNoIsExists(String orgNo,Long id)throws Exception {
        List<Organization> orgList=findByOrgNo(orgNo);
        if(orgList!=null&&orgList.size()>0){
            if(orgList.size()>1){
                logger.error("?????????[{}],????????????[{}],??????,orgNo[{}]",
                        ExceptionConstants.ORGANIZATION_NO_ALREADY_EXISTS_CODE,ExceptionConstants.ORGANIZATION_NO_ALREADY_EXISTS_MSG,orgNo);
                //???????????????????????????1????????????????????????
                throw new BusinessRunTimeException(ExceptionConstants.ORGANIZATION_NO_ALREADY_EXISTS_CODE,
                        ExceptionConstants.ORGANIZATION_NO_ALREADY_EXISTS_MSG);
            }
            if(id!=null){
                if(!orgList.get(0).getId().equals(id)){
                    //??????????????????1??????????????????????????????id?????????
                    logger.error("?????????[{}],????????????[{}],??????,orgNo[{}],id[{}]",
                            ExceptionConstants.ORGANIZATION_NO_ALREADY_EXISTS_CODE,ExceptionConstants.ORGANIZATION_NO_ALREADY_EXISTS_MSG,orgNo,id);
                    throw new BusinessRunTimeException(ExceptionConstants.ORGANIZATION_NO_ALREADY_EXISTS_CODE,
                            ExceptionConstants.ORGANIZATION_NO_ALREADY_EXISTS_MSG);
                }
            }else{
                logger.error("?????????[{}],????????????[{}],??????,orgNo[{}]",
                        ExceptionConstants.ORGANIZATION_NO_ALREADY_EXISTS_CODE,ExceptionConstants.ORGANIZATION_NO_ALREADY_EXISTS_MSG,orgNo);
                //??????????????????1?????????????????????
                throw new BusinessRunTimeException(ExceptionConstants.ORGANIZATION_NO_ALREADY_EXISTS_CODE,
                        ExceptionConstants.ORGANIZATION_NO_ALREADY_EXISTS_MSG);
            }
        }

    }
    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int batchDeleteOrganizationByIds(String ids) throws Exception{
        StringBuffer sb = new StringBuffer();
        sb.append(BusinessConstants.LOG_OPERATION_TYPE_DELETE);
        List<Organization> list = getOrganizationListByIds(ids);
        for(Organization organization: list){
            sb.append("[").append(organization.getOrgFullName()).append("]");
        }
        logService.insertLog("??????", sb.toString(),
                ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest());
        User userInfo=userService.getCurrentUser();
        String [] idArray=ids.split(",");
        int result=0;
        try{
            result=organizationMapperEx.batchDeleteOrganizationByIds(
                    new Date(),userInfo==null?null:userInfo.getId(),idArray);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }

    /**
     * ????????????id????????????????????????id
     * @return
     */
    public List<Long> getOrgIdByParentId(Long orgId) {
        List<Long> idList = new ArrayList<Long>();
        OrganizationExample example = new OrganizationExample();
        example.createCriteria().andIdEqualTo(orgId).andOrgStcdNotEqualTo(BusinessConstants.ORGANIZATION_STCD_REMOVED);
        List<Organization> orgList = organizationMapper.selectByExample(example);
        if(orgList!=null && orgList.size()>0) {
            idList.add(orgId);
            getOrgIdByParentNo(idList, orgList.get(0).getOrgNo());
        }
        return idList;
    }

    /**
     * ??????????????????????????????????????????
     * @param orgNo
     * @return
     */
    public void getOrgIdByParentNo(List<Long> idList,String orgNo) {
        List<Long> list = new ArrayList<Long>();
        OrganizationExample example = new OrganizationExample();
        example.createCriteria().andOrgParentNoEqualTo(orgNo).andOrgStcdNotEqualTo(BusinessConstants.ORGANIZATION_STCD_REMOVED);
        List<Organization> orgList = organizationMapper.selectByExample(example);
        if(orgList!=null && orgList.size()>0) {
            for(Organization o: orgList) {
                idList.add(o.getId());
                getOrgIdByParentNo(idList, o.getOrgNo());
            }
        }
    }
}
