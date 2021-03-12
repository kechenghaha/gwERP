package com.gw.erp.datasource.mappers;

import com.gw.erp.datasource.entities.PlatformConfig;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface PlatformConfigMapperEx {

    List<PlatformConfig> selectByConditionPlatformConfig(
            @Param("key") String key,
            @Param("offset") Integer offset,
            @Param("rows") Integer rows);

    Long countsByPlatformConfig(
            @Param("key") String key);

}