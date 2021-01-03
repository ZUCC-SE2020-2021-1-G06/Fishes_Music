package com.g06.springboot.entity;
/**
 *@Description User实体类
 *@Author ZSY
 *@Date 2020/12/27 14:41
 */
public class User {
	private String id;
	private String username;
	private String password;
	private String avatar;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getAvatar() {
		return avatar;
	}

	public void setAvatar(String avatar) {
		this.avatar = avatar;
	}

	@Override
	public String toString() {
		return "User{" +
				"id='" + id + '\'' +
				", username='" + username + '\'' +
				", password='" + password + '\'' +
				", avatar='" + avatar + '\'' +
				'}';
	}
}
