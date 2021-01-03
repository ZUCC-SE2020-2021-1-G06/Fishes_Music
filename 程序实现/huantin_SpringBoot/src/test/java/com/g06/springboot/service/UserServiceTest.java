package com.g06.springboot.service;

import com.g06.springboot.SpringbootApplication;
import com.g06.springboot.entity.User;



import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

/**
 *@Description UserService的单元测试类
 *@Author ZSY
 *@Date 2020/12/28 15:47
 */

@RunWith(SpringRunner.class)
@SpringBootTest(classes = SpringbootApplication.class)
public class UserServiceTest {
	@Autowired
	private UserService userService;

	@Test
	public void getLogin(){
		User login1 = userService.login("admin", "admin");
		Assert.assertEquals("登录用户名测试失败","admin",login1.getUsername());
		Assert.assertEquals("登录密码测试失败","admin",login1.getPassword());

		User login2 = userService.login("admin", "123");
		Assert.assertNull("未注册用户登录测试失败", login2);
	}

	@Test
	public void getRegister(){
		int returnNum = userService.register("user002","123456");
		Assert.assertEquals("用户注册失败",1,returnNum);
	}

	@Test
	public void getCheckReg(){
		int returnNum = userService.checkReg("user001");
		Assert.assertEquals("查找已注册用户失败",1,returnNum);
	}



}
