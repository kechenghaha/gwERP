package com.gw.erp.service.depotItem;

import com.gw.erp.service.ResourceInfo;

import java.lang.annotation.*;

@ResourceInfo(value = "depotItem")
@Inherited
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface DepotItemResource {
}
