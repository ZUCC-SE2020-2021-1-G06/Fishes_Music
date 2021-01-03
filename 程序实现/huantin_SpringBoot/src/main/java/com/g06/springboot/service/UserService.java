package com.g06.springboot.service;


import com.g06.springboot.entity.User;
import com.g06.springboot.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
/**
 *@Description userService 调用 userMapper的数据库方法
 *@Author ZSY
 *@Date 2020/12/27 14:42
 */
@Service
public class UserService {
	@Autowired
	UserMapper userMapper;
	public User login(String username,String password){
		return userMapper.login(username,password);
	}
	public int register(String username, String password){
		return  userMapper.register(username,password);
	}
	public int checkReg(String username){
		return userMapper.checkReg(username);
	}

}
