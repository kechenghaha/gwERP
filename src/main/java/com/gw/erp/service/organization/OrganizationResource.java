package com.gw.erp.service.organization;

import com.gw.erp.service.ResourceInfo;

import java.lang.annotation.*;


@ResourceInfo(value = "organization")
@Inherited
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface OrganizationResource {
}
