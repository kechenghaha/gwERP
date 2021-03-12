package com.gw.erp.service.platformConfig;

import com.gw.erp.service.ResourceInfo;

import java.lang.annotation.*;

@ResourceInfo(value = "platformConfig")
@Inherited
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface PlatformConfigResource {
}
