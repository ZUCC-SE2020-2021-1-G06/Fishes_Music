package com.g06.springboot.controller;

import com.g06.springboot.SpringbootApplication;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

/**
 *@Description UserController 单元测试
 *@Author ZSY
 *@Date 2020/12/28 22:06
 */
@RunWith(SpringRunner.class)
@SpringBootTest(classes = SpringbootApplication.class)
public class UserControllerTest {
	private UserController userController;
}
