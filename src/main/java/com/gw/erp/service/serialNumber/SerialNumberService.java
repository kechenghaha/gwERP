package com.gw.erp.service.serialNumber;

import com.alibaba.fastjson.JSONObject;
import com.gw.erp.constants.BusinessConstants;
import com.gw.erp.constants.ExceptionConstants;
import com.gw.erp.datasource.entities.*;
import com.gw.erp.datasource.mappers.*;
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
public class SerialNumberService {
    private Logger logger = LoggerFactory.getLogger(SerialNumberService.class);

    @Resource
    private SerialNumberMapper serialNumberMapper;
    @Resource
    private SerialNumberMapperEx serialNumberMapperEx;
    @Resource
    private MaterialMapperEx materialMapperEx;
    @Resource
    private MaterialMapper materialMapper;
    @Resource
    private UserService userService;
    @Resource
    private LogService logService;


    public SerialNumber getSerialNumber(long id)throws Exception {
        SerialNumber result=null;
        try{
            result=serialNumberMapper.selectByPrimaryKey(id);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return result;
    }

    public List<SerialNumber> getSerialNumberListByIds(String ids)throws Exception {
        List<Long> idList = StringUtil.strToLongList(ids);
        List<SerialNumber> list = new ArrayList<>();
        try{
            SerialNumberExample example = new SerialNumberExample();
            example.createCriteria().andIdIn(idList);
            list = serialNumberMapper.selectByExample(example);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list;
    }

    public List<SerialNumber> getSerialNumber()throws Exception {
        SerialNumberExample example = new SerialNumberExample();
        List<SerialNumber> list=null;
        try{
            list=serialNumberMapper.selectByExample(example);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list;
    }

    public List<SerialNumberEx> select(String serialNumber, String materialName, Integer offset, Integer rows)throws Exception {
        List<SerialNumberEx> list=null;
        try{
            list=serialNumberMapperEx.selectByConditionSerialNumber(serialNumber, materialName,offset, rows);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list;

    }

    public Long countSerialNumber(String serialNumber,String materialName)throws Exception {
        Long result=null;
        try{
            result=serialNumberMapperEx.countSerialNumber(serialNumber, materialName);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return result;
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int insertSerialNumber(String beanJson, HttpServletRequest request)throws Exception {
        SerialNumber serialNumber = JSONObject.parseObject(beanJson, SerialNumber.class);
        int result=0;
        try{
            result=serialNumberMapper.insertSelective(serialNumber);
            logService.insertLog("?????????",
                    new StringBuffer(BusinessConstants.LOG_OPERATION_TYPE_ADD).append(serialNumber.getSerialNumber()).toString(), request);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int updateSerialNumber(String beanJson, Long id, HttpServletRequest request) throws Exception{
        SerialNumber serialNumber = JSONObject.parseObject(beanJson, SerialNumber.class);
        serialNumber.setId(id);
        int result=0;
        try{
            result=serialNumberMapper.updateByPrimaryKeySelective(serialNumber);
            logService.insertLog("?????????",
                    new StringBuffer(BusinessConstants.LOG_OPERATION_TYPE_EDIT).append(serialNumber.getSerialNumber()).toString(), request);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int deleteSerialNumber(Long id, HttpServletRequest request)throws Exception {
        int result=0;
        try{
            result=serialNumberMapper.deleteByPrimaryKey(id);
            logService.insertLog("?????????",
                    new StringBuffer(BusinessConstants.LOG_OPERATION_TYPE_DELETE).append(id).toString(), request);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int batchDeleteSerialNumber(String ids, HttpServletRequest request)throws Exception {
        List<Long> idList = StringUtil.strToLongList(ids);
        SerialNumberExample example = new SerialNumberExample();
        example.createCriteria().andIdIn(idList);
        int result=0;
        try{
            result=serialNumberMapper.deleteByExample(example);
            logService.insertLog("?????????", "????????????,id???:" + ids, request);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }

    public int checkIsNameExist(Long id, String serialNumber)throws Exception {
        SerialNumberExample example = new SerialNumberExample();
        example.createCriteria().andIdNotEqualTo(id).andSerialNumberEqualTo(serialNumber).andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
        List<SerialNumber> list=null;
        try{
            list=serialNumberMapper.selectByExample(example);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list==null?0:list.size();
    }



    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int batchSetEnable(Boolean enabled, String materialIDs)throws Exception{
        List<Long> ids = StringUtil.strToLongList(materialIDs);
        SerialNumber serialNumber = new SerialNumber();
        SerialNumberExample example = new SerialNumberExample();
        example.createCriteria().andIdIn(ids);
        int result=0;
        try{
            result=serialNumberMapper.updateByExampleSelective(serialNumber, example);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }


    public List<SerialNumberEx> findById(Long id)throws Exception{
        List<SerialNumberEx> list=null;
        try{
            list=serialNumberMapperEx.findById(id);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list;
    }




    public void checkIsExist(Long id, String materialName, String serialNumber) throws Exception{
        /**
         * ?????????????????????????????????????????????????????????
         * */
            if(StringUtil.isNotEmpty(materialName)){
                List<Material> mlist=null;
                try{
                     mlist = materialMapperEx.findByMaterialName(materialName);
                }catch(Exception e){
                    GwException.readFail(logger, e);
                }

               if(mlist==null||mlist.size()<1){
                   //?????????????????????
                   throw new BusinessRunTimeException(ExceptionConstants.MATERIAL_NOT_EXISTS_CODE,
                           ExceptionConstants.MATERIAL_NOT_EXISTS_MSG);
               }else if(mlist.size()>1){
                   //?????????????????????
                   throw new BusinessRunTimeException(ExceptionConstants.MATERIAL_NOT_ONLY_CODE,
                           ExceptionConstants.MATERIAL_NOT_ONLY_MSG);

               }
            }
            /***
             * ??????????????????????????????
             * */
            List <SerialNumberEx> list=null;
            try{
                 list = serialNumberMapperEx.findBySerialNumber(serialNumber);
            }catch(Exception e){
                GwException.readFail(logger, e);
            }
            if(list!=null&&list.size()>0){
                if(list.size()>1){
                    //???????????????????????????
                    throw new BusinessRunTimeException(ExceptionConstants.SERIAL_NUMBERE_ALREADY_EXISTS_CODE,
                            ExceptionConstants.SERIAL_NUMBERE_ALREADY_EXISTS_MSG);
                }else{
                    //?????????????????????
                    if(id==null){
                        //????????????????????????????????????
                        throw new BusinessRunTimeException(ExceptionConstants.SERIAL_NUMBERE_ALREADY_EXISTS_CODE,
                                ExceptionConstants.SERIAL_NUMBERE_ALREADY_EXISTS_MSG);
                    }
                        if(id.equals(list.get(0).getId())){
                            //???????????????????????????
                        }else{
                            //????????????????????????????????????
                            throw new BusinessRunTimeException(ExceptionConstants.SERIAL_NUMBERE_ALREADY_EXISTS_CODE,
                                    ExceptionConstants.SERIAL_NUMBERE_ALREADY_EXISTS_MSG);
                        }
                }

            }
    }

    /**
     * ?????????????????????
     * */
    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public SerialNumberEx addSerialNumber(SerialNumberEx serialNumberEx) throws Exception{
        logService.insertLog("?????????",BusinessConstants.LOG_OPERATION_TYPE_ADD,
                ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest());
        if(serialNumberEx==null){
            return null;
        }
        /**????????????id*/
        serialNumberEx.setMaterialId(getSerialNumberMaterialIdByMaterialName(serialNumberEx.getMaterialName()));
        //????????????,???????????????
        serialNumberEx.setDeleteFlag(BusinessConstants.DELETE_FLAG_EXISTS);
        //????????????????????????
        serialNumberEx.setIsSell(BusinessConstants.IS_SELL_HOLD);
        Date date=new Date();
        serialNumberEx.setCreateTime(date);
        serialNumberEx.setUpdateTime(date);
        User userInfo=userService.getCurrentUser();
        serialNumberEx.setCreator(userInfo==null?null:userInfo.getId());
        serialNumberEx.setUpdater(userInfo==null?null:userInfo.getId());
        int result=0;
        try{
            result = serialNumberMapperEx.addSerialNumber(serialNumberEx);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        if(result>0){
            return serialNumberEx;
        }
        return null;
    }
    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public SerialNumberEx updateSerialNumber(SerialNumberEx serialNumberEx)throws Exception {
        logService.insertLog("?????????",
                new StringBuffer(BusinessConstants.LOG_OPERATION_TYPE_EDIT).append(serialNumberEx.getId()).toString(),
                ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest());
        if(serialNumberEx==null){
            return null;
        }
        /**????????????id*/
        serialNumberEx.setMaterialId(getSerialNumberMaterialIdByMaterialName(serialNumberEx.getMaterialName()));
        Date date=new Date();
        serialNumberEx.setUpdateTime(date);
        User userInfo=userService.getCurrentUser();
        serialNumberEx.setUpdater(userInfo==null?null:userInfo.getId());
        int result=0;
        try{
            result = serialNumberMapperEx.updateSerialNumber(serialNumberEx);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        if(result>0){
            return serialNumberEx;
        }
        return null;
    }
    /**
     * description:
     *  ????????????????????????????????????????????????
     * @Param: materialName
     * @return Long ??????????????????????????????id
     */
    public Long checkMaterialName(String materialName)throws Exception{
        if(StringUtil.isNotEmpty(materialName)) {
            List<Material> mlist=null;
            try{
                mlist = materialMapperEx.findByMaterialName(materialName);
            }catch(Exception e){
                GwException.readFail(logger, e);
            }
            if (mlist == null || mlist.size() < 1) {
                //?????????????????????
                throw new BusinessRunTimeException(ExceptionConstants.MATERIAL_NOT_EXISTS_CODE,
                        ExceptionConstants.MATERIAL_NOT_EXISTS_MSG);
            }
            if (mlist.size() > 1) {
                //?????????????????????
                throw new BusinessRunTimeException(ExceptionConstants.MATERIAL_NOT_ONLY_CODE,
                        ExceptionConstants.MATERIAL_NOT_ONLY_MSG);

            }
            //??????????????????
            if (BusinessConstants.ENABLE_SERIAL_NUMBER_NOT_ENABLED.equals(mlist.get(0).getEnableSerialNumber())) {
                //????????????????????????
                throw new BusinessRunTimeException(ExceptionConstants.MATERIAL_NOT_ENABLE_SERIAL_NUMBER_CODE,
                        ExceptionConstants.MATERIAL_NOT_ENABLE_SERIAL_NUMBER_MSG);
            }
            return mlist.get(0).getId();
        }
        return null;
    }
    /**
     * description:
     *  ????????????????????????????????????????????????????????????
     *  1???????????????????????????????????????????????????
     *  2???????????????????????????????????????
     *  3????????????????????????????????????????????????????????????
     *  2019-02-01
     *  ????????????????????????????????????????????????????????????????????????????????????
     * @Param: materialName
     * @return Long ??????????????????????????????id
     */
    public Long getSerialNumberMaterialIdByMaterialName(String materialName)throws Exception{
            if(StringUtil.isNotEmpty(materialName)){
            //???????????????????????????????????????????????????????????????
            //??????=??????-??????
            //????????????
            Long materialId=checkMaterialName(materialName);
//            int inSum = depotItemService.findByTypeAndMaterialId(BusinessConstants.DEPOTHEAD_TYPE_STORAGE, materialId);
//            //????????????
//            int outSum = depotItemService.findByTypeAndMaterialId(BusinessConstants.DEPOTHEAD_TYPE_OUT, materialId);
//            //???????????????????????????????????????
//            int serialNumberSum = serialNumberMapperEx.findSerialNumberByMaterialId(materialId);
//            if((inSum-outSum)<=serialNumberSum){
//                throw new BusinessRunTimeException(ExceptionConstants.MATERIAL_SERIAL_NUMBERE_NOT_MORE_THAN_STORAGE_CODE,
//                        ExceptionConstants.MATERIAL_SERIAL_NUMBERE_NOT_MORE_THAN_STORAGE_MSG);
//            }
            return materialId;
        }
        return null;
    }

    /**
     * description:
     * ?????????????????????????????????????????????
     * ???????????????????????????????????????
     * @Param: List<DepotItem>
     * @return void
     */
    public void checkAndUpdateSerialNumber(DepotItem depotItem,User userInfo) throws Exception{
        if(depotItem!=null){
            //????????????????????????????????????????????????
            int SerialNumberSum= serialNumberMapperEx.countSerialNumberByMaterialIdAndDepotheadId(depotItem.getMaterialId(),null,BusinessConstants.IS_SELL_HOLD);
            //BasicNumber=OperNumber*ratio
            if((depotItem.getBasicNumber()==null?0:depotItem.getBasicNumber()).intValue()>SerialNumberSum){
                //??????????????????
                Material material= materialMapper.selectByPrimaryKey(depotItem.getMaterialId());
                throw new BusinessRunTimeException(ExceptionConstants.MATERIAL_SERIAL_NUMBERE_NOT_ENOUGH_CODE,
                        String.format(ExceptionConstants.MATERIAL_SERIAL_NUMBERE_NOT_ENOUGH_MSG,material==null?"":material.getName()));
            }
            //??????????????????????????????????????????
            sellSerialNumber(depotItem.getMaterialId(),depotItem.getHeaderId(),(depotItem.getBasicNumber()==null?0:depotItem.getBasicNumber()).intValue(),userInfo);
        }
    }

    /**
     * description:
     * ???????????????
     * @Param: materialId
     * @Param: depotheadId
     * @Param: isSell ??????'1'
     * @Param: Count ???????????????????????????
     * @return SerialNumberEx
     */
    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int sellSerialNumber(Long materialId, Long depotHeadId,int count,User user) throws Exception{
        int result=0;
        try{
            result = serialNumberMapperEx.sellSerialNumber(materialId,depotHeadId,count,new Date(),user==null?null:user.getId());
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }

    /**
     * description:
     * ???????????????
     * @Param: materialId
     * @Param: depotheadId
     * @Param: isSell ??????'0'
     * @Param: Count ???????????????????????????
     * @return SerialNumberEx
     */
    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int cancelSerialNumber(Long materialId, Long depotHeadId,int count,User user) throws Exception{
        int result=0;
        try{
            result = serialNumberMapperEx.cancelSerialNumber(materialId,depotHeadId,count,new Date(),user==null?null:user.getId());
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }

    /**
     * description:
     *??????????????????????????????500???
     * @Param: materialName
     * @Param: serialNumberPrefix
     * @Param: batAddTotal
     * @Param: remark
     * @return java.lang.Object
     */
    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public void batAddSerialNumber(String materialName, String serialNumberPrefix, Integer batAddTotal, String remark)throws Exception {
        logService.insertLog("?????????",
                new StringBuffer(BusinessConstants.LOG_OPERATION_TYPE_BATCH_ADD).append(batAddTotal).append(BusinessConstants.LOG_DATA_UNIT).toString(),
                ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest());
        if(StringUtil.isNotEmpty(materialName)){
            //????????????id
            Long materialId = checkMaterialName(materialName);
            List<SerialNumberEx> list=null;
            //????????????
            User userInfo=userService.getCurrentUser();
            Long userId=userInfo==null?null:userInfo.getId();
            Date date = null;
            Long million=null;
            synchronized(this){
                date = new Date();
                million=date.getTime();
            }

            int insertNum=0;
            StringBuffer prefixBuf=new StringBuffer(serialNumberPrefix).append(million);
            list=new ArrayList<SerialNumberEx>();
            int forNum = BusinessConstants.BATCH_INSERT_MAX_NUMBER>=batAddTotal?batAddTotal:BusinessConstants.BATCH_INSERT_MAX_NUMBER;
            for(int i=0;i<forNum;i++){
               insertNum++;
               SerialNumberEx each=new SerialNumberEx();
               each.setMaterialId(materialId);
               each.setCreator(userId);
               each.setCreateTime(date);
               each.setUpdater(userId);
               each.setUpdateTime(date);
               each.setRemark(remark);
               each.setSerialNumber(new StringBuffer(prefixBuf.toString()).append(insertNum).toString());
               list.add(each);
            }
            try{
                serialNumberMapperEx.batAddSerialNumber(list);
            }catch(Exception e){
                GwException.writeFail(logger, e);
            }
        }
    }
    /**
     * ???????????????????????????
     * @Param: ids
     * @return
     */
    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int batchDeleteSerialNumberByIds(String ids) throws Exception{
        StringBuffer sb = new StringBuffer();
        sb.append(BusinessConstants.LOG_OPERATION_TYPE_DELETE);
        List<SerialNumber> list = getSerialNumberListByIds(ids);
        for(SerialNumber serialNumber: list){
            sb.append("[").append(serialNumber.getSerialNumber()).append("]");
        }
        logService.insertLog("?????????", sb.toString(),
                ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest());
        User userInfo=userService.getCurrentUser();
        String [] idArray=ids.split(",");
        int result=0;
        try{
            result = serialNumberMapperEx.batchDeleteSerialNumberByIds(new Date(),userInfo==null?null:userInfo.getId(),idArray);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;

    }
}
