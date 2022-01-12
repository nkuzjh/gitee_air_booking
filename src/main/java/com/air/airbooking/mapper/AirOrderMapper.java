package com.air.airbooking.mapper;

import com.air.airbooking.vo.pojo.AirOrder;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * @Author: 木林森里没有木
 * @Package: com.air.mapper
 * @Project: air_booking
 * @Date: 2021/4/14 19:12
 * @description:
 **/
@Mapper
public interface AirOrderMapper {

    /**
     *
     * @param airOrder
     * @return
     */
    int addAirOrder(AirOrder airOrder);

    /**
     * 按照id
     * @param operatesId
     * @return
     */
    List<AirOrder> findByOperateId(Integer operatesId);
}
