package com.gw.erp.datasource.mappers;

import com.gw.erp.datasource.entities.Depot;
import com.gw.erp.datasource.entities.DepotExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface DepotMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table gw_depot
     *
     * @mbggenerated
     */
    int countByExample(DepotExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table gw_depot
     *
     * @mbggenerated
     */
    int deleteByExample(DepotExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table gw_depot
     *
     * @mbggenerated
     */
    int deleteByPrimaryKey(Long id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table gw_depot
     *
     * @mbggenerated
     */
    int insert(Depot record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table gw_depot
     *
     * @mbggenerated
     */
    int insertSelective(Depot record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table gw_depot
     *
     * @mbggenerated
     */
    List<Depot> selectByExample(DepotExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table gw_depot
     *
     * @mbggenerated
     */
    Depot selectByPrimaryKey(Long id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table gw_depot
     *
     * @mbggenerated
     */
    int updateByExampleSelective(@Param("record") Depot record, @Param("example") DepotExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table gw_depot
     *
     * @mbggenerated
     */
    int updateByExample(@Param("record") Depot record, @Param("example") DepotExample example);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table gw_depot
     *
     * @mbggenerated
     */
    int updateByPrimaryKeySelective(Depot record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table gw_depot
     *
     * @mbggenerated
     */
    int updateByPrimaryKey(Depot record);
}