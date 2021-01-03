package com.g06.springboot.controller;

import com.g06.springboot.entity.User;
import com.g06.springboot.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
/**
 *@Description 负责用户模块的逻辑控制
 *@Author ZSY
 *@Date 2020/12/27 14:39
 */
@RestController
@RequestMapping("/user")
public class UserController {
	@Autowired
	private UserService userService;

	@ResponseBody
	@RequestMapping("/login")
	public User loginUser(@RequestParam("username") String username,
	                    @RequestParam("password") String password){
		return userService.login(username,password);
	}

	@ResponseBody
	@RequestMapping("/register")
	public User regUser(@RequestParam("username") String username,
	                        @RequestParam("password") String password){
		int check = userService.checkReg(username);
		if(check == 0){
			userService.register(username,password);
			return userService.login(username,password);
		}
		else{
			return null;
		}

	}
}
