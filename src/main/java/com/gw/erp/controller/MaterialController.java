package com.gw.erp.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.gw.erp.constants.BusinessConstants;
import com.gw.erp.constants.ExceptionConstants;
import com.gw.erp.datasource.entities.Material;
import com.gw.erp.datasource.entities.MaterialVo4Unit;
import com.gw.erp.exception.BusinessRunTimeException;
import com.gw.erp.service.depotItem.DepotItemService;
import com.gw.erp.service.material.MaterialService;
import com.gw.erp.utils.*;
import jxl.Sheet;
import jxl.Workbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.math.BigDecimal;
import java.util.*;

import static com.gw.erp.utils.ResponseJsonUtil.returnJson;

@RestController
@RequestMapping(value = "/material")
public class MaterialController {
    private Logger logger = LoggerFactory.getLogger(MaterialController.class);

    @Resource
    private MaterialService materialService;

    @Resource
    private DepotItemService depotItemService;

    @GetMapping(value = "/checkIsExist")
    public String checkIsExist(@RequestParam("id") Long id, @RequestParam("name") String name,
                               @RequestParam("model") String model, @RequestParam("color") String color,
                               @RequestParam("standard") String standard, @RequestParam("mfrs") String mfrs,
                               @RequestParam("otherField1") String otherField1, @RequestParam("otherField2") String otherField2,
                               @RequestParam("otherField3") String otherField3, @RequestParam("unit") String unit,@RequestParam("unitId") Long unitId,
                               HttpServletRequest request)throws Exception {
        Map<String, Object> objectMap = new HashMap<String, Object>();
        int exist = materialService.checkIsExist(id, name, model, color, standard, mfrs,
                otherField1, otherField2, otherField3, unit, unitId);
        if(exist > 0) {
            objectMap.put("status", true);
        } else {
            objectMap.put("status", false);
        }
        return returnJson(objectMap, ErpInfo.OK.name, ErpInfo.OK.code);
    }

    /**
     * ??????????????????-??????????????????
     * @param enabled
     * @param materialIDs
     * @param request
     * @return
     */
    @PostMapping(value = "/batchSetEnable")
    public String batchSetEnable(@RequestParam("enabled") Boolean enabled,
                                 @RequestParam("materialIDs") String materialIDs,
                                 HttpServletRequest request)throws Exception {
        Map<String, Object> objectMap = new HashMap<String, Object>();
        int res = materialService.batchSetEnable(enabled, materialIDs);
        if(res > 0) {
            return returnJson(objectMap, ErpInfo.OK.name, ErpInfo.OK.code);
        } else {
            return returnJson(objectMap, ErpInfo.ERROR.name, ErpInfo.ERROR.code);
        }
    }

    /**
     * ??????id?????????????????????
     * @param id
     * @param request
     * @return
     */
    @GetMapping(value = "/findById")
    public BaseResponseInfo findById(@RequestParam("id") Long id, HttpServletRequest request) throws Exception{
        BaseResponseInfo res = new BaseResponseInfo();
        try {
            List<MaterialVo4Unit> list = materialService.findById(id);
            res.code = 200;
            res.data = list;
        } catch(Exception e){
            e.printStackTrace();
            res.code = 500;
            res.data = "??????????????????";
        }
        return res;
    }

    /**
     * ??????meId?????????????????????
     * @param meId
     * @param request
     * @return
     */
    @GetMapping(value = "/findByIdWithBarCode")
    public BaseResponseInfo findByIdWithBarCode(@RequestParam("meId") Long meId,
                                                @RequestParam("mpList") String mpList,
                                                HttpServletRequest request) throws Exception{
        BaseResponseInfo res = new BaseResponseInfo();
        try {
            String[] mpArr = mpList.split(",");
            MaterialVo4Unit mu = new MaterialVo4Unit();
            List<MaterialVo4Unit> list = materialService.findByIdWithBarCode(meId);
            if(list!=null && list.size()>0) {
                mu = list.get(0);
                String expand = ""; //????????????
                for (int i = 0; i < mpArr.length; i++) {
                    if (mpArr[i].equals("?????????")) {
                        expand = expand + ((mu.getMfrs() == null || mu.getMfrs().equals("")) ? "" : "(" + mu.getMfrs() + ")");
                    }
                    if (mpArr[i].equals("?????????1")) {
                        expand = expand + ((mu.getOtherField1() == null || mu.getOtherField1().equals("")) ? "" : "(" + mu.getOtherField1() + ")");
                    }
                    if (mpArr[i].equals("?????????2")) {
                        expand = expand + ((mu.getOtherField2() == null || mu.getOtherField2().equals("")) ? "" : "(" + mu.getOtherField2() + ")");
                    }
                    if (mpArr[i].equals("?????????3")) {
                        expand = expand + ((mu.getOtherField3() == null || mu.getOtherField3().equals("")) ? "" : "(" + mu.getOtherField3() + ")");
                    }
                }
                mu.setMaterialOther(expand);
            }
            res.code = 200;
            res.data = mu;
        } catch(Exception e){
            e.printStackTrace();
            res.code = 500;
            res.data = "??????????????????";
        }
        return res;
    }

    /**
     * ??????????????????-?????????
     * @param mpList
     * @param request
     * @return
     */
    @GetMapping(value = "/findBySelect")
    public JSONObject findBySelect(@RequestParam(value = "categoryId", required = false) Long categoryId,
                                  @RequestParam(value = "q", required = false) String q,
                                  @RequestParam("mpList") String mpList,
                                  @RequestParam(value = "depotId", required = false) Long depotId,
                                  @RequestParam("page") Integer currentPage,
                                  @RequestParam("rows") Integer pageSize,
                                  HttpServletRequest request) throws Exception{
        JSONObject object = new JSONObject();
        try {
            Long tenantId = Long.parseLong(request.getSession().getAttribute("tenantId").toString());
            List<MaterialVo4Unit> dataList = materialService.findBySelectWithBarCode(categoryId, q, (currentPage-1)*pageSize, pageSize);
            String[] mpArr = mpList.split(",");
            int total = materialService.findBySelectWithBarCodeCount(categoryId, q);
            object.put("total", total);
            JSONArray dataArray = new JSONArray();
            //????????????json??????
            if (null != dataList) {
                for (MaterialVo4Unit material : dataList) {
                    JSONObject item = new JSONObject();
                    item.put("Id", material.getMeId()); //??????????????????id
                    String ratio; //??????
                    if (material.getUnitId() == null || material.getUnitId().equals("")) {
                        ratio = "";
                    } else {
                        ratio = material.getUnitName();
                        if(ratio!=null) {
                            ratio = ratio.substring(ratio.indexOf("("));
                        }
                    }
                    //??????/??????/????????????/??????
                    String MaterialName = "";
                    String mBarCode = "";
                    if(material.getmBarCode()!=null) {
                        mBarCode = material.getmBarCode();
                        MaterialName = MaterialName + mBarCode + "_";
                    }
                    item.put("mBarCode", mBarCode);
                    MaterialName = MaterialName + " " + material.getName()
                            + ((material.getStandard() == null || material.getStandard().equals("")) ? "" : "(" + material.getStandard() + ")")
                            + ((material.getModel() == null || material.getModel().equals("")) ? "" : "(" + material.getModel() + ")");
                    String expand = ""; //????????????
                    for (int i = 0; i < mpArr.length; i++) {
                        if (mpArr[i].equals("?????????")) {
                            expand = expand + ((material.getMfrs() == null || material.getMfrs().equals("")) ? "" : "(" + material.getMfrs() + ")");
                        }
                        if (mpArr[i].equals("?????????1")) {
                            expand = expand + ((material.getOtherField1() == null || material.getOtherField1().equals("")) ? "" : "(" + material.getOtherField1() + ")");
                        }
                        if (mpArr[i].equals("?????????2")) {
                            expand = expand + ((material.getOtherField2() == null || material.getOtherField2().equals("")) ? "" : "(" + material.getOtherField2() + ")");
                        }
                        if (mpArr[i].equals("?????????3")) {
                            expand = expand + ((material.getOtherField3() == null || material.getOtherField3().equals("")) ? "" : "(" + material.getOtherField3() + ")");
                        }
                    }
                    MaterialName = MaterialName + expand + ((material.getCommodityUnit() == null || material.getCommodityUnit().equals("")) ? "" : "(" + material.getCommodityUnit() + ")") + ratio;
                    item.put("MaterialName", MaterialName);
                    item.put("categoryName", material.getCategoryName());
                    item.put("name", material.getName());
                    item.put("expand", expand);
                    item.put("model", material.getModel());
                    item.put("standard", material.getStandard());
                    item.put("unit", material.getCommodityUnit() + ratio);
                    if(depotId!=null) {
                        BigDecimal stock = depotItemService.getStockByParam(depotId,material.getId(),null,null,tenantId);
                        item.put("stock", stock);
                    }
                    dataArray.add(item);
                }
            }
            object.put("rows", dataArray);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return object;
    }

    /**
     * ????????????id??????????????????
     * @param meId
     * @param request
     * @return
     * @throws Exception
     */
    @GetMapping(value = "/getMaterialByMeId")
    public JSONObject getMaterialByMeId(@RequestParam(value = "meId", required = false) Long meId,
                                        @RequestParam("mpList") String mpList,
                                        HttpServletRequest request) throws Exception{
        JSONObject item = new JSONObject();
        try {
            String[] mpArr = mpList.split(",");
            List<MaterialVo4Unit> materialList = materialService.getMaterialByMeId(meId);
            if(materialList!=null && materialList.size()!=1) {
                return item;
            } else if(materialList.size() == 1) {
                MaterialVo4Unit material = materialList.get(0);
                item.put("Id", material.getMeId()); //??????????????????id
                String ratio; //??????
                if (material.getUnitId() == null || material.getUnitId().equals("")) {
                    ratio = "";
                } else {
                    ratio = material.getUnitName();
                    ratio = ratio.substring(ratio.indexOf("("));
                }
                //??????/??????/????????????/??????
                String MaterialName = "";
                MaterialName = MaterialName + material.getmBarCode() + "_" + material.getName()
                        + ((material.getStandard() == null || material.getStandard().equals("")) ? "" : "(" + material.getStandard() + ")");
                String expand = ""; //????????????
                for (int i = 0; i < mpArr.length; i++) {
                    if (mpArr[i].equals("??????")) {
                        expand = expand + ((material.getColor() == null || material.getColor().equals("")) ? "" : "(" + material.getColor() + ")");
                    }
                    if (mpArr[i].equals("?????????")) {
                        expand = expand + ((material.getMfrs() == null || material.getMfrs().equals("")) ? "" : "(" + material.getMfrs() + ")");
                    }
                    if (mpArr[i].equals("?????????1")) {
                        expand = expand + ((material.getOtherField1() == null || material.getOtherField1().equals("")) ? "" : "(" + material.getOtherField1() + ")");
                    }
                    if (mpArr[i].equals("?????????2")) {
                        expand = expand + ((material.getOtherField2() == null || material.getOtherField2().equals("")) ? "" : "(" + material.getOtherField2() + ")");
                    }
                    if (mpArr[i].equals("?????????3")) {
                        expand = expand + ((material.getOtherField3() == null || material.getOtherField3().equals("")) ? "" : "(" + material.getOtherField3() + ")");
                    }
                }
                MaterialName = MaterialName + expand + ((material.getUnit() == null || material.getUnit().equals("")) ? "" : "(" + material.getUnit() + ")") + ratio;
                item.put("MaterialName", MaterialName);
                item.put("name", material.getName());
                item.put("expand", expand);
                item.put("model", material.getModel());
                item.put("standard", material.getStandard());
                item.put("unit", material.getUnit() + ratio);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return item;
    }

    /**
     * ??????excel??????
     * @param name
     * @param model
     * @param categoryIds
     * @param request
     * @param response
     * @return
     */
    @GetMapping(value = "/exportExcel")
    public void exportExcel(@RequestParam("name") String name,
                                        @RequestParam("model") String model,
                                        @RequestParam("categoryIds") String categoryIds,
                                        HttpServletRequest request, HttpServletResponse response) {
        try {
            List<MaterialVo4Unit> dataList = materialService.findByAll(StringUtil.toNull(name), StringUtil.toNull(model),
                    StringUtil.toNull(categoryIds));
            String[] names = {"??????", "??????", "??????", "????????????", "??????", "?????????", "????????????", "?????????", "?????????", "??????", "??????"};
            String title = "????????????";
            List<String[]> objects = new ArrayList<String[]>();
            if (null != dataList) {
                for (MaterialVo4Unit m : dataList) {
                    String[] objs = new String[11];
                    objs[0] = m.getName();
                    objs[1] = m.getCategoryName();
                    objs[2] = m.getModel();
                    objs[3] = m.getSafetyStock() == null? "" : m.getSafetyStock().toString();
                    objs[4] = m.getCommodityUnit();
                    objs[5] = m.getCommodityDecimal() == null? "" : m.getCommodityDecimal().toString();
                    objs[6] = m.getLowDecimal() == null? "" : m.getLowDecimal().toString();
                    objs[7] = m.getPurchaseDecimal() == null? "" : m.getPurchaseDecimal().toString();
                    objs[8] = m.getWholesaleDecimal() == null? "" : m.getWholesaleDecimal().toString();
                    objs[9] = m.getRemark();
                    objs[10] = m.getEnabled() ? "??????" : "??????";
                    objects.add(objs);
                }
            }
            File file = ExcelUtils.exportObjectsWithoutTitle(title, names, title, objects);
            ExportExecUtil.showExec(file, file.getName(), response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * excel???????????????????????????????????????
     * @param materialFile
     * @param request
     * @param response
     * @return
     */
    @PostMapping(value = "/importExcel")
    public void importExcel(MultipartFile materialFile,
                            HttpServletRequest request, HttpServletResponse response) throws Exception{
        BaseResponseInfo info = new BaseResponseInfo();
        Map<String, Object> data = new HashMap<String, Object>();
        String message = "??????";
        try {
            Sheet src = null;
            //?????????????????????
            try {
                Workbook workbook = Workbook.getWorkbook(materialFile.getInputStream());
                src = workbook.getSheet(0);
            } catch (Exception e) {
                message = "?????????????????????????????????";
                data.put("message", message);
                info.code = 400;
                info.data = data;
            }
            info = materialService.importExcel(src);
        } catch (Exception e) {
            e.printStackTrace();
            message = "????????????";
            info.code = 500;
            data.put("message", message);
            info.data = data;
        }
        response.sendRedirect("../pages/materials/material.html");
    }

    public BigDecimal parseBigDecimalEx(String str)throws Exception{
        if(!StringUtil.isEmpty(str)) {
            return  new BigDecimal(str);
        } else {
            return null;
        }
    }
    @GetMapping(value = "/getMaterialEnableSerialNumberList")
    public String getMaterialEnableSerialNumberList(@RequestParam(value = Constants.PAGE_SIZE, required = false) Integer pageSize,
                               @RequestParam(value = Constants.CURRENT_PAGE, required = false) Integer currentPage,
                               @RequestParam(value = Constants.SEARCH, required = false) String search)throws Exception {
        Map<String, Object> parameterMap = new HashMap<String, Object>();
        //????????????
        JSONObject obj=JSON.parseObject(search);
        Set<String> key= obj.keySet();
        for(String keyEach: key){
            parameterMap.put(keyEach,obj.getString(keyEach));
        }
        PageQueryInfo queryInfo = new PageQueryInfo();
        Map<String, Object> objectMap = new HashMap<String, Object>();
        List<Material> list = materialService.getMaterialEnableSerialNumberList(parameterMap);
        Long count = materialService.getMaterialEnableSerialNumberCount(parameterMap);
        objectMap.put("page", queryInfo);
        if (list == null) {
            queryInfo.setRows(new ArrayList<Object>());
            queryInfo.setTotal(BusinessConstants.DEFAULT_LIST_NULL_NUMBER);
            return returnJson(objectMap, "??????????????????", ErpInfo.OK.code);
        }
        queryInfo.setRows(list);
        queryInfo.setTotal(count);
        return returnJson(objectMap, ErpInfo.OK.name, ErpInfo.OK.code);
    }
    /**
     * description:
     *  ????????????????????????
     * @Param: ids
     * @return java.lang.Object
     */
    @PostMapping(value = "/batchDeleteMaterialByIds")
    public Object batchDeleteMaterialByIds(@RequestParam("ids") String ids,@RequestParam(value="deleteType",
            required =false,defaultValue= BusinessConstants.DELETE_TYPE_NORMAL)String deleteType) throws Exception {
        JSONObject result = ExceptionConstants.standardSuccess();
        int i=0;
        if(BusinessConstants.DELETE_TYPE_NORMAL.equals(deleteType)){
            i= materialService.batchDeleteMaterialByIdsNormal(ids);
        }else if(BusinessConstants.DELETE_TYPE_FORCE.equals(deleteType)){
            i= materialService.batchDeleteMaterialByIds(ids);
        }else{
            logger.error("?????????[{}],????????????[{}],??????,ids[{}],deleteType[{}]",
                    ExceptionConstants.DELETE_REFUSED_CODE,ExceptionConstants.DELETE_REFUSED_MSG,ids,deleteType);
            throw new BusinessRunTimeException(ExceptionConstants.DELETE_REFUSED_CODE,
                    ExceptionConstants.DELETE_REFUSED_MSG);
        }
        if(i<1){
            logger.error("?????????[{}],????????????[{}],??????,ids[{}]",
                    ExceptionConstants.MATERIAL_DELETE_FAILED_CODE,ExceptionConstants.MATERIAL_DELETE_FAILED_MSG,ids);
            throw new BusinessRunTimeException(ExceptionConstants.MATERIAL_DELETE_FAILED_CODE,
                    ExceptionConstants.MATERIAL_DELETE_FAILED_MSG);
        }
        return result;
    }

    @GetMapping(value = "/getMaxBarCode")
    public BaseResponseInfo getMaxBarCode() throws Exception {
        BaseResponseInfo res = new BaseResponseInfo();
        Map<String, Object> map = new HashMap<String, Object>();
        String barCode = materialService.getMaxBarCode();
        map.put("barCode", barCode);
        res.code = 200;
        res.data = map;
        return res;
    }

    /**
     * ????????????????????????
     * @return
     * @throws Exception
     */
    @GetMapping(value = "/getMaterialNameList")
    public JSONArray getMaterialNameList() throws Exception {
        JSONArray arr = new JSONArray();
        try {
            List<String> list = materialService.getMaterialNameList();
            for (String s : list) {
                JSONObject item = new JSONObject();
                item.put("value", s);
                item.put("text", s);
                arr.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return arr;
    }
}
