package com.gw.erp.service.material;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.gw.erp.constants.BusinessConstants;
import com.gw.erp.constants.ExceptionConstants;
import com.gw.erp.datasource.entities.*;
import com.gw.erp.datasource.mappers.*;
import com.gw.erp.exception.BusinessRunTimeException;
import com.gw.erp.exception.GwException;
import com.gw.erp.service.MaterialExtend.MaterialExtendService;
import com.gw.erp.service.depot.DepotService;
import com.gw.erp.service.depotItem.DepotItemService;
import com.gw.erp.service.log.LogService;
import com.gw.erp.service.materialCategory.MaterialCategoryService;
import com.gw.erp.service.unit.UnitService;
import com.gw.erp.service.user.UserService;
import com.gw.erp.utils.BaseResponseInfo;
import com.gw.erp.utils.ExcelUtils;
import com.gw.erp.utils.StringUtil;
import jxl.Sheet;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.util.*;

@Service
public class MaterialService {
    private Logger logger = LoggerFactory.getLogger(MaterialService.class);

    @Resource
    private MaterialMapper materialMapper;
    @Resource
    private MaterialExtendMapper materialExtendMapper;
    @Resource
    private MaterialMapperEx materialMapperEx;
    @Resource
    private MaterialExtendMapperEx materialExtendMapperEx;
    @Resource
    private MaterialCategoryMapperEx materialCategoryMapperEx;
    @Resource
    private LogService logService;
    @Resource
    private UserService userService;
    @Resource
    private DepotItemMapperEx depotItemMapperEx;
    @Resource
    private DepotItemService depotItemService;
    @Resource
    private MaterialCategoryService materialCategoryService;
    @Resource
    private UnitService unitService;
    @Resource
    private MaterialInitialStockMapper materialInitialStockMapper;
    @Resource
    private MaterialCurrentStockMapper materialCurrentStockMapper;
    @Resource
    private DepotService depotService;
    @Resource
    private MaterialExtendService materialExtendService;

    public Material getMaterial(long id)throws Exception {
        Material result=null;
        try{
            result=materialMapper.selectByPrimaryKey(id);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return result;
    }

    public List<Material> getMaterialListByIds(String ids)throws Exception {
        List<Long> idList = StringUtil.strToLongList(ids);
        List<Material> list = new ArrayList<>();
        try{
            MaterialExample example = new MaterialExample();
            example.createCriteria().andIdIn(idList);
            list = materialMapper.selectByExample(example);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list;
    }

    public List<Material> getMaterial() throws Exception{
        MaterialExample example = new MaterialExample();
        example.createCriteria().andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
        List<Material> list=null;
        try{
            list=materialMapper.selectByExample(example);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list;
    }

    public List<MaterialVo4Unit> select(String barCode, String name, String standard, String model, String categoryIds,String mpList, int offset, int rows)
            throws Exception{
        String[] mpArr = mpList.split(",");
        List<MaterialVo4Unit> resList = new ArrayList<>();
        List<MaterialVo4Unit> list =null;
        try{
            list= materialMapperEx.selectByConditionMaterial(barCode, name, standard, model, categoryIds, mpList, offset, rows);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        if (null != list) {
            for (MaterialVo4Unit m : list) {
                //????????????
                String materialOther = "";
                for (int i = 0; i < mpArr.length; i++) {
                    if (mpArr[i].equals("?????????")) {
                        materialOther = materialOther + ((m.getMfrs() == null || m.getMfrs().equals("")) ? "" : "(" + m.getMfrs() + ")");
                    }
                    if (mpArr[i].equals("?????????1")) {
                        materialOther = materialOther + ((m.getOtherField1() == null || m.getOtherField1().equals("")) ? "" : "(" + m.getOtherField1() + ")");
                    }
                    if (mpArr[i].equals("?????????2")) {
                        materialOther = materialOther + ((m.getOtherField2() == null || m.getOtherField2().equals("")) ? "" : "(" + m.getOtherField2() + ")");
                    }
                    if (mpArr[i].equals("?????????3")) {
                        materialOther = materialOther + ((m.getOtherField3() == null || m.getOtherField3().equals("")) ? "" : "(" + m.getOtherField3() + ")");
                    }
                }
                m.setMaterialOther(materialOther);
                Long tenantId = m.getTenantId();
                m.setStock(depotItemService.getStockByParam(null,m.getId(),null,null,tenantId));
                resList.add(m);
            }
        }
        return resList;
    }

    public Long countMaterial(String barCode, String name, String standard, String model, String categoryIds,String mpList)throws Exception {
        Long result =null;
        try{
            result= materialMapperEx.countsByMaterial(barCode, name, standard, model, categoryIds, mpList);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return result;
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int insertMaterial(String beanJson, HttpServletRequest request)throws Exception {
        Material m = JSONObject.parseObject(beanJson, Material.class);
        m.setEnabled(true);
        try{
            Long mId = null;
            materialMapper.insertSelective(m);
            List<Material> materials = getMaterialListByParam(m.getName(),m.getModel(),m.getColor(),
                    m.getStandard(), m.getMfrs(),m.getUnit(),m.getUnitId());
            if(materials!=null && materials.size()>0) {
                mId = materials.get(0).getId();
            }
            JSONObject mObj = JSON.parseObject(beanJson);
            materialExtendService.saveDetials(mObj.getString("inserted"), mObj.getString("deleted"), mObj.getString("updated"),mObj.getString("sortList"), mId);
            if(mObj.get("stock")!=null) {
                String stockStr = mObj.getString("stock");
                JSONArray stockArr = JSONArray.parseArray(stockStr);
                for(Object object: stockArr) {
                    JSONObject jsonObj = (JSONObject)object;
                    if(jsonObj.get("depotId")!=null && jsonObj.get("number")!=null) {
                        String number = jsonObj.getString("number");
                        Long depotId = jsonObj.getLong("depotId");
                        if(StringUtil.isNotEmpty(number) && Double.valueOf(number)>0) {
                            insertStockByMaterialAndDepot(depotId, mId, parseBigDecimalEx(number));
                        }
                    }
                }
            }
            logService.insertLog("??????",
                    new StringBuffer(BusinessConstants.LOG_OPERATION_TYPE_ADD).append(m.getName()).toString(), request);
            return 1;
        }catch(Exception e){
            GwException.writeFail(logger, e);
            return 0;
        }
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int updateMaterial(String beanJson, Long id, HttpServletRequest request) throws Exception{
        Material material = JSONObject.parseObject(beanJson, Material.class);
        material.setId(id);
        try{
            materialMapper.updateByPrimaryKeySelective(material);
            if(material.getUnitId() == null) {
                materialMapperEx.setUnitIdToNull(material.getId());
            }
            JSONObject mObj = JSON.parseObject(beanJson);
            materialExtendService.saveDetials(mObj.getString("inserted"),mObj.getString("deleted"),mObj.getString("updated"),mObj.getString("sortList"),id);
            if(mObj.get("stock")!=null) {
                String stockStr = mObj.getString("stock");
                JSONArray stockArr = JSONArray.parseArray(stockStr);
                for (Object object : stockArr) {
                    JSONObject jsonObj = (JSONObject) object;
                    if (jsonObj.get("depotId") != null && jsonObj.get("number") != null) {
                        String number = jsonObj.getString("number");
                        Long depotId = jsonObj.getLong("depotId");
                        //??????????????????
                        MaterialInitialStockExample example = new MaterialInitialStockExample();
                        example.createCriteria().andMaterialIdEqualTo(id).andDepotIdEqualTo(depotId);
                        materialInitialStockMapper.deleteByExample(example);
                        if (StringUtil.isNotEmpty(number) && Double.valueOf(number) > 0) {
                            insertStockByMaterialAndDepot(depotId, id, parseBigDecimalEx(number));
                        }
                    }
                }
            }
            logService.insertLog("??????",
                    new StringBuffer(BusinessConstants.LOG_OPERATION_TYPE_EDIT).append(material.getName()).toString(), request);
            return 1;
        }catch(Exception e){
            GwException.writeFail(logger, e);
            return 0;
        }
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int deleteMaterial(Long id, HttpServletRequest request)throws Exception {
        int result =0;
        try{
            result= materialMapper.deleteByPrimaryKey(id);
            logService.insertLog("??????",
                    new StringBuffer(BusinessConstants.LOG_OPERATION_TYPE_DELETE).append(id).toString(), request);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int batchDeleteMaterial(String ids, HttpServletRequest request)throws Exception {
        List<Long> idList = StringUtil.strToLongList(ids);
        MaterialExample example = new MaterialExample();
        example.createCriteria().andIdIn(idList);
        int result =0;
        try{
            result= materialMapper.deleteByExample(example);
            logService.insertLog("??????", "????????????,id???:" + ids, request);
        }catch(Exception e){
            GwException.writeFail(logger, e);
        }
        return result;
    }

    public int checkIsNameExist(Long id, String name)throws Exception {
        MaterialExample example = new MaterialExample();
        example.createCriteria().andIdNotEqualTo(id).andNameEqualTo(name).andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
        List<Material> list =null;
        try{
            list=  materialMapper.selectByExample(example);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list==null?0:list.size();
    }

    public int checkIsExist(Long id, String name, String model, String color, String standard, String mfrs,
                            String otherField1, String otherField2, String otherField3, String unit, Long unitId)throws Exception {
        MaterialExample example = new MaterialExample();
        MaterialExample.Criteria criteria = example.createCriteria();
        criteria.andNameEqualTo(name).andModelEqualTo(model).andColorEqualTo(color)
                .andStandardEqualTo(standard).andMfrsEqualTo(mfrs)
                .andOtherField1EqualTo(otherField1).andOtherField2EqualTo(otherField2).andOtherField2EqualTo(otherField3)
                .andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
        if (id > 0) {
            criteria.andIdNotEqualTo(id);
        }
        if (!StringUtil.isEmpty(unit)) {
            criteria.andUnitEqualTo(unit);
        }
        if (unitId !=null) {
            criteria.andUnitIdEqualTo(unitId);
        }
        List<Material> list =null;
        try{
            list=  materialMapper.selectByExample(example);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list==null?0:list.size();
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int batchSetEnable(Boolean enabled, String materialIDs)throws Exception {
        logService.insertLog("??????",
                new StringBuffer(BusinessConstants.LOG_OPERATION_TYPE_EDIT).append(materialIDs).toString(),
                ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest());
        List<Long> ids = StringUtil.strToLongList(materialIDs);
        Material material = new Material();
        material.setEnabled(enabled);
        MaterialExample example = new MaterialExample();
        example.createCriteria().andIdIn(ids);
        int result =0;
        try{
            result=  materialMapper.updateByExampleSelective(material, example);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return result;
    }

    public Unit findUnit(Long mId)throws Exception{
        Unit unit = new Unit();
        try{
            List<Unit> list = materialMapperEx.findUnitList(mId);
            if(list!=null && list.size()>0) {
                unit = list.get(0);
            }
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return unit;
    }

    public List<MaterialVo4Unit> findById(Long id)throws Exception{
        List<MaterialVo4Unit> list =null;
        try{
            list=  materialMapperEx.findById(id);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list;
    }

    public List<MaterialVo4Unit> findByIdWithBarCode(Long meId)throws Exception{
        List<MaterialVo4Unit> list =null;
        try{
            list=  materialMapperEx.findByIdWithBarCode(meId);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list;
    }

    public List<Long> getListByParentId(Long parentId) {
        List<Long> idList = new ArrayList<Long>();
        List<MaterialCategory> list = materialCategoryMapperEx.getListByParentId(parentId);
        idList.add(parentId);
        if(list!=null && list.size()>0) {
            getIdListByParentId(idList, parentId);
        }
        return idList;
    }

    public List<Long> getIdListByParentId(List<Long> idList, Long parentId){
        List<MaterialCategory> list = materialCategoryMapperEx.getListByParentId(parentId);
        if(list!=null && list.size()>0) {
            for(MaterialCategory mc : list){
                idList.add(mc.getId());
                getIdListByParentId(idList, mc.getId());
            }
        }
        return idList;
    }

    public List<MaterialVo4Unit> findBySelectWithBarCode(Long categoryId, String q, Integer offset, Integer rows)throws Exception{
        List<MaterialVo4Unit> list =null;
        try{
            List<Long> idList = new ArrayList<>();
            if(categoryId!=null){
                Long parentId = categoryId;
                idList = getListByParentId(parentId);
            }
            if(StringUtil.isNotEmpty(q)) {
                q = q.replace("'", "");
            }
            list=  materialMapperEx.findBySelectWithBarCode(idList, q, offset, rows);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list;
    }

    public int findBySelectWithBarCodeCount(Long categoryId, String q)throws Exception{
        int result=0;
        try{
            List<Long> idList = new ArrayList<>();
            if(categoryId!=null){
                Long parentId = categoryId;
                idList = getListByParentId(parentId);
            }
            if(StringUtil.isNotEmpty(q)) {
                q = q.replace("'", "");
            }
            result = materialMapperEx.findBySelectWithBarCodeCount(idList, q);
        }catch(Exception e){
            logger.error("?????????[{}],????????????[{}],??????[{}]",
                    ExceptionConstants.DATA_READ_FAIL_CODE,ExceptionConstants.DATA_READ_FAIL_MSG,e);
            throw new BusinessRunTimeException(ExceptionConstants.DATA_READ_FAIL_CODE,
                    ExceptionConstants.DATA_READ_FAIL_MSG);
        }
        return result;
    }

    public List<MaterialVo4Unit> findByAll(String name, String model, String categoryIds)throws Exception {
        List<MaterialVo4Unit> resList = new ArrayList<MaterialVo4Unit>();
        List<MaterialVo4Unit> list =null;
        try{
            list=  materialMapperEx.findByAll(name, model, categoryIds);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        if (null != list) {
            for (MaterialVo4Unit m : list) {
                resList.add(m);
            }
        }
        return resList;
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public BaseResponseInfo importExcel(Sheet src) throws Exception {
        List<Depot> depotList= depotService.getDepot();
        int depotCount = depotList.size();
        List<MaterialWithInitStock> mList = new ArrayList<>();
        for (int i = 2; i < src.getRows(); i++) {
            String name = ExcelUtils.getContent(src, i, 0); //??????
            String standard = ExcelUtils.getContent(src, i, 1); //??????
            String model = ExcelUtils.getContent(src, i, 2); //??????
            String color = ExcelUtils.getContent(src, i, 3); //??????
            String categoryName = ExcelUtils.getContent(src, i, 4); //??????
            String safetyStock = ExcelUtils.getContent(src, i, 5); //????????????
            String unit = ExcelUtils.getContent(src, i, 6); //????????????
            //??????????????????????????????????????????
            if(StringUtil.isNotEmpty(name) && StringUtil.isNotEmpty(model) && StringUtil.isNotEmpty(unit)) {
                MaterialWithInitStock m = new MaterialWithInitStock();
                m.setName(name);
                m.setStandard(standard);
                m.setModel(model);
                m.setColor(color);
                Long categoryId = materialCategoryService.getCategoryIdByName(categoryName);
                m.setCategoryId(categoryId);
                m.setSafetyStock(parseBigDecimalEx(safetyStock));
                String manyUnit = ExcelUtils.getContent(src, i, 7); //?????????
                String barCode = ExcelUtils.getContent(src, i, 8); //????????????
                String manyBarCode = ExcelUtils.getContent(src, i, 9); //?????????
                String ratio = ExcelUtils.getContent(src, i, 10); //??????
                String purchaseDecimal = ExcelUtils.getContent(src, i, 11); //?????????
                String commodityDecimal = ExcelUtils.getContent(src, i, 12); //?????????
                String wholesaleDecimal = ExcelUtils.getContent(src, i, 13); //?????????
                String lowDecimal = ExcelUtils.getContent(src, i, 14); //????????????
                JSONObject materialExObj = new JSONObject();
                JSONObject basicObj = new JSONObject();
                basicObj.put("barCode", barCode);
                basicObj.put("commodityUnit", unit);
                basicObj.put("purchaseDecimal", purchaseDecimal);
                basicObj.put("commodityDecimal", commodityDecimal);
                basicObj.put("wholesaleDecimal", wholesaleDecimal);
                basicObj.put("lowDecimal", lowDecimal);
                materialExObj.put("basic", basicObj);
                if(StringUtil.isNotEmpty(manyUnit.trim())){ //?????????
                    String manyUnitAll = unit + "," + manyUnit + "(1:" + ratio + ")";
                    Long unitId = unitService.getUnitIdByName(manyUnitAll);
                    m.setUnitId(unitId);
                    JSONObject otherObj = new JSONObject();
                    otherObj.put("barCode", manyBarCode);
                    otherObj.put("commodityUnit", manyUnit);
                    otherObj.put("purchaseDecimal", parsePrice(purchaseDecimal,ratio));
                    otherObj.put("commodityDecimal", parsePrice(commodityDecimal,ratio));
                    otherObj.put("wholesaleDecimal", parsePrice(wholesaleDecimal,ratio));
                    otherObj.put("lowDecimal", parsePrice(lowDecimal,ratio));
                    materialExObj.put("other", otherObj);
                } else {
                    m.setUnit(unit);
                }
                m.setMaterialExObj(materialExObj);
                String enabled = ExcelUtils.getContent(src, i, 15); //??????
                m.setEnabled(enabled.equals("1")? true: false);
                //?????????????????????????????????
                Map<Long, BigDecimal> stockMap = new HashMap<Long, BigDecimal>();
                for(int j=1; j<=depotCount;j++) {
                    int col = 15+j;
                    if(col < src.getColumns()){
                        String depotName = ExcelUtils.getContent(src, 1, col); //??????????????????
                        Long depotId = depotService.getIdByName(depotName);
                        if(depotId!=0L){
                            String stockStr = ExcelUtils.getContent(src, i, col);
                            if(StringUtil.isNotEmpty(stockStr)) {
                                stockMap.put(depotId, parseBigDecimalEx(stockStr));
                            }
                        }
                    }
                }
                m.setStockMap(stockMap);
                mList.add(m);
            }
        }
        logService.insertLog("??????",
                new StringBuffer(BusinessConstants.LOG_OPERATION_TYPE_IMPORT).append(mList.size()).append(BusinessConstants.LOG_DATA_UNIT).toString(),
                ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest());
        BaseResponseInfo info = new BaseResponseInfo();
        Map<String, Object> data = new HashMap<String, Object>();
        try {
            Long mId = 0L;
            for(MaterialWithInitStock m: mList) {
                //??????????????????????????????????????????????????????????????????????????????
                List<Material> materials = getMaterialListByParam(m.getName(),m.getModel(),m.getColor(),m.getStandard(),
                        m.getMfrs(),m.getUnit(),m.getUnitId());
                if(materials.size()<=0) {
                    materialMapper.insertSelective(m);
                    List<Material> newList = getMaterialListByParam(m.getName(),m.getModel(),m.getColor(),m.getStandard(),
                            m.getMfrs(),m.getUnit(),m.getUnitId());
                    if(newList!=null && newList.size()>0) {
                        mId = newList.get(0).getId();
                    }
                } else {
                    mId = materials.get(0).getId();
                    String materialJson = JSON.toJSONString(m);
                    Material material = JSONObject.parseObject(materialJson, Material.class);
                    material.setId(mId);
                    materialMapper.updateByPrimaryKeySelective(material);
                }
                //??????????????????????????????????????????
                User user = userService.getCurrentUser();
                JSONObject materialExObj = m.getMaterialExObj();
                if(StringUtil.isExist(materialExObj.get("basic"))){
                    String basicStr = materialExObj.getString("basic");
                    MaterialExtend basicMaterialExtend = JSONObject.parseObject(basicStr, MaterialExtend.class);
                    basicMaterialExtend.setMaterialId(mId);
                    basicMaterialExtend.setDefaultFlag("1");
                    basicMaterialExtend.setCreateTime(new Date());
                    basicMaterialExtend.setUpdateTime(System.currentTimeMillis());
                    basicMaterialExtend.setCreateSerial(user.getLoginName());
                    basicMaterialExtend.setUpdateSerial(user.getLoginName());
                    Long meId = materialExtendService.selectIdByMaterialIdAndDefaultFlag(mId, "1");
                    if(meId==0L){
                        materialExtendMapper.insertSelective(basicMaterialExtend);
                    } else {
                        basicMaterialExtend.setId(meId);
                        materialExtendMapper.updateByPrimaryKeySelective(basicMaterialExtend);
                    }
                }
                if(StringUtil.isExist(materialExObj.get("other"))) {
                    String otherStr = materialExObj.getString("other");
                    MaterialExtend otherMaterialExtend = JSONObject.parseObject(otherStr, MaterialExtend.class);
                    otherMaterialExtend.setMaterialId(mId);
                    otherMaterialExtend.setDefaultFlag("0");
                    otherMaterialExtend.setCreateTime(new Date());
                    otherMaterialExtend.setUpdateTime(System.currentTimeMillis());
                    otherMaterialExtend.setCreateSerial(user.getLoginName());
                    otherMaterialExtend.setUpdateSerial(user.getLoginName());
                    Long meId = materialExtendService.selectIdByMaterialIdAndDefaultFlag(mId, "0");
                    if(meId==0L){
                        materialExtendMapper.insertSelective(otherMaterialExtend);
                    } else {
                        otherMaterialExtend.setId(meId);
                        materialExtendMapper.updateByPrimaryKeySelective(otherMaterialExtend);
                    }
                }
                //????????????????????????
                Map<Long, BigDecimal> stockMap = m.getStockMap();
                Long depotId = null;
                for(Depot depot: depotList){
                    BigDecimal stock = stockMap.get(depot.getId());
                    //??????????????????
                    MaterialInitialStockExample example = new MaterialInitialStockExample();
                    example.createCriteria().andMaterialIdEqualTo(mId).andDepotIdEqualTo(depot.getId());
                    materialInitialStockMapper.deleteByExample(example);
                    if(stock!=null && stock.compareTo(BigDecimal.ZERO)!=0) {
                        depotId = depot.getId();
                        insertStockByMaterialAndDepot(depotId, mId, stock);
                    }
                }
            }
            info.code = 200;
            data.put("message", "??????");
        } catch (Exception e) {
            e.printStackTrace();
            info.code = 500;
            data.put("message", e.getMessage());
        }
        info.data = data;
        return info;
    }

    /**
     * ??????????????????????????????
     * @param name
     * @param model
     * @param color
     * @param standard
     * @param mfrs
     * @param unit
     * @param unitId
     * @return
     */
    private List<Material> getMaterialListByParam(String name, String model, String color,
                                                  String standard, String mfrs, String unit, Long unitId) {
        MaterialExample example = new MaterialExample();
        MaterialExample.Criteria criteria = example.createCriteria();
        criteria.andNameEqualTo(name).andModelEqualTo(model);
        if (StringUtil.isNotEmpty(color)) {
            criteria.andColorEqualTo(color);
        }
        if (StringUtil.isNotEmpty(standard)) {
            criteria.andStandardEqualTo(standard);
        }
        if (StringUtil.isNotEmpty(mfrs)) {
            criteria.andMfrsEqualTo(mfrs);
        }
        if (StringUtil.isNotEmpty(unit)) {
            criteria.andUnitEqualTo(unit);
        }
        if (unitId !=null) {
            criteria.andUnitIdEqualTo(unitId);
        }
        criteria.andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
        List<Material> list = materialMapper.selectByExample(example);
        return list;
    }

    /**
     * ??????????????????
     * @param depotId
     * @param mId
     * @param stock
     */
    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public void insertStockByMaterialAndDepot(Long depotId, Long mId, BigDecimal stock){
        MaterialInitialStock materialInitialStock = new MaterialInitialStock();
        materialInitialStock.setDepotId(depotId);
        materialInitialStock.setMaterialId(mId);
        materialInitialStock.setNumber(stock);
        materialInitialStockMapper.insertSelective(materialInitialStock); //??????????????????
    }

    public List<Material> getMaterialEnableSerialNumberList(Map<String, Object> parameterMap)throws Exception {
        List<Material> list =null;
        try{
            list=  materialMapperEx.getMaterialEnableSerialNumberList(parameterMap);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return list;
    }

    public Long getMaterialEnableSerialNumberCount(Map<String, Object> parameterMap)throws Exception {
        Long count =null;
        try{
            count=  materialMapperEx.getMaterialEnableSerialNumberCount(parameterMap);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return count;
    }

    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int batchDeleteMaterialByIds(String ids) throws Exception{
        StringBuffer sb = new StringBuffer();
        sb.append(BusinessConstants.LOG_OPERATION_TYPE_DELETE);
        List<Material> list = getMaterialListByIds(ids);
        for(Material material: list){
            sb.append("[").append(material.getName()).append("]");
        }
        logService.insertLog("??????", sb.toString(),
                ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest());
        User userInfo=userService.getCurrentUser();
        String [] idArray=ids.split(",");
        try{
            //??????????????????
            materialMapperEx.batchDeleteMaterialByIds(new Date(),userInfo==null?null:userInfo.getId(),idArray);
            //??????????????????????????????
            materialExtendMapperEx.batchDeleteMaterialExtendByMIds(idArray);
            return 1;
        }catch(Exception e){
            GwException.writeFail(logger, e);
            return 0;
        }
    }
    /**
     *  ???????????????????????????????????????????????????????????????
     * @Param: ids
     * @return int
     */
    @Transactional(value = "transactionManager", rollbackFor = Exception.class)
    public int batchDeleteMaterialByIdsNormal(String ids) throws Exception{
        /**
         * ??????
         * 1???????????????	gw_depot_item
         * ?????????????????????
         * */
        int deleteTotal=0;
        if(StringUtils.isEmpty(ids)){
            return deleteTotal;
        }
        String [] idArray=ids.split(",");

        /**
         * ??????????????????	gw_depot_item
         * */
        List<DepotItem> depotItemList =null;
        try{
            depotItemList=  depotItemMapperEx.getDepotItemListListByMaterialIds(idArray);
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        if(depotItemList!=null&&depotItemList.size()>0){
            logger.error("?????????[{}],????????????[{}],??????,MaterialIds[{}]",
                    ExceptionConstants.DELETE_FORCE_CONFIRM_CODE,ExceptionConstants.DELETE_FORCE_CONFIRM_MSG,ids);
            throw new BusinessRunTimeException(ExceptionConstants.DELETE_FORCE_CONFIRM_CODE,
                    ExceptionConstants.DELETE_FORCE_CONFIRM_MSG);
        }
        /**
         * ??????????????????????????????
         * */
        deleteTotal= batchDeleteMaterialByIds(ids);
        return deleteTotal;

    }

    public BigDecimal parseBigDecimalEx(String str) throws Exception{
        if(!StringUtil.isEmpty(str)) {
            return  new BigDecimal(str);
        } else {
            return null;
        }
    }

    public BigDecimal parsePrice(String price, String ratio) throws Exception{
        if(StringUtil.isEmpty(price) || StringUtil.isEmpty(ratio)) {
            return BigDecimal.ZERO;
        } else {
            BigDecimal pr=new BigDecimal(price);
            BigDecimal r=new BigDecimal(ratio);
            return pr.multiply(r);
        }
    }

    /**
     * ?????????????????????????????????????????????????????????????????????
     * @param materialId
     * @return
     */
    public BigDecimal getInitStockByMid(Long depotId, Long materialId) {
        BigDecimal stock = BigDecimal.ZERO;
        MaterialInitialStockExample example = new MaterialInitialStockExample();
        if(depotId!=null) {
            example.createCriteria().andMaterialIdEqualTo(materialId).andDepotIdEqualTo(depotId)
                    .andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
        } else {
            example.createCriteria().andMaterialIdEqualTo(materialId)
                    .andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
        }
        List<MaterialInitialStock> list = materialInitialStockMapper.selectByExample(example);
        if(list!=null && list.size()>0) {
            for(MaterialInitialStock ms: list) {
                if(ms!=null) {
                    stock = stock.add(ms.getNumber());
                }
            }
        }
        return stock;
    }

    /**
     * ???????????????????????????????????????
     * @param materialId
     * @param depotId
     * @return
     */
    public BigDecimal getInitStock(Long materialId, Long depotId) {
        BigDecimal stock = BigDecimal.ZERO;
        MaterialInitialStockExample example = new MaterialInitialStockExample();
        example.createCriteria().andMaterialIdEqualTo(materialId).andDepotIdEqualTo(depotId)
                .andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
        List<MaterialInitialStock> list = materialInitialStockMapper.selectByExample(example);
        if(list!=null && list.size()>0) {
            stock = list.get(0).getNumber();
        }
        return stock;
    }

    /**
     * ???????????????????????????????????????
     * @param materialId
     * @param depotId
     * @return
     */
    public BigDecimal getCurrentStock(Long materialId, Long depotId) {
        BigDecimal stock = BigDecimal.ZERO;
        MaterialCurrentStockExample example = new MaterialCurrentStockExample();
        example.createCriteria().andMaterialIdEqualTo(materialId).andDepotIdEqualTo(depotId)
                .andDeleteFlagNotEqualTo(BusinessConstants.DELETE_FLAG_DELETED);
        List<MaterialCurrentStock> list = materialCurrentStockMapper.selectByExample(example);
        if(list!=null && list.size()>0) {
            stock = list.get(0).getCurrentNumber();
        } else {
            stock = getInitStock(materialId,depotId);
        }
        return stock;
    }

    public List<MaterialVo4Unit> getMaterialByMeId(Long meId) {
        List<MaterialVo4Unit> result = new ArrayList<MaterialVo4Unit>();
        try{
            if(meId!=null) {
                result= materialMapperEx.getMaterialByMeId(meId);
            }
        }catch(Exception e){
            GwException.readFail(logger, e);
        }
        return result;
    }

    public String getMaxBarCode() {
        String maxBarCodeOld = materialMapperEx.getMaxBarCode();
        return Long.parseLong(maxBarCodeOld)+"";
    }

    public List<String> getMaterialNameList() {
        return materialMapperEx.getMaterialNameList();
    }
}
