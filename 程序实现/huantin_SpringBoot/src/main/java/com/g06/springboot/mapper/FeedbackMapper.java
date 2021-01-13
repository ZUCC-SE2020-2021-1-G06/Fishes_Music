package com.g06.springboot.mapper;

import com.g06.springboot.entity.Feedback;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 *@Description 反馈Mapper接口
 *@Author ZSY
 *@Date 2020/12/29 16:40
 */
@Repository
public interface FeedbackMapper {
	/**
	 * 加载所有反馈
	 *
	 * @return FeedBack
	 **/
	List<Feedback> loadAllFeedback();

	/**
	 * 加载该用户的所有反馈
	 * @param userId:用户Id
	 * @return FeedBack
	 **/
	List<Feedback> loadFeedback(int userId);

	/**
	 *添加用户反馈
	 * @param userId:用户Id
	 * @param suggestion:建议
	 * @return void
	 **/
	void addFeedback(int userId,String suggestion);

	/**
	 * 删除反馈
	 * @param id:反馈Id
	 * @return void
	 **/
	void removeFeedback(int id);

	/**
	 * 修改反馈
	 * @param id:反馈Id
	 * @return void
	 **/
	void modifyFeedback(int id);
}
