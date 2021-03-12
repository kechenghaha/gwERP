package com.gw.erp.controller;

import com.alibaba.fastjson.JSONObject;
import com.gw.erp.constants.ExceptionConstants;
import com.gw.erp.exception.BusinessRunTimeException;
import com.gw.erp.service.systemConfig.SystemConfigService;
import com.gw.erp.service.user.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

@RestController
@RequestMapping(value = "/systemConfig")
public class SystemConfigController {
    private Logger logger = LoggerFactory.getLogger(SystemConfigController.class);

    @Resource
    private SystemConfigService systemConfigService;

    @Resource
    private UserService userService;
    /**
     *  批量删除系统配置信息
     */
    @PostMapping(value = "/batchDeleteSystemConfigByIds")
    public Object batchDeleteSystemConfigByIds(@RequestParam("ids") String ids) throws Exception {
        JSONObject result = ExceptionConstants.standardSuccess();
        int i= 0;
        if(userService.checkIsTestUser()) {
            throw new BusinessRunTimeException(ExceptionConstants.SYSTEM_CONFIG_TEST_USER_CODE,
                    ExceptionConstants.SYSTEM_CONFIG_TEST_USER_MSG);
        } else {
            i = systemConfigService.batchDeleteSystemConfigByIds(ids);
            if(i<1){
                logger.error("异常码[{}],异常提示[{}],参数,ids[{}]",
                        ExceptionConstants.SYSTEM_CONFIG_DELETE_FAILED_CODE,ExceptionConstants.SYSTEM_CONFIG_DELETE_FAILED_MSG,ids);
                throw new BusinessRunTimeException(ExceptionConstants.SYSTEM_CONFIG_DELETE_FAILED_CODE,
                        ExceptionConstants.SYSTEM_CONFIG_DELETE_FAILED_MSG);
            }
        }
        return result;
    }

}
