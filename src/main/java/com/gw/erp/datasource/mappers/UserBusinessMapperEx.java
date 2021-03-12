package com.gw.erp.datasource.mappers;

import org.apache.ibatis.annotations.Param;

import java.util.Date;
public interface UserBusinessMapperEx {

    int batchDeleteUserBusinessByIds(@Param("updateTime") Date updateTime, @Param("updater") Long updater, @Param("ids") String ids[]);

}
