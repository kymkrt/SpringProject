package com.spring.javaGroupS2.dao;

import org.apache.ibatis.annotations.Param;

public interface BoardDAO {

	int setPnu10FInput(@Param("code") String code,@Param("name") String name,@Param("status") String status);

}
