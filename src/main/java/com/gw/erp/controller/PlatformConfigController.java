package com.gw.erp.controller;

import com.gw.erp.datasource.entities.PlatformConfig;
import com.gw.erp.service.platformConfig.PlatformConfigService;
import com.gw.erp.utils.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

import static com.gw.erp.utils.ResponseJsonUtil.returnJson;

@RestController
@RequestMapping(value = "/platformConfig")
public class PlatformConfigController {
    private Logger logger = LoggerFactory.getLogger(PlatformConfigController.class);

    @Resource
    private PlatformConfigService platformConfigService;

    /**
     * 根据platformKey更新platformValue
     * @param platformKey
     * @param platformValue
     * @param request
     * @return
     */
    @PostMapping(value = "/updatePlatformConfigByKey")
    public String updatePlatformConfigByKey(@RequestParam("platformKey") String platformKey,
                                            @RequestParam("platformValue") String platformValue,
                                            HttpServletRequest request)throws Exception {
        Map<String, Object> objectMap = new HashMap<String, Object>();
        int res = platformConfigService.updatePlatformConfigByKey(platformKey, platformValue);
        if(res > 0) {
            return returnJson(objectMap, ErpInfo.OK.name, ErpInfo.OK.code);
        } else {
            return returnJson(objectMap, ErpInfo.ERROR.name, ErpInfo.ERROR.code);
        }
    }

    /**
     * 根据platformKey查询信息
     * @param platformKey
     * @param request
     * @return
     */
    @GetMapping(value = "/getPlatformConfigByKey")
    public BaseResponseInfo getPlatformConfigByKey(@RequestParam("platformKey") String platformKey,
                                            HttpServletRequest request)throws Exception {
        BaseResponseInfo res = new BaseResponseInfo();
        try {
            PlatformConfig platformConfig = platformConfigService.getPlatformConfigByKey(platformKey);
            res.code = 200;
            res.data = platformConfig;
        } catch(Exception e){
            e.printStackTrace();
            res.code = 500;
            res.data = "获取数据失败";
        }
        return res;
    }
}
