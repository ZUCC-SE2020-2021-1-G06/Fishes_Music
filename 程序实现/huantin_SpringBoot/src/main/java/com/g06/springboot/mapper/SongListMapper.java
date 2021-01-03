package com.g06.springboot.mapper;

import com.g06.springboot.entity.SongList;
import org.springframework.stereotype.Repository;

/**
 *@Description 歌单Mapper接口
 *@Author ZSY
 *@Date 2020/12/27 21:32
 */
@Repository
public interface SongListMapper {
	/**
	 * 检查是否存在同名歌单
	 * @param userId:用户ID
	 * @param songListName:歌单名
	 * @return SongList
	 **/
	SongList checkList(int userId, String songListName);

	/**
	 * 添加歌单
	 * @param userId:用户ID
	 * @param songListName:歌单名
	 * @param songListProfile:歌单简介
	 * @return void
	 **/
	void addList(int userId, String songListName, String songListProfile);

	/**
	 * 删除歌单
	 * @param userId:用户ID
	 * @param songListName:歌单名
	 * @return void
	 **/
	void removeList(int userId, String songListName);

	/**
	 * 修改歌单信息
	 * @param userId:用户ID
	 * @param songListName:歌单名
	 * @param songListProfile:歌单简介
	 * @param songListAvatar:歌单图片
	 * @return void
	 **/
	void modifyList(int userId, String songListName, String songListProfile, String songListAvatar);
}
