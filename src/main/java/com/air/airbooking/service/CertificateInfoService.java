package com.air.airbooking.service;

import com.air.airbooking.vo.pojo.CertificateInfo;

import java.util.List;

/**
 * @Author: 木林森里没有木
 * @Package: com.air.airbooking.mapper
 * @Project: airbooking
 * @Date: 2021/4/21 19:29
 * @description:
 **/
public interface CertificateInfoService {

    /**
     * 查询所有证件类型信息
     * @return
     */
    List<CertificateInfo> findCertificateInfo();

}
