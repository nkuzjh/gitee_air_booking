package com.air.airbooking.mapper;

import com.air.airbooking.vo.pojo.CertificateInfo;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * @Author: 木林森里没有木
 * @Package: com.air.airbooking.mapper
 * @Project: airbooking
 * @Date: 2021/4/21 19:29
 * @description:
 **/
@Mapper
public interface CertificateInfoMapper {

    /**
     * 查询所有证件类型信息
     * @return
     */
    List<CertificateInfo> findCertificateInfo();

}
