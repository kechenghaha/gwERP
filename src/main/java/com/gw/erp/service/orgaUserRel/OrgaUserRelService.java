package com.gw.erp.service.orgaUserRel;

import com.alibaba.fastjson.JSONObject;
import com.gw.erp.constants.BusinessConstants;
import com.gw.erp.datasource.entities.OrgaUserRel;
import com.gw.erp.datasource.entities.OrgaUserRelExample;
import com.gw.erp.datasource.entities.User;
import com.gw.erp.datasource.mappers.OrgaUserRelMapper;
import com.gw.erp.datasource.mappers.OrgaUserRelMapperEx;
import com.gw.erp.exception.GwException;
import com.gw.erp.service.log.LogService;
import com.gw.erp.service.organization.OrganizationService;
import com.gw.erp.service.user.UserService;
import com.gw.erp.utils.StringUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


@Service
public class OrgaUserRelService {
    private Logger logger = LoggerFactory.getLogger(OrganizationService.class);

    @Resource
    private OrgaUserRelMapper orgaUserRelMapper;
    @Resource
    private OrgaUserRelMapperEx orgaUserRelMapperEx;
    @Resource
    private UserService userService;
    @Resource
    private OrganizationService organizationService;
    @Resource
    private LogService logService;

    public OrgaUserRel getOrgaUserRel(long id) throws Exception{
        return orgaUserRelMapper.selectByPrimaryKey(id);
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int insertOrgaUserRel(String beanJson, HttpServletRequest request) throws Exception{
        OrgaUserRel orgaUserRel = JSONObject.parseObject(beanJson, OrgaUserRel.class);
        int result=0;
        try{
            result=orgaUserRelMapper.insertSelective(orgaUserRel);
            logService.insertLog("用户与机构关系", BusinessConstants.LOG_OPERATION_TYPE_ADD, request);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }
    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int updateOrgaUserRel(String beanJson, Long id, HttpServletRequest request) throws Exception{
        OrgaUserRel orgaUserRel = JSONObject.parseObject(beanJson, OrgaUserRel.class);
        orgaUserRel.setId(id);
        int result=0;
        try{
            result=orgaUserRelMapper.updateByPrimaryKeySelective(orgaUserRel);
            logService.insertLog("用户与机构关系",
                    new StringBuffer(BusinessConstants.LOG_OPERATION_TYPE_EDIT).append(id).toString(), request);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }
    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int deleteOrgaUserRel(Long id, HttpServletRequest request)throws Exception {
        int result=0;
        try{
            result=orgaUserRelMapper.deleteByPrimaryKey(id);
            logService.insertLog("用户与机构关系",
                    new StringBuffer(BusinessConstants.LOG_OPERATION_TYPE_DELETE).append(id).toString(), request);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }
    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int batchDeleteOrgaUserRel(String ids, HttpServletRequest request)throws Exception {
        List<Long> idList = StringUtil.strToLongList(ids);
        OrgaUserRelExample example = new OrgaUserRelExample();
        example.createCriteria().andIdIn(idList);
        int result=0;
        try{
            result=orgaUserRelMapper.deleteByExample(example);
            logService.insertLog("用户与机构关系", "批量删除,id集:" + ids, request);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }
    /**
     * description:
     *  新增机构用户关联关系,反显id
     * @Param: orgaUserRel
     * @return void
     */
    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public OrgaUserRel addOrgaUserRel(OrgaUserRel orgaUserRel) throws Exception{
        Date date = new Date();
        User userInfo=userService.getCurrentUser();
        //创建时间
        if(orgaUserRel.getCreateTime()==null){
            orgaUserRel.setCreateTime(date);
        }
        //创建人
        if(orgaUserRel.getCreator()==null){
            orgaUserRel.setCreator(userInfo==null?null:userInfo.getId());
        }
        //更新时间
        if(orgaUserRel.getUpdateTime()==null){
            orgaUserRel.setUpdateTime(date);
        }
        //更新人
        if(orgaUserRel.getUpdater()==null){
            orgaUserRel.setUpdater(userInfo==null?null:userInfo.getId());
        }
        orgaUserRel.setDeleteFlag(BusinessConstants.DELETE_FLAG_EXISTS);
        int result=0;
        try{
            result=orgaUserRelMapperEx.addOrgaUserRel(orgaUserRel);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        if(result>0){
            return orgaUserRel;
        }
        return null;
    }
    /**
     * description:
     *  更新机构用户关联关系
     * @Param: orgaUserRel
     * @return void
     */
    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public OrgaUserRel updateOrgaUserRel(OrgaUserRel orgaUserRel) throws Exception{
        User userInfo=userService.getCurrentUser();
        //更新时间
        if(orgaUserRel.getUpdateTime()==null){
            orgaUserRel.setUpdateTime(new Date());
        }
        //更新人
        if(orgaUserRel.getUpdater()==null){
            orgaUserRel.setUpdater(userInfo==null?null:userInfo.getId());
        }
        int result=0;
        try{
            result=orgaUserRelMapperEx.updateOrgaUserRel(orgaUserRel);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        if(result>0){
            return orgaUserRel;
        }
        return null;
    }

    /**
     * 根据用户id获取用户id列表
     * @param userId
     * @return
     * @throws Exception
     */
    public String getUserIdListByUserId(Long userId) throws Exception{
        OrgaUserRel our = new OrgaUserRel();
        OrgaUserRelExample example = new OrgaUserRelExample();
        example.createCriteria().andUserIdEqualTo(userId);
        List<OrgaUserRel> list = orgaUserRelMapper.selectByExample(example);
        if(list!=null && list.size()>0) {
            our = list.get(0);
        }
        List<Long> userIdList = getUserIdListByOrgId(our.getOrgaId());
        String users = "";
        for(Long u: userIdList){
            users = users + u + ",";
        }
        if(users.length()>0){
            users = users.substring(0,users.length()-1);
        }
        return users;
    }

    /**
     * 根据组织id获取所属的用户id列表（包含组织的递归）
     * @param orgId
     * @return
     */
    public List<Long> getUserIdListByOrgId(Long orgId) {
        List<Long> orgIdList = organizationService.getOrgIdByParentId(orgId);
        List<Long> userIdList = new ArrayList<Long>();
        OrgaUserRelExample example = new OrgaUserRelExample();
        if(orgIdList!=null && orgIdList.size()>0) {
            example.createCriteria().andOrgaIdIn(orgIdList).andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
        } else {
            example.createCriteria().andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
        }
        List<OrgaUserRel> list = orgaUserRelMapper.selectByExample(example);
        if(list!=null && list.size()>0) {
            for(OrgaUserRel our: list) {
                userIdList.add(our.getUserId());
            }
        }
        return  userIdList;
    }
}
