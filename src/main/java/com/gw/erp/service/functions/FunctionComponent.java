package com.gw.erp.service.functions;

import com.gw.erp.service.ICommonQuery;
import com.gw.erp.utils.Constants;
import com.gw.erp.utils.QueryUtils;
import com.gw.erp.utils.StringUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

@Service(value = "function_component")
@FunctionResource
public class FunctionComponent implements ICommonQuery {

    @Resource
    private FunctionService functionService;

    @Override
    public Object selectOne(Long id) throws Exception {
        return functionService.getFunction(id);
    }

    @Override
    public List<?> select(Map<String, String> map)throws Exception {
        return getFunctionsList(map);
    }

    private List<?> getFunctionsList(Map<String, String> map) throws Exception{
        String search = map.get(Constants.SEARCH);
        String name = StringUtil.getInfo(search, "name");
        String type = StringUtil.getInfo(search, "type");
        String order = QueryUtils.order(map);
        return functionService.select(name, type, QueryUtils.offset(map), QueryUtils.rows(map));
    }

    @Override
    public Long counts(Map<String, String> map) throws Exception{
        String search = map.get(Constants.SEARCH);
        String name = StringUtil.getInfo(search, "name");
        String type = StringUtil.getInfo(search, "type");
        return functionService.countFunction(name, type);
    }

    @Override
    public int insert(String beanJson, HttpServletRequest request)throws Exception {
        return functionService.insertFunction(beanJson, request);
    }

    @Override
    public int update(String beanJson, Long id, HttpServletRequest request)throws Exception {
        return functionService.updateFunction(beanJson, id, request);
    }

    @Override
    public int delete(Long id, HttpServletRequest request)throws Exception {
        return functionService.deleteFunction(id, request);
    }

    @Override
    public int batchDelete(String ids, HttpServletRequest request)throws Exception {
        return functionService.batchDeleteFunction(ids, request);
    }

    @Override
    public int checkIsNameExist(Long id, String name)throws Exception {
        return functionService.checkIsNameExist(id, name);
    }

}
