package com.g06.springboot.mapper;
/**
 *@Description Mapper接口 mybatis 通过Mapper接口执行xml中的mysql方法
 *@Author ZSY
 *@Date 2020/12/27 13:48
 */

import com.g06.springboot.entity.User;
import org.springframework.stereotype.Repository;
@Repository
public interface UserMapper {
	/**
	 *检查该用户是否注册
	 * @param username:用户名
	 * @return int
	 **/
	int checkReg(String username);

	/**
	 * 用户注册
	 * @param username:用户名
	 * @param password:密码
	 * @return User
	 **/
	int register(String username, String password);

	/**
	 * 用户登录
	 * @param username:用户名
	 * @param password:密码
	 * @return int
	 **/
	User login(String username, String password);

	/**
	 * 通过用户名查找用户id
	 * @param username: 用户名
	 * @return String
	 **/
	int searchUser(String username);

}
