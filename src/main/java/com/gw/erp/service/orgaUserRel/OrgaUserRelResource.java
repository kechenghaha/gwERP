package com.gw.erp.service.orgaUserRel;

import com.gw.erp.service.ResourceInfo;

import java.lang.annotation.*;


@ResourceInfo(value = "orgaUserRel")
@Inherited
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface OrgaUserRelResource {

}
