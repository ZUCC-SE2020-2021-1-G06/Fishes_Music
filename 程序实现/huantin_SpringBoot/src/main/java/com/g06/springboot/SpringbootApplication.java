package com.g06.springboot;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
/**
 *@Description Spring boot启动类
 *@Author ZSY
 *@Date 2020/12/27 14:43
 */

@MapperScan("com.g06.springboot.mapper")
@SpringBootApplication
public class SpringbootApplication {

	public static void main(String[] args) {
		SpringApplication.run(SpringbootApplication.class, args);
	}

}
