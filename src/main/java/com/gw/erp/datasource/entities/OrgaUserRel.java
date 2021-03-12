package com.gw.erp.datasource.entities;

import java.util.Date;

public class OrgaUserRel {
    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column gw_orga_user_rel.id
     *
     * @mbggenerated
     */
    private Long id;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column gw_orga_user_rel.orga_id
     *
     * @mbggenerated
     */
    private Long orgaId;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column gw_orga_user_rel.user_id
     *
     * @mbggenerated
     */
    private Long userId;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column gw_orga_user_rel.user_blng_orga_dspl_seq
     *
     * @mbggenerated
     */
    private String userBlngOrgaDsplSeq;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column gw_orga_user_rel.delete_flag
     *
     * @mbggenerated
     */
    private String deleteFlag;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column gw_orga_user_rel.create_time
     *
     * @mbggenerated
     */
    private Date createTime;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column gw_orga_user_rel.creator
     *
     * @mbggenerated
     */
    private Long creator;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column gw_orga_user_rel.update_time
     *
     * @mbggenerated
     */
    private Date updateTime;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column gw_orga_user_rel.updater
     *
     * @mbggenerated
     */
    private Long updater;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column gw_orga_user_rel.tenant_id
     *
     * @mbggenerated
     */
    private Long tenantId;

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column gw_orga_user_rel.id
     *
     * @return the value of gw_orga_user_rel.id
     *
     * @mbggenerated
     */
    public Long getId() {
        return id;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column gw_orga_user_rel.id
     *
     * @param id the value for gw_orga_user_rel.id
     *
     * @mbggenerated
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column gw_orga_user_rel.orga_id
     *
     * @return the value of gw_orga_user_rel.orga_id
     *
     * @mbggenerated
     */
    public Long getOrgaId() {
        return orgaId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column gw_orga_user_rel.orga_id
     *
     * @param orgaId the value for gw_orga_user_rel.orga_id
     *
     * @mbggenerated
     */
    public void setOrgaId(Long orgaId) {
        this.orgaId = orgaId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column gw_orga_user_rel.user_id
     *
     * @return the value of gw_orga_user_rel.user_id
     *
     * @mbggenerated
     */
    public Long getUserId() {
        return userId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column gw_orga_user_rel.user_id
     *
     * @param userId the value for gw_orga_user_rel.user_id
     *
     * @mbggenerated
     */
    public void setUserId(Long userId) {
        this.userId = userId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column gw_orga_user_rel.user_blng_orga_dspl_seq
     *
     * @return the value of gw_orga_user_rel.user_blng_orga_dspl_seq
     *
     * @mbggenerated
     */
    public String getUserBlngOrgaDsplSeq() {
        return userBlngOrgaDsplSeq;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column gw_orga_user_rel.user_blng_orga_dspl_seq
     *
     * @param userBlngOrgaDsplSeq the value for gw_orga_user_rel.user_blng_orga_dspl_seq
     *
     * @mbggenerated
     */
    public void setUserBlngOrgaDsplSeq(String userBlngOrgaDsplSeq) {
        this.userBlngOrgaDsplSeq = userBlngOrgaDsplSeq == null ? null : userBlngOrgaDsplSeq.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column gw_orga_user_rel.delete_flag
     *
     * @return the value of gw_orga_user_rel.delete_flag
     *
     * @mbggenerated
     */
    public String getDeleteFlag() {
        return deleteFlag;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column gw_orga_user_rel.delete_flag
     *
     * @param deleteFlag the value for gw_orga_user_rel.delete_flag
     *
     * @mbggenerated
     */
    public void setDeleteFlag(String deleteFlag) {
        this.deleteFlag = deleteFlag == null ? null : deleteFlag.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column gw_orga_user_rel.create_time
     *
     * @return the value of gw_orga_user_rel.create_time
     *
     * @mbggenerated
     */
    public Date getCreateTime() {
        return createTime;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column gw_orga_user_rel.create_time
     *
     * @param createTime the value for gw_orga_user_rel.create_time
     *
     * @mbggenerated
     */
    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column gw_orga_user_rel.creator
     *
     * @return the value of gw_orga_user_rel.creator
     *
     * @mbggenerated
     */
    public Long getCreator() {
        return creator;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column gw_orga_user_rel.creator
     *
     * @param creator the value for gw_orga_user_rel.creator
     *
     * @mbggenerated
     */
    public void setCreator(Long creator) {
        this.creator = creator;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column gw_orga_user_rel.update_time
     *
     * @return the value of gw_orga_user_rel.update_time
     *
     * @mbggenerated
     */
    public Date getUpdateTime() {
        return updateTime;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column gw_orga_user_rel.update_time
     *
     * @param updateTime the value for gw_orga_user_rel.update_time
     *
     * @mbggenerated
     */
    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column gw_orga_user_rel.updater
     *
     * @return the value of gw_orga_user_rel.updater
     *
     * @mbggenerated
     */
    public Long getUpdater() {
        return updater;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column gw_orga_user_rel.updater
     *
     * @param updater the value for gw_orga_user_rel.updater
     *
     * @mbggenerated
     */
    public void setUpdater(Long updater) {
        this.updater = updater;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column gw_orga_user_rel.tenant_id
     *
     * @return the value of gw_orga_user_rel.tenant_id
     *
     * @mbggenerated
     */
    public Long getTenantId() {
        return tenantId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column gw_orga_user_rel.tenant_id
     *
     * @param tenantId the value for gw_orga_user_rel.tenant_id
     *
     * @mbggenerated
     */
    public void setTenantId(Long tenantId) {
        this.tenantId = tenantId;
    }
}