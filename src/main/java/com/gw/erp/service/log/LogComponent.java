package com.gw.erp.service.log;

import com.gw.erp.service.ICommonQuery;
import com.gw.erp.utils.Constants;
import com.gw.erp.utils.QueryUtils;
import com.gw.erp.utils.StringUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

@Service(value = "log_component")
@LogResource
public class LogComponent implements ICommonQuery {

    @Resource
    private LogService logService;

    @Override
    public Object selectOne(Long id) throws Exception {
        return logService.getLog(id);
    }

    @Override
    public List<?> select(Map<String, String> map)throws Exception {
        return getLogList(map);
    }

    private List<?> getLogList(Map<String, String> map)throws Exception {
        String search = map.get(Constants.SEARCH);
        String operation = StringUtil.getInfo(search, "operation");
        Integer userId = StringUtil.parseInteger(StringUtil.getInfo(search, "userId"));
        String clientIp = StringUtil.getInfo(search, "clientIp");
        Integer status = StringUtil.parseInteger(StringUtil.getInfo(search, "status"));
        String beginTime = StringUtil.getInfo(search, "beginTime");
        String endTime = StringUtil.getInfo(search, "endTime");
        String content = StringUtil.getInfo(search, "content");
        return logService.select(operation, userId, clientIp, status, beginTime, endTime, content,
                QueryUtils.offset(map), QueryUtils.rows(map));
    }

    @Override
    public Long counts(Map<String, String> map)throws Exception {
        String search = map.get(Constants.SEARCH);
        String operation = StringUtil.getInfo(search, "operation");
        Integer userId = StringUtil.parseInteger(StringUtil.getInfo(search, "userId"));
        String clientIp = StringUtil.getInfo(search, "clientIp");
        Integer status = StringUtil.parseInteger(StringUtil.getInfo(search, "status"));
        String beginTime = StringUtil.getInfo(search, "beginTime");
        String endTime = StringUtil.getInfo(search, "endTime");
        String content = StringUtil.getInfo(search, "content");
        return logService.countLog(operation, userId, clientIp, status, beginTime, endTime, content);
    }

    @Override
    public int insert(String beanJson, HttpServletRequest request)throws Exception {
        return logService.insertLog(beanJson, request);
    }

    @Override
    public int update(String beanJson, Long id, HttpServletRequest request)throws Exception {
        return logService.updateLog(beanJson, id, request);
    }

    @Override
    public int delete(Long id, HttpServletRequest request)throws Exception {
        return logService.deleteLog(id, request);
    }

    @Override
    public int batchDelete(String ids, HttpServletRequest request)throws Exception {
        return logService.batchDeleteLog(ids, request);
    }

    @Override
    public int checkIsNameExist(Long id, String name)throws Exception {
        return 0;
    }

}
