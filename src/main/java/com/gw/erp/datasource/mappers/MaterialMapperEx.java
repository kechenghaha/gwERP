package com.gw.erp.datasource.mappers;

import com.gw.erp.datasource.entities.Material;
import com.gw.erp.datasource.entities.MaterialVo4Unit;
import com.gw.erp.datasource.entities.Unit;
import org.apache.ibatis.annotations.Param;

import java.util.Date;
import java.util.List;
import java.util.Map;

public interface MaterialMapperEx {

    List<MaterialVo4Unit> selectByConditionMaterial(
            @Param("barCode") String barCode,
            @Param("name") String name,
            @Param("standard") String standard,
            @Param("model") String model,
            @Param("categoryIds") String categoryIds,
            @Param("mpList") String mpList,
            @Param("offset") Integer offset,
            @Param("rows") Integer rows);

    Long countsByMaterial(
            @Param("barCode") String barCode,
            @Param("name") String name,
            @Param("standard") String standard,
            @Param("model") String model,
            @Param("categoryIds") String categoryIds,
            @Param("mpList") String mpList);

    List<Unit> findUnitList(@Param("mId") Long mId);

    List<MaterialVo4Unit> findById(@Param("id") Long id);

    List<MaterialVo4Unit> findByIdWithBarCode(@Param("meId") Long meId);

    List<MaterialVo4Unit> findBySelectWithBarCode(@Param("idList") List<Long> idList,
                                                  @Param("q") String q,
                                                  @Param("offset") Integer offset,
                                                  @Param("rows") Integer rows);

    int findBySelectWithBarCodeCount(@Param("idList") List<Long> idList,
                                     @Param("q") String q);

    List<MaterialVo4Unit> findByAll(
            @Param("name") String name,
            @Param("model") String model,
            @Param("categoryIds") String categoryIds);
    /**
     * 通过商品名称查询商品信息
     * */
    List<Material> findByMaterialName(@Param("name") String name);
    /**
     * 获取开启序列号并且状态正常的商品列表
     * */
    List<Material> getMaterialEnableSerialNumberList(Map<String, Object> parameterMap);

    Long getMaterialEnableSerialNumberCount(Map<String, Object> parameterMap);

    int batchDeleteMaterialByIds(@Param("updateTime") Date updateTime, @Param("updater") Long updater, @Param("ids") String ids[]);

    List<Material> getMaterialListByCategoryIds(@Param("categoryIds") String[] categoryIds);

    List<Material> getMaterialListByUnitIds(@Param("unitIds") String[] unitIds);

    String getMaxBarCode();

    List<MaterialVo4Unit> getMaterialByMeId(
            @Param("meId") Long meId);

    List<String> getMaterialNameList();

    int setUnitIdToNull(@Param("id") Long id);
}
