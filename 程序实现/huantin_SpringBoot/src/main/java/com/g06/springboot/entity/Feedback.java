package com.g06.springboot.entity;
/**
 *@Description 反馈实体类
 *@Author ZSY
 *@Date 2020/12/29 16:41
 */
public class Feedback {
	private String useId;
	private String username;
	private String suggestion;
	private String state;

	public String getUseId() {
		return useId;
	}

	public void setUseId(String useId) {
		this.useId = useId;
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
