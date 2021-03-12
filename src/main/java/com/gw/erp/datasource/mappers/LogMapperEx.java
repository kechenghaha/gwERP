package com.gw.erp.datasource.mappers;

import com.gw.erp.datasource.vo.LogVo4List;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface LogMapperEx {

    List<LogVo4List> selectByConditionLog(
            @Param("operation") String operation,
            @Param("userId") Integer userId,
            @Param("clientIp") String clientIp,
            @Param("status") Integer status,
            @Param("beginTime") String beginTime,
            @Param("endTime") String endTime,
            @Param("content") String content,
            @Param("offset") Integer offset,
            @Param("rows") Integer rows);

    Long countsByLog(
            @Param("operation") String operation,
            @Param("userId") Integer userId,
            @Param("clientIp") String clientIp,
            @Param("status") Integer status,
            @Param("beginTime") String beginTime,
            @Param("endTime") String endTime,
            @Param("content") String content);
}