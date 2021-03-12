package com.gw.erp.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.gw.erp.constants.ExceptionConstants;
import com.gw.erp.datasource.entities.SerialNumberEx;
import com.gw.erp.exception.BusinessParamCheckingException;
import com.gw.erp.exception.BusinessRunTimeException;
import com.gw.erp.service.serialNumber.SerialNumberService;
import com.gw.erp.utils.StringUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

@RestController
public class SerialNumberController {
    private Logger logger = LoggerFactory.getLogger(SerialNumberController.class);

    @Resource
    private SerialNumberService serialNumberService;
    /**
     * description:
     *  检查序列号是否存在
     * @Param: id
     * @Param: materialName
     * @Param: serialNumber
     * @Param: request
     * @return java.lang.Object
     */
    @PostMapping("/serialNumber/checkIsExist")
    @ResponseBody
    public Object checkIsExist(@RequestParam("id") Long id, @RequestParam("materialName") String materialName,
                               @RequestParam("serialNumber") String serialNumber, HttpServletRequest request) throws Exception{
        JSONObject result = ExceptionConstants.standardSuccess();
        if(StringUtil.isEmpty(serialNumber)){
            throw new BusinessParamCheckingException(ExceptionConstants.SERIAL_NUMBERE_NOT_BE_EMPTY_CODE,
                    ExceptionConstants.SERIAL_NUMBERE_NOT_BE_EMPTY_MSG);
        }
        serialNumberService.checkIsExist(id, materialName, serialNumber);
        return result;
    }
    /**
     * description:
     *  新增序列号信息
     * @Param: beanJson
     * @Param: request
     * @return java.lang.Object
     */
    @PostMapping("/serialNumber/addSerialNumber")
    @ResponseBody
    public Object addSerialNumber(@RequestParam("info") String beanJson)throws Exception{
        JSONObject result = ExceptionConstants.standardSuccess();
        SerialNumberEx sne= JSON.parseObject(beanJson, SerialNumberEx.class);
        serialNumberService.addSerialNumber(sne);
        return result;

    }
    /**
     * description:
     *  修改序列号信息
     * @Param: beanJson
     * @return java.lang.Object
     */
    @PostMapping("/serialNumber/updateSerialNumber")
    @ResponseBody
    public Object updateSerialNumber(@RequestParam("info") String beanJson)throws Exception{

        JSONObject result = ExceptionConstants.standardSuccess();
        SerialNumberEx sne= JSON.parseObject(beanJson, SerialNumberEx.class);
        serialNumberService.updateSerialNumber(sne);
        return result;

    }
    /**
     * description:
     *批量添加序列号
     * @Param: materialName
     * @Param: serialNumberPrefix
     * @Param: batAddTotal
     * @Param: remark
     * @return java.lang.Object
     */
    @PostMapping("/serialNumber/batAddSerialNumber")
    @ResponseBody
    public Object batAddSerialNumber(@RequestParam("materialName") String materialName, @RequestParam("serialNumberPrefix") String serialNumberPrefix,
                                     @RequestParam("batAddTotal") Integer batAddTotal,@RequestParam("remark") String remark)throws Exception{

        JSONObject result = ExceptionConstants.standardSuccess();
        serialNumberService.batAddSerialNumber(materialName,serialNumberPrefix,batAddTotal,remark);
        return result;

    }
    /**
     * description:
     *  逻辑删除序列号信息
     * @Param: ids
     * @return java.lang.Object
     */
    @PostMapping(value = "/serialNumber/batchDeleteSerialNumberByIds")
    public Object batchDeleteSerialNumberByIds(@RequestParam("ids") String ids) throws Exception {
        JSONObject result = ExceptionConstants.standardSuccess();
        int i= serialNumberService.batchDeleteSerialNumberByIds(ids);
        if(i<1){
            logger.error("异常码[{}],异常提示[{}],参数,ids[{}]",
                    ExceptionConstants.SERIAL_NUMBERE_DELETE_FAILED_CODE,ExceptionConstants.SERIAL_NUMBERE_DELETE_FAILED_MSG,ids);
            throw new BusinessRunTimeException(ExceptionConstants.SERIAL_NUMBERE_DELETE_FAILED_CODE,
                    ExceptionConstants.SERIAL_NUMBERE_DELETE_FAILED_MSG);
        }
        return result;
    }

}
