package com.g06.springboot.entity;
/**
 *@Description 反馈实体类
 *@Author ZSY
 *@Date 2020/12/29 16:41
 */
public class Feedback {
	private int id;
	private String userId;
	private String username;
	private String suggestion;
	private String state;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getUseId() {
		return userId;
	}

	public void setUseId(String useId) {
		this.userId = useId;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getSuggestion() {
		return suggestion;
	}

	public void setSuggestion(String suggestion) {
		this.suggestion = suggestion;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}
}
