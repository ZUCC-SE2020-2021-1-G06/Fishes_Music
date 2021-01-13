package com.g06.springboot.controller;

import com.g06.springboot.entity.Feedback;
import com.g06.springboot.service.FeedbackService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 *@Description 负责反馈建议模块的逻辑控制
 *@Author ZSY
 *@Date 2020/12/29 21:27
 */
@RestController
@RequestMapping("/feedback")
public class FeedBackController {
	@Autowired
	private FeedbackService feedbackService;

	@ResponseBody
	@RequestMapping("/add")
	public void addFeedback(@RequestParam String username,
	                        @RequestParam String suggestion){
		feedbackService.addFeedback(username,suggestion);
	}

	@ResponseBody
	@RequestMapping("/searchAll")
	public List<Feedback> loadAllFeedback(){
		return feedbackService.loadAllFeedback();
	}

	@ResponseBody
	@RequestMapping("/search")
	public List<Feedback> loadFeedback(@RequestParam String username){
		return feedbackService.loadFeedback(username);
	}

	@ResponseBody
	@RequestMapping("/modify")
	public void modifyFeedback(@RequestParam int id){
		feedbackService.modifyFeedback(id);
	}

	@ResponseBody
	@RequestMapping("/remove")
	public void removeFeedback(@RequestParam int id){
		feedbackService.removeFeedback(id);
	}


}
