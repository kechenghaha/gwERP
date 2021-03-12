package com.gw.erp.exception;

import com.gw.erp.constants.ExceptionConstants;
import org.slf4j.Logger;

/**
 * 封装日志打印，收集日志
 */
public class GwException {

    public static void readFail(Logger logger, Exception e) {
        logger.error("异常码[{}],异常提示[{}],异常[{}]",
                ExceptionConstants.DATA_READ_FAIL_CODE, ExceptionConstants.DATA_READ_FAIL_MSG,e);
        throw new BusinessRunTimeException(ExceptionConstants.DATA_READ_FAIL_CODE,
                ExceptionConstants.DATA_READ_FAIL_MSG);
    }

    public static void writeFail(Logger logger, Exception e) {
        logger.error("异常码[{}],异常提示[{}],异常[{}]",
                ExceptionConstants.DATA_WRITE_FAIL_CODE,ExceptionConstants.DATA_WRITE_FAIL_MSG,e);
        throw new BusinessRunTimeException(ExceptionConstants.DATA_WRITE_FAIL_CODE,
                ExceptionConstants.DATA_WRITE_FAIL_MSG);
    }


}
