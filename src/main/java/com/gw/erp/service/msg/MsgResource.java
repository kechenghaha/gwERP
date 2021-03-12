package com.gw.erp.service.msg;

import com.gw.erp.service.ResourceInfo;

import java.lang.annotation.*;

@ResourceInfo(value = "msg")
@Inherited
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface MsgResource {
}
