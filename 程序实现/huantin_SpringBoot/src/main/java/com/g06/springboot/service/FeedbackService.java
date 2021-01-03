package com.g06.springboot.service;

import com.g06.springboot.entity.Feedback;
import com.g06.springboot.mapper.FeedbackMapper;
import com.g06.springboot.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 *@Description FeedbackService 调用 FeedbackMapper 数据库方法
 *@Author ZSY
 *@Date 2020/12/29 17:04
 */
@Service
public class FeedbackService {
	@Autowired
	FeedbackMapper feedbackMapper;
	@Autowired
	UserMapper userMapper;

	public List<Feedback> loadAllFeedback(){
		return feedbackMapper.loadAllFeedback();
	}


	public List<Feedback> loadFeedback(String username){
		int userId = userMapper.searchUser(username);
		return feedbackMapper.loadFeedback(userId);
	}

	public void addFeedback(String username, String suggestion){
		int userId = userMapper.searchUser(username);
		feedbackMapper.addFeedback(userId,suggestion);
	}

	public void removeFeedback(int id){
		feedbackMapper.removeFeedback(id);
	}

	public void modifyFeedback(int id){
		feedbackMapper.modifyFeedBack(id);
	}
}
