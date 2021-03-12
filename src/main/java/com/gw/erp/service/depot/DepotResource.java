package com.gw.erp.service.depot;

import com.gw.erp.service.ResourceInfo;

import java.lang.annotation.*;

@ResourceInfo(value = "depot")
@Inherited
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface DepotResource {
}
