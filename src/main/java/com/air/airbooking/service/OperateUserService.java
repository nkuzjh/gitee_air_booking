package com.air.airbooking.service;


import com.air.airbooking.vo.pojo.OperateUser;

import java.util.Map;

/**
 * @Author: 木林森里没有木
 * @Package: com.air.mapper
 * @Project: air_booking
 * @Date: 2021/4/14 15:35
 * @description: 操作用户Mapper层操作
 **/
public interface OperateUserService {
    /**
     * 新增用户信息
     * @param operateUser
     * @return
     */
    int register(OperateUser operateUser);

    /**
     * 登录
     * @param map
     * @return
     */
    OperateUser login(Map<String, Object> map);


}
