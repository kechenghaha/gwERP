package com.gw.erp.service.supplier;

import com.gw.erp.service.ResourceInfo;

import java.lang.annotation.*;

@ResourceInfo(value = "supplier")
@Inherited
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface SupplierResource {
}
